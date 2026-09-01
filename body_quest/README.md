# Body Quest Flutter MVP

현재 구현 범위: 회원가입 → 프로필 → 선택적 인바디 → 기본 캐릭터 → 홈.

## 바로 화면 확인하기

1. Flutter SDK를 설치한다.
2. 이 폴더에서 `flutter pub get`
3. Firebase 없이 UI 확인: `flutter run -d chrome`

기본값은 메모리 저장소라 Firebase 설정 없이 흐름을 확인할 수 있다.

## Firebase 연결

1. Firebase Console에서 Android/iOS 앱을 추가한다.
2. `dart pub global activate flutterfire_cli`
3. `flutterfire configure`
4. Authentication에서 이메일/비밀번호를 활성화한다.
5. Firestore Database를 생성한다.
6. `firebase deploy --only firestore:rules,firestore:indexes`
7. `flutter run --dart-define=USE_FIREBASE=true`

주의: 생성된 Firebase 플랫폼 설정은 프로젝트 정책을 확인한 후 관리한다. 서비스 계정 키는 커밋하지 않는다.
