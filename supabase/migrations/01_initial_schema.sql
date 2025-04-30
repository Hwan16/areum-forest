-- Create activity_types table and insert initial data
create table activity_types (
    type_code text primary key 
        check (type_code in ('all', 'forest_play')),
    display_name text not null,
    description text not null
);

insert into activity_types (type_code, display_name, description) 
values 
    ('all', '모두 (숲 놀이 + 체험 활동)', '숲 놀이와 체험 활동을 모두 포함하는 프로그램입니다.'),
    ('forest_play', '숲 놀이만', '숲 놀이 활동만 진행하는 프로그램입니다.');

-- Create time_slots table and insert initial data
create table time_slots (
    slot_name text primary key 
        check (slot_name in ('morning', 'afternoon')),
    display_name text not null,
    start_time time not null,
    end_time time not null,
    max_participants integer not null default 50
);

insert into time_slots (slot_name, display_name, start_time, end_time) 
values 
    ('morning', '오전반', '09:00', '13:00'),
    ('afternoon', '오후반', '14:00', '18:00');

-- Create closed_slots table
create table closed_slots (
    id uuid primary key default gen_random_uuid(),
    date date not null,
    time_slot text not null 
        check (time_slot in ('morning', 'afternoon', 'all')),
    reason text,
    created_at timestamp with time zone default now(),
    created_by uuid references auth.users(id),
    unique(date, time_slot)
);

create index idx_closed_slots_date 
    on closed_slots(date);

-- Create reservations table
create table reservations (
    id uuid primary key default gen_random_uuid(),
    institution_name text not null,
    reserver_name text not null,
    phone_number text not null,
    participant_count integer not null 
        check (participant_count >= 1 and participant_count <= 50),
    activity_type text not null 
        check (activity_type in ('all', 'forest_play')),
    parent_participation boolean not null,
    reservation_date date not null,
    time_slot text not null 
        check (time_slot in ('morning', 'afternoon')),
    status text not null default 'confirmed'
        check (status in ('confirmed', 'cancelled')),
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
);

create index idx_reservations_date_slot 
    on reservations(reservation_date, time_slot);

-- Create function to check slot availability
create or replace function is_slot_available(
    check_date date,
    check_slot text
) returns boolean as $$
begin
    -- 일요일 체크
    if extract(dow from check_date) = 0 then
        return false;
    end if;
    
    -- 마감 여부 체크
    if exists (
        select 1 from closed_slots 
        where date = check_date 
        and (time_slot = check_slot or time_slot = 'all')
    ) then
        return false;
    end if;
    
    return true;
end;
$$ language plpgsql;

-- Create trigger for reservation validation
create or replace function check_reservation_validity()
returns trigger as $$
begin
    -- 일요일 체크
    if extract(dow from NEW.reservation_date) = 0 then
        raise exception '일요일은 예약이 불가능합니다.';
    end if;
    
    -- 마감 여부 체크
    if not is_slot_available(NEW.reservation_date, NEW.time_slot) then
        raise exception '해당 시간대는 예약이 마감되었습니다.';
    end if;
    
    return NEW;
end;
$$ language plpgsql;

create trigger check_reservation_before_insert
    before insert on reservations
    for each row
    execute function check_reservation_validity();

-- Enable Row Level Security (RLS)
alter table reservations enable row level security;
alter table closed_slots enable row level security;
alter table activity_types enable row level security;
alter table time_slots enable row level security;

-- Create policies
create policy "Anyone can view activity types"
    on activity_types for select
    to authenticated, anon
    using (true);

create policy "Anyone can view time slots"
    on time_slots for select
    to authenticated, anon
    using (true);

create policy "Anyone can view closed slots"
    on closed_slots for select
    to authenticated, anon
    using (true);

create policy "Only admins can manage closed slots"
    on closed_slots for all
    to authenticated
    using (auth.role() = 'admin')
    with check (auth.role() = 'admin');

create policy "Anyone can create reservations"
    on reservations for insert
    to authenticated, anon
    with check (true);

create policy "Users can view their own reservations"
    on reservations for select
    to authenticated, anon
    using (true);

create policy "Only admins can manage all reservations"
    on reservations for all
    to authenticated
    using (auth.role() = 'admin')
    with check (auth.role() = 'admin'); 