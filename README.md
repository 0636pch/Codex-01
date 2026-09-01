# Body Quest

> 게임 캐릭터가 아니라 현실의 내 몸을 레벨업한다.

운동·음식·신체 기록을 RPG의 경험치, 레벨, 능력치와 캐릭터 성장으로 연결하는 Flutter 모바일 앱입니다.

## 현재 상태

STEP 1~9의 시스템 설계를 완료했고, STEP 10의 첫 Flutter 코드를 `body_quest/`에 구현했습니다.

현재 실행 흐름:

`회원가입 → 프로필 입력 → 선택적 인바디 → 캐릭터 생성 → HOME`

- Flutter + Riverpod + go_router
- Firebase Authentication + Cloud Firestore
- Firebase 연결 전 UI 확인용 메모리 모드
- Firebase 연결 후 실제 저장 모드
- Firestore 규칙과 색인 초안
- GitHub Actions 자동 분석 및 위젯 테스트

## 문서

- [STEP 1 앱 구조](docs/STEP_01_APP_ARCHITECTURE.md)
- [STEP 2 화면 구조](docs/STEP_02_SCREEN_STRUCTURE.md)
- [STEP 3 Firebase DB](docs/STEP_03_FIREBASE_DATA_MODEL.md)
- [STEP 4 EXP](docs/STEP_04_EXP_SYSTEM.md)
- [STEP 5 레벨](docs/STEP_05_LEVEL_SYSTEM.md)
- [STEP 6 캐릭터 변화](docs/STEP_06_CHARACTER_ALGORITHM.md)
- [STEP 7 칼로리](docs/STEP_07_CALORIE_SYSTEM.md)
- [STEP 8 개발 순서](docs/STEP_08_MVP_ROADMAP.md)
- [STEP 9 폴더 구조](docs/STEP_09_FLUTTER_STRUCTURE.md)
- [STEP 10 첫 코드](docs/STEP_10_FIRST_FLUTTER_CODE.md)

## 실행

```bash
cd body_quest
flutter create .
flutter pub get
flutter run -d chrome
```

기본 실행은 Firebase 없이 화면 흐름을 확인하는 메모리 모드입니다.

Firebase 프로젝트 연결 후:

```bash
flutterfire configure
flutter run --dart-define=USE_FIREBASE=true
```

세부 설정은 [앱 실행 안내](body_quest/README.md)를 확인하세요.

## 안전 원칙

- 운동을 무한히 많이 할수록 EXP가 폭증하지 않게 제한한다.
- 극단적인 칼로리 적자를 보상하지 않는다.
- 단일 체중·인바디 측정으로 캐릭터가 급변하지 않는다.
- 건강 수치를 외모의 성공·실패로 평가하지 않는다.
- 서비스 계정 키나 비밀키를 저장소에 올리지 않는다.
