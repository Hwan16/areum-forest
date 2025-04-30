# System Patterns - 아름유아 숲 체험원 예약 시스템

## 아키텍처 개요

- **Frontend**: React + Next.js + TypeScript + Tailwind CSS
- **API Layer**: Next.js API Routes / Serverless Functions
- **Business Logic Layer**: DB Helpers, Validators
- **Database**: Supabase / PostgreSQL

## 인증 아키텍처

- Client Request + JWT Token → 
- API Route Middleware (withAuth/withAdmin) → 
- Supabase Auth Token Verification → 
- Protected Resources

## 주요 디자인 패턴

1. **서버 컴포넌트/클라이언트 컴포넌트 분리**
   - Next.js App Router의 서버/클라이언트 컴포넌트 모델 활용
   - 데이터 패칭은 서버 컴포넌트에서 처리하여 성능 최적화
   - 상호작용이 필요한 UI는 클라이언트 컴포넌트로 분리

2. **API Middleware Pattern**
   - 인증 및 권한 관리를 위한 미들웨어 적용
   - 요청 검증 및 정제를 위한 미들웨어 레이어

3. **Repository Pattern**
   - 데이터 접근 로직 추상화
   - Supabase 클라이언트 중앙화 관리
   - 재사용 가능한 데이터 접근 함수 구현

4. **Error Handling Pattern**
   - 일관된 에러 처리 및 재시도 로직 (withRetry)
   - 사용자 친화적인 에러 메시지 제공
   - 로그 및 모니터링을 위한 에러 캡처

5. **Factory Pattern**
   - 예약 ID 및 레코드 생성 로직 표준화
   - 데이터 객체 생성 추상화

## 데이터 흐름 패턴

1. **예약 프로세스 흐름**:
   - 날짜 선택 → 시간대 선택 → 예약 정보 입력 → 
   - 예약 검증 → Supabase 저장 → 확인 메시지 → 관리자 SMS 알림(알리고 API)

2. **API 요청 흐름**:
   - 클라이언트 요청 (JWT 토큰 포함) →
   - API 미들웨어 (인증/권한 검증) →
   - 입력 검증 →
   - 비즈니스 로직 처리 →
   - Supabase 쿼리 실행 →
   - 응답 반환

3. **에러 처리 흐름**:
   - 쿼리 실행 →
   - 에러 발생 시 코드 확인 →
   - 재시도 가능 여부 판단 →
   - 재시도 또는 에러 반환 →
   - 사용자에게 적절한 메시지 표시

## 컴포넌트 구조

1. **레이아웃 컴포넌트**:
   - `RootLayout`: 전체 앱 레이아웃 (메타데이터, 글로벌 스타일)
   - `AuthLayout`: 인증 관련 페이지 레이아웃
   - `AdminLayout`: 관리자 페이지 레이아웃

2. **예약 플로우 컴포넌트**:
   - Calendar → TimeSelection → ReservationForm → Confirmation

3. **관리자 컴포넌트**:
   - AdminDashboard → AdminReservationView → ReservationDetails

4. **공통 UI 컴포넌트**:
   - `Button`, `Input`, `Modal`, `Card`, `Alert` 등

## 상태 관리 전략

1. **서버 상태**:
   - Supabase 실시간 구독을 통한 데이터 동기화
   - 서버 컴포넌트에서 데이터 프리페칭

2. **클라이언트 상태**:
   - React 상태 훅(useState, useReducer)을 통한 지역 상태 관리
   - Context API를 통한 전역 상태 관리 (인증, 테마 등)

## 데이터베이스 설계 원칙

1. **테이블 구조 최적화**:
   - 정규화된 테이블 설계
   - 적절한 인덱스 설정

2. **보안 정책**:
   - Row Level Security(RLS) 정책으로 데이터 보호
   - 역할 기반 접근 제어

3. **트랜잭션 처리**:
   - 에지 케이스 처리를 위한 트랜잭션 활용
   - 예약 생성/변경/취소 시 데이터 일관성 보장

## 성능 최적화 전략

1. **서버 사이드 렌더링**:
   - SEO 및 초기 로딩 속도 개선을 위한 SSR 활용
   - 적절한 캐싱 전략 적용

2. **코드 스플리팅**:
   - 페이지 및 컴포넌트 레벨 코드 스플리팅
   - 동적 임포트 활용

3. **이미지 최적화**:
   - Next.js Image 컴포넌트 사용
   - Supabase Storage CDN 활용

## 배포 아키텍처

1. **Vercel 배포**:
   - Next.js 애플리케이션 배포
   - 환경 변수 관리
   - CI/CD 파이프라인

2. **Supabase 인프라**:
   - PostgreSQL 데이터베이스
   - 인증 및 사용자 관리
   - Edge Functions 활용
   - Storage 서비스 (이미지 저장)