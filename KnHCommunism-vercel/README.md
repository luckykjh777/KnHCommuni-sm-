# KnHCommunism — Vercel + Supabase

친구들끼리 사용하는 소규모 커뮤니티 초기 버전입니다.

## 포함 기능
- 이메일 회원가입 및 로그인 (Supabase Auth)
- 프로필 닉네임 자동 생성
- 자유게시판 글 작성/목록/삭제
- 게시글 댓글 작성/삭제
- 반응형 커뮤니티 UI

## 1. Supabase 설정
1. Supabase에서 프로젝트 생성
2. SQL Editor에서 `supabase-setup.sql` 전체 실행
3. Project Settings → API Keys 또는 Connect에서 Project URL과 Publishable key 확인
4. `index.html`의 아래 두 값을 교체

```js
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_PUBLISHABLE_KEY';
```

브라우저에 넣는 키는 Publishable key(`sb_publishable_...`) 또는 legacy anon key만 사용합니다. `service_role` / `sb_secret_` 키는 절대 넣지 마세요. RLS 정책이 활성화되어 있습니다.

## 2. Vercel 배포
1. GitHub에 새 저장소 `KnHCommunism` 생성
2. 이 폴더 안의 `index.html`, `supabase-setup.sql`, `README.md`를 저장소 최상위에 업로드
3. Vercel 로그인 → Add New → Project → GitHub 저장소 Import
4. Framework Preset은 `Other`, Build Command와 Output Directory는 비워두고 Deploy
5. 배포 후 `https://프로젝트명.vercel.app` 접속

## 3. Supabase 인증 URL
Authentication → URL Configuration에서:
- Site URL: Vercel 배포 주소
- Redirect URLs: Vercel 배포 주소와 `https://프로젝트명-*.vercel.app/**` (Preview 배포를 쓸 때)

## 주의
- 이 버전은 원본의 나무위키형 문서 편집기/테마/이미지/토론 코드를 통째로 Supabase로 이전한 완성판은 아닙니다. 현재는 로그인 + 공유 자유게시판 + 댓글이 동작하는 기반 버전입니다.
- 원본 코드는 LocalStorage를 사용하므로 다른 친구의 브라우저와 데이터가 공유되지 않습니다. 위키 문서와 토론을 여러 사용자에게 공유하려면 다음 단계에서 DB 동기화 및 Supabase Storage/Realtime을 추가해야 합니다.


## 계정 로그인 설정

### Gmail 주소 + KnHCommunism 비밀번호
- 회원가입 화면에서 Gmail 주소, 닉네임, 비밀번호를 입력합니다.
- 비밀번호는 **KnHCommunism 전용 비밀번호**입니다. 실제 Gmail 비밀번호를 입력하지 마세요.
- Supabase Dashboard → Authentication → Sign In / Providers에서 Email provider를 활성화합니다.
- 이메일 인증을 켜 두었다면 가입 후 Gmail로 온 인증 링크를 눌러야 로그인할 수 있습니다.
- 비밀번호 재설정 링크도 가입한 Gmail 주소로 발송됩니다.

### Google 계정으로 로그인 (선택)
Google 버튼을 사용하려면 OAuth 설정이 추가로 필요합니다.
1. Google Cloud Console에서 OAuth Client ID를 생성합니다.
2. Authorized redirect URI에 `https://<SUPABASE_PROJECT_REF>.supabase.co/auth/v1/callback`을 등록합니다.
3. Supabase Dashboard → Authentication → Sign In / Providers → Google에서 Client ID와 Client Secret을 입력하고 활성화합니다.
4. Supabase Authentication → URL Configuration에서 Site URL과 Redirect URLs에 Vercel 배포 주소를 등록합니다.

## 이스터에그
- 상단 `✨ 비밀 기능`에서 `do a barrel roll`, `askew`, `google gravity`, `zerg rush` 등을 실행할 수 있습니다.
- 키보드 ↑ ↑ ↓ ↓ ← → ← → B A 입력으로 비밀 모드를 해금합니다.
- 로고를 빠르게 7번 클릭해도 숨겨진 점령전이 시작됩니다.

## 기존 익명 계정 관련
이 버전은 이메일 기반 계정 로그인을 사용합니다. 이전 익명 로그인으로 만든 계정은 자동으로 Gmail 계정으로 바뀌지 않습니다. 기존 익명 계정에 보관된 데이터가 있다면 Supabase에서 별도 계정 연결/데이터 이전이 필요합니다.
