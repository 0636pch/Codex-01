# 데이터 모델

## 1. 설계 원칙

- 꼭 필요한 데이터만 수집한다.
- 계정 정보와 건강 기록의 접근 권한을 분리할 수 있게 설계한다.
- 측정값은 덮어쓰기보다 시점별 기록으로 남겨 추세를 계산한다.
- 사용자가 입력한 값과 앱이 계산·추정한 값을 구분한다.
- 모든 주요 데이터에는 생성 시각과 수정 시각을 둔다.
- 아래 이름은 개념 모델이며 실제 DB 테이블명은 구현 시 정한다.

## 2. 핵심 엔터티

### UserAccount

| 항목 | 설명 | 필수 |
|---|---|---|
| id | 내부 사용자 식별자 | 예 |
| email | 로그인 이메일 | 예 |
| passwordHash | 원문이 아닌 비밀번호 해시 | 예 |
| nickname | 앱 표시 이름 | 예 |
| status | 활성, 삭제 요청 등 계정 상태 | 예 |
| createdAt, updatedAt | 생성·수정 시각 | 예 |

비밀번호는 앱 데이터베이스에 원문으로 저장하지 않습니다. 외부 인증 제공자를 쓰면 `passwordHash`의 소유 주체가 달라질 수 있습니다.

### ConsentRecord

| 항목 | 설명 |
|---|---|
| id, userId | 동의와 사용자 식별자 |
| consentType | 이용약관, 개인정보, 건강 데이터, 분석 등 |
| documentVersion | 사용자가 본 문서 버전 |
| required | 필수 동의 여부 |
| agreedAt | 동의 시각 |
| withdrawnAt | 철회 시각, 철회 전에는 없음 |

### UserProfile

| 항목 | 설명 |
|---|---|
| userId | 사용자와 1:1 연결 |
| age 또는 birthYear | 나이 표현 방식은 추후 결정 |
| heightCm | 키 |
| goal | 체중 감량, 근육 증가, 체력 향상, 유지 |
| experienceLevel | 운동 경험 수준 |
| activityLevel | 평소 활동량 |
| onboardingCompletedAt | 온보딩 완료 시각 |

현재 체중은 프로필에 고정하지 않고 `BodyMeasurement`의 최신 유효 기록에서 조회합니다.

### BodyMeasurement

체중과 인바디를 측정 시점별로 저장합니다.

| 항목 | 설명 | 필수 |
|---|---|---|
| id, userId | 식별자 | 예 |
| measuredAt | 측정 날짜·시각 | 예 |
| source | 직접 입력, 인바디 등 출처 | 예 |
| weightKg | 체중 | 상황별 |
| skeletalMuscleKg | 골격근량 | 아니요 |
| bodyFatKg | 체지방량 | 아니요 |
| bodyFatPercent | 체지방률 | 아니요 |
| bmi | BMI | 아니요 |
| visceralFatLevel | 내장지방 수준 | 아니요 |
| createdAt, updatedAt | 생성·수정 시각 | 예 |

### CharacterProfile

| 항목 | 설명 |
|---|---|
| userId | 사용자와 1:1 연결 |
| faceShapeId, hairId, skinToneId | 얼굴 관련 선택 파츠 |
| baseBodyTypeId | 사용자가 고른 기본 체형 |
| outfitId | 장착 운동복 |
| equipmentIds | 장착 장비 목록 |
| titleId | 장착 칭호 |
| growthStage | 추세 기반 성장 단계 |
| stageUpdatedAt | 단계가 마지막으로 바뀐 시각 |

### ExerciseSession과 ExerciseItem

한 번의 운동 세션 안에 여러 운동 항목이 들어갈 수 있습니다.

| 엔터티 | 주요 항목 |
|---|---|
| ExerciseSession | id, userId, startedAt, durationMinutes, category, note |
| ExerciseItem | id, sessionId, exerciseName, exerciseType, sets/reps/weight, distance, steps, intensity |
| CalorieEstimate | sessionId, calories, method, source, isEstimated |

종류별로 사용하지 않는 값은 비워 둡니다. 세트 상세를 별도 엔터티로 나눌지는 추후 결정합니다.

### Meal과 FoodItem

| 엔터티 | 주요 항목 |
|---|---|
| Meal | id, userId, eatenAt, mealType, note |
| FoodItem | id, mealId, foodName, amount, unit, caloriesKcal, proteinG, carbsG, fatG, inputSource |

칼로리와 영양소는 사용자가 직접 입력했는지, 데이터베이스에서 가져왔는지 구분할 수 있어야 합니다.

### GameProgress

| 항목 | 설명 |
|---|---|
| userId | 사용자와 1:1 연결 |
| level | 전체 레벨 |
| currentXp | 현재 레벨 내 경험치 |
| totalXp | 누적 경험치 |
| strength, endurance, consistency, recovery | 네 능력치 |
| streakDays | 현재 연속 기록 일수 |
| longestStreakDays | 최장 연속 기록 일수 |

