# Body Quest Flutter MVP

현재 구현 범위: 회원가입 → 프로필 → 선택적 인바디 → 기본 캐릭터 → 홈.

## 바로 화면 확인하기

1. Flutter SDK를 설치한다.
2. 이 폴더에서 `flutter create .`
3. Android Firebase 설정 적용: `bash tool/configure_android.sh`
4. `flutter pub get`
5. Firebase 없이 UI 확인: `flutter run -d chrome`

기본값은 메모리 저장소라 Firebase 설정 없이 흐름을 확인할 수 있다.

## Firebase 연결

1. Android 앱 `com.bodyquest.app`과 구성 파일 연결은 완료되어 있다.
2. Authentication 이메일/비밀번호와 Firestore 생성도 완료되어 있다.
3. `firebase deploy --only firestore:rules,firestore:indexes`
4. `flutter run --dart-define=USE_FIREBASE=true`

주의: 생성된 Firebase 플랫폼 설정은 프로젝트 정책을 확인한 후 관리한다. 서비스 계정 키는 커밋하지 않는다.
