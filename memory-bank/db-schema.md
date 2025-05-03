# Supabase 데이터베이스 스키마 (2025-05-03 기준)

## activity_types
- type_code (text, PK): 활동 코드
- display_name (text): 표시 이름
- description (text): 설명

## time_slots
- slot_name (text, PK): 시간대 코드
- display_name (text): 표시 이름
- start_time (time): 시작 시간
- end_time (time): 종료 시간
- max_participants (int4): 최대 인원

## closed_slots
- id (uuid, PK): 고유 ID
- date (date): 마감 날짜
- time_slot (text): 마감 시간대
- reason (text): 마감 사유
- created_at (timestamptz): 생성일시
- created_by (uuid): 마감 등록자 (auth.users.id 참조)

## reservations
- id (uuid, PK): 예약 ID
- institution_name (text): 기관명
- reserver_name (text): 예약자명
- phone_number (text): 연락처
- participant_count (int4): 참가 인원
- activity_type (text): 활동 종류
- parent_participation (bool): 보호자 동반 여부
- reservation_date (date): 예약 날짜
- time_slot (text): 예약 시간대
- status (text): 예약 상태
- created_at (timestamptz): 생성일시
- updated_at (timestamptz): 수정일시 