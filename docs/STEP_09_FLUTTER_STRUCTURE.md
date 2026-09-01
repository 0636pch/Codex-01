# STEP 9 — Flutter 폴더 및 파일 구조

기능 중심 구조와 공통 계층을 함께 사용한다.

```text
body_quest/
  android/
  ios/
  web/
  assets/
    images/characters/
    images/exercises/
  lib/
    main.dart
    app.dart
    core/
      config/
      constants/
      errors/
      routing/
        app_router.dart
      theme/
        app_theme.dart
      utils/
    features/
      auth/
        data/
        domain/
        presentation/
      onboarding/
        data/
          onboarding_repository.dart
          firebase_onboarding_repository.dart
          memory_onboarding_repository.dart
        domain/
          onboarding_profile.dart
        presentation/
          sign_up_screen.dart
          profile_screen.dart
          inbody_screen.dart
          character_screen.dart
      home/
      workout/
        data/
        domain/
        presentation/
      food/
      growth/
      character/
      settings/
    shared/
      widgets/
  functions/
    src/
      exp/
      calories/
      character/
      reports/
    test/
  test/
    unit/
    widget/
    integration/
  firebase.json
  firestore.rules
  firestore.indexes.json
  storage.rules
  pubspec.yaml
```

## 의존 방향
`presentation → domain ← data`

화면은 Firebase SDK를 직접 호출하지 않고 repository 인터페이스를 호출한다. 데이터 계층은 domain 모델로 변환한다.

## 주요 패키지
- `flutter_riverpod`: 상태 관리와 의존성 주입
- `go_router`: 인증·온보딩 경로
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Firebase
- `freezed`, `json_serializable`: 모델 생성은 기능 확장 시 도입
- `fl_chart`: 성장 그래프 단계에서 도입
- `table_calendar`: 캘린더 단계에서 도입
- `intl`: 날짜·숫자 표시

처음부터 모든 패키지를 넣지 않고 실제 구현 단계에서 추가한다.

## 환경
- `--dart-define=USE_FIREBASE=true`: Firebase 저장소 사용
- 기본 개발 모드: 메모리 저장소로 UI 흐름 즉시 확인
- Firebase 설정 후 `flutterfire configure`로 플랫폼 설정 생성

## 완료 기준
폴더, 계층, 의존 방향, 패키지 도입 시점, 개발·Firebase 실행 모드를 확정했다. 다음은 STEP 10 첫 Flutter 코드다.
