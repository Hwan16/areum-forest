# 아름유아 숲 체험원 예약 시스템

## 프로젝트 소개
아름유아 숲 체험원의 온라인 예약 시스템입니다. 사용자들이 쉽게 예약할 수 있고, 관리자가 효율적으로 예약을 관리할 수 있는 웹 애플리케이션입니다.

## 주요 기능
- 달력 기반 예약 시스템
- 관리자 대시보드
- 예약 현황 관리
- 반응형 웹 디자인

## 기술 스택
- Frontend: Next.js, TypeScript, Tailwind CSS
- Backend: Supabase (PostgreSQL, Authentication, Storage)
- Deployment: Vercel (Frontend), Supabase (Backend)

## 개발 환경 설정

### 필수 요구사항
- Node.js 18.0.0 이상
- npm 또는 yarn

### 설치 방법
```bash
# 저장소 클론
git clone https://github.com/Hwan16/areum-forest.git

# 디렉토리 이동
cd areum-forest

# 의존성 설치
npm install

# 개발 서버 실행
npm run dev
```

### 환경 변수 설정
`.env.local` 파일을 생성하고 다음 변수들을 설정하세요:
```
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

## 라이선스
This project is licensed under the MIT License. 