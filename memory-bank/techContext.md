# Technical Context

## 기술 스택
- Frontend: React 18, TypeScript, TailwindCSS
- Backend: Next.js App Router & API Routes (Serverless)
- Database: Supabase (PostgreSQL)
- State Management: React Context API + Hooks
- Form Handling: React Hook Form
- Routing: Next.js App Router
- Date Handling: date-fns
- Authentication: Supabase Auth (JWT)
- Hosting/Deployment: Vercel(프론트엔드), Supabase(백엔드)

## 개발 환경
- Node.js: v18+ LTS
- npm: v9+
- Next.js: 14+
- TypeScript: 5.x (strict 모드)

## 의존성
- UI Components: 자체 구현 + Headless UI
- Icons: lucide-react
- Database: @supabase/supabase-js
- Validation: TypeScript 타입 시스템
- API 클라이언트: Supabase Client

## 도구
- VSCode
- ESLint
- Prettier
- Git

## 데이터베이스 설계
- Supabase(PostgreSQL) 기반 데이터베이스
- Row Level Security (RLS) 활용한 보안 정책
- Supabase DB 스키마:
  - reservations: 예약 정보
  - closed_dates: 예약 불가 날짜
  - program_info: 체험 프로그램 정보

## 인증 시스템
- Supabase Auth를 통한 관리자 인증 (JWT 기반)
- 세션 관리: 자동 갱신 및 로컬 스토리지 유지
- 인증 확인: 쿠키 및 Authorization 헤더
- 권한 제어: 
  - withAuth: 일반 인증 필요 API
  - withAdmin: 관리자 권한 필요 API

## 컴포넌트 구조
### Calendar 컴포넌트
- app/components/Calendar.tsx에 위치
- 예약 가능 날짜를 시각적으로 표시하는 컴포넌트
- 주요 함수:
  - `isDateAvailable`: 날짜 선택 가능 여부 결정 (휴무일, 만석 체크)
  - `isHoliday`: 공휴일 및 휴무일(일요일) 체크
  - `formatDate`: 선택한 날짜를 API 요청에 맞게 변환
- 날짜 선택 로직:
  - 월~토요일만 예약 가능 (일요일 휴무)
  - 예약이 있어도 만석이 아니면 선택 가능
  - 각 날짜별 예약 가능 인원수는 API로부터 가져옴

### 서버 컴포넌트 vs 클라이언트 컴포넌트
- 서버 컴포넌트: 
  - 데이터 패칭 컴포넌트
  - 정적 UI 요소
  - SEO 관련 요소
- 클라이언트 컴포넌트:
  - 상호작용이 필요한 컴포넌트 (폼, 달력 등)
  - 클라이언트 상태를 다루는 컴포넌트
  - 'use client' 지시문 사용

### Supabase 연동
- lib/supabase.ts: Supabase 클라이언트 설정
- lib/db.ts: 기본 CRUD 함수 구현
- utils/error-handling.ts: 에러 처리 및 재시도 로직 (withRetry)
- middleware.ts: API 라우트 보호 및 인증 처리

## API 구조
- app/api/**: API 라우트 (Next.js App Router 구조)
- 주요 API 엔드포인트:
  - /api/reservations: 예약 CRUD
  - /api/availability: 날짜별 예약 가능 여부
  - /api/admin/*: 관리자 전용 API

## 성능 최적화
- Next.js의 이미지 최적화 사용
- 적절한 Suspense 및 동적 임포트
- 서버 컴포넌트를 활용한 초기 로딩 최적화
- 클라이언트 사이드 캐싱 전략

## 에러 처리
- 일관된 에러 응답 형식
- 클라이언트 측 에러 핸들링 공통 함수
- Supabase 연결 오류 시 재시도 로직
- 사용자 친화적인 에러 메시지

## SMS 알림 시스템
- 알리고 API 연동
- 예약 완료 시 관리자에게 자동 알림
- Edge Functions 활용 비동기 처리