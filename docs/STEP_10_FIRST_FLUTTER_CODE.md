# STEP 10 — 첫 Flutter 코드

## 이번 단계에서 만든 것
`body_quest/`에 실행 가능한 첫 Flutter 소스를 추가했다.

- 회원가입
- 기본 프로필 입력
- 선택적 인바디 입력 및 건너뛰기
- 기본 2D 캐릭터 선택
- 캐릭터 중심 HOME 화면
- 메모리 저장소와 Firebase 저장소 전환
- Firestore 보안 규칙 초안
- 첫 위젯 테스트

## 왜 필요한가
전체 기능을 만들기 전에 가장 중요한 첫 사용자 흐름을 실제 화면으로 연결해 라우팅, 입력, 데이터 계층이 함께 작동하는지 확인하기 위해서다.

## 주요 파일
- `body_quest/lib/main.dart`: 앱 시작, Firebase 모드 선택
- `body_quest/lib/app.dart`: 라우팅
- `features/onboarding/`: 가입·프로필·인바디·캐릭터
- `features/home/`: 첫 홈
- `firestore.rules`: 보안 규칙 초안

## 실행
Firebase 없이:
```bash
cd body_quest
flutter pub get
flutter run -d chrome
```

Firebase 연결 후:
```bash
flutterfire configure
flutter run --dart-define=USE_FIREBASE=true
```

## 정상 화면
QUEST 1/4 모험가 등록에서 시작해 네 단계를 완료하면 LV.1 캐릭터와 EXP 0/100이 표시되는 HOME 화면으로 이동한다.

## 현재 제한
- 캐릭터는 실제 PNG 에셋 전이라 아이콘 미리보기다.
- 약관 동의 화면은 다음 인증 고도화 묶음에서 추가한다.
- 기본 실행은 메모리 저장이므로 앱 재시작 시 초기화된다.
- Firebase 모드는 프로젝트 설정 파일이 있어야 실행된다.
- Android/iOS 플랫폼 폴더는 Flutter SDK의 `flutter create .`로 생성한다.

## 오류 확인
- `flutter: command not found`: Flutter SDK 설치
- Firebase 초기화 오류: `flutterfire configure` 재실행
- permission-denied: rules 배포 및 로그인 UID 확인
- 회원가입 반응 없음: Authentication 이메일/비밀번호 활성화 확인