### XpTransaction

경험치가 왜 바뀌었는지 추적하는 장부입니다.

| 항목 | 설명 |
|---|---|
| id, userId | 식별자 |
| sourceType, sourceId | 운동, 기록, 퀘스트 등 근거 |
| amount | 변화량 |
| ruleVersion | 적용한 규칙 버전 |
| idempotencyKey | 중복 지급 방지 키 |
| createdAt | 지급 시각 |

### QuestDefinition과 UserQuest

| 엔터티 | 주요 항목 |
|---|---|
| QuestDefinition | id, periodType, title, description, conditionType, target, rewardXp, activeFrom/To, ruleVersion |
| UserQuest | id, userId, questDefinitionId, periodStart/End, progress, status, completedAt, rewardedAt |

### RewardDefinition과 UserReward

| 엔터티 | 주요 항목 |
|---|---|
| RewardDefinition | id, type(의상/장비/칭호), 이름, 해금 조건, 에셋 키 |
| UserReward | userId, rewardId, unlockedAt, equippedAt |

### GrowthSnapshot

캐릭터 성장 단계 계산 근거를 보존합니다.

| 항목 | 설명 |
|---|---|
| id, userId | 식별자 |
| periodStart, periodEnd | 평가 기간 |
| inputSummary | 사용한 7일 추세·인바디 요약 |
| previousStage, calculatedStage | 전후 단계 |
| ruleVersion | 계산 규칙 버전 |
| appliedAt | 적용 시각 |

### UserSetting과 DeletionRequest

- `UserSetting`: 단위, 알림, 접근성, 시간대
- `DeletionRequest`: 요청 시각, 본인 확인 시각, 처리 상태, 완료 시각, 실패 사유

## 3. 엔터티 관계

```text
UserAccount
 ├─ 1:1 UserProfile
 ├─ 1:N ConsentRecord
 ├─ 1:1 CharacterProfile
 ├─ 1:N BodyMeasurement
 ├─ 1:N ExerciseSession ─ 1:N ExerciseItem
 ├─ 1:N Meal ─ 1:N FoodItem
 ├─ 1:1 GameProgress ─ 1:N XpTransaction
 ├─ 1:N UserQuest ─ N:1 QuestDefinition
 ├─ 1:N UserReward ─ N:1 RewardDefinition
 ├─ 1:N GrowthSnapshot
 └─ 1:N DeletionRequest
```

## 4. 화면별 데이터 연결

| 화면 | 주요 엔터티 |
|---|---|
| 회원가입·로그인 | UserAccount |
| 동의 | ConsentRecord |
| 기본 정보 | UserProfile, BodyMeasurement |
| 인바디 입력 | BodyMeasurement |
| 캐릭터 만들기 | CharacterProfile, RewardDefinition |
| 대시보드 | GameProgress, UserQuest, ExerciseSession, Meal, CharacterProfile |
| 운동 기록 | ExerciseSession, ExerciseItem, CalorieEstimate, XpTransaction |
| 식사 기록 | Meal, FoodItem |
| 성장 그래프 | BodyMeasurement, ExerciseSession, Meal, GrowthSnapshot |
| 캐릭터·능력치 | CharacterProfile, GameProgress, UserReward, XpTransaction |
| 설정·삭제 | UserAccount, UserProfile, ConsentRecord, UserSetting, DeletionRequest |

## 5. 계산 데이터와 원본 데이터

- 원본: 사용자가 입력한 운동, 식사, 체중, 인바디
- 추정: 활동 칼로리, 일부 음식 칼로리
- 파생: 일일 합계, 연속 기록, 퀘스트 진행도, 경험치, 능력치, 성장 단계

파생 데이터는 계산 규칙 버전을 남겨 나중에 결과를 설명할 수 있어야 합니다. 원본을 수정하면 관련 파생값을 안전하게 재계산합니다.

## 6. 보관과 삭제

계정 삭제 시 사용자와 연결된 프로필, 건강 기록, 게임 진행, 설정을 삭제 또는 법적 기준에 맞게 익명화합니다. 백업 반영 기간, 법적 보관 항목, 분석 데이터의 익명화 기준은 개인정보 정책 확정 후 구체화합니다.

## 7. 추후 결정 사항

- 나이를 직접 저장할지 출생연도를 저장할지
- 데이터베이스와 인증 제공자
- 로컬 오프라인 저장 항목과 암호화 방식
- 운동 세트 상세 모델의 분리 여부
- 중복 측정과 기록 수정 이력 보존 방식
- 데이터 내보내기 스키마
- 보관·백업·완전 삭제 기간
- 성장 단계 값의 개수와 단계 이름
