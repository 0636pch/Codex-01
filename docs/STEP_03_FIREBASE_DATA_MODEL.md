# STEP 3 — Firebase 데이터베이스 구조

## 이번 단계의 목표

Flutter 앱이 사용할 Cloud Firestore의 컬렉션, 문서, 필드 타입, 하위 컬렉션, 문서 ID, 보안 책임을 확정한다.

## 핵심 결정

기존 후보처럼 사용자 관련 데이터를 모두 루트 컬렉션으로 분리하면 쿼리와 보안 규칙이 복잡해진다. 따라서 다음처럼 나눈다.

- 사용자 개인 데이터: `users/{uid}` 아래 하위 컬렉션
- 모든 사용자가 읽는 기준 데이터: 루트 공용 컬렉션
- 서버만 확정하는 값: 사용자 문서 및 서버 관리 하위 컬렉션
- 큰 운동 세트 목록: 운동 세션의 하위 컬렉션

`uid`는 Firebase Authentication 사용자 ID를 그대로 사용한다.

## 전체 구조

```text
users/{uid}
  consents/{consentId}
  bodyMeasurements/{recordId}
  inbodyRecords/{recordId}
  workoutSessions/{sessionId}
    exercises/{sessionExerciseId}
      sets/{setId}
  foodLogs/{foodLogId}
  dailySummaries/{dateId}
  experienceLogs/{experienceLogId}
  levelHistory/{historyId}
  userQuests/{userQuestId}
  userAchievements/{achievementId}
  growthReports/{reportId}

exercises/{exerciseId}
foods/{foodId}
levelDefinitions/{level}
questDefinitions/{questId}
achievementDefinitions/{achievementId}
characterAssets/{assetId}
appConfig/{configId}
```

## Firestore 타입 표기

| 문서 표기 | Firestore 타입 |
|---|---|
| String | 문자열 |
| Number | 정수 또는 실수 |
| Boolean | 참·거짓 |
| Timestamp | Firestore 시간 |
| GeoPoint | 위치 좌표 |
| Map | 키와 값 묶음 |
| Array<String> | 문자열 배열 |
| DocumentReference | 문서 참조 |
| null | 선택값 미입력 |

금액·중량·칼로리처럼 계산하는 숫자는 문자열로 저장하지 않는다.

---

# 1. 사용자 루트 문서

## `users/{uid}`

로그인 상태, 온보딩 진행, 프로필, 현재 게임 상태처럼 자주 함께 읽는 정보를 저장한다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| uid | String | O | Firebase Auth UID |
| email | String | O | 로그인 이메일 |
| nickname | String | O | 화면 표시 닉네임 |
| gender | String | O | `male`, `female`, `other`, `undisclosed` |
| birthDate | Timestamp | O | 생년월일 |
| heightCm | Number | O | 키 |
| currentWeightKg | Number | O | 최근 체중 캐시 |
| exerciseExperience | String | O | `beginner`, `intermediate`, `advanced` |
| exerciseGoals | Array<String> | O | 운동 목적 복수 선택 |
| targetWeightKg | Number/null | X | 목표 체중 |
| targetBodyFatPercent | Number/null | X | 목표 체지방률 |
| weeklyWorkoutGoal | Number | O | 주당 목표 횟수 |
| activityLevel | String | O | 일상 활동 수준 |
| timezone | String | O | 예: `Asia/Seoul` |
| unitSystem | String | O | MVP는 `metric` |
| onboardingStep | String | O | `consent`, `profile`, `inbody`, `character`, `completed` |
| onboardingCompleted | Boolean | O | 초기 설정 완료 여부 |
| level | Number | O | 현재 전체 레벨, 서버만 수정 |
| totalExp | Number | O | 누적 EXP, 서버만 수정 |
| currentLevelExp | Number | O | 현재 레벨 안에서의 EXP 캐시 |
| nextLevelExp | Number | O | 다음 레벨 필요 EXP 캐시 |
| titleCode | String | O | 현재 등급 코드 |
| streakDays | Number | O | 현재 기록 연속 일수, 서버 계산 |
| lastActiveDateId | String/null | X | 사용자 시간대 날짜 |
| role | String | O | 기본 `user`; 권한 판단은 Custom Claims 우선 |
| profileVersion | Number | O | 프로필 구조 버전 |
| createdAt | Timestamp | O | 서버 생성 시각 |
| updatedAt | Timestamp | O | 서버 수정 시각 |
| lastLoginAt | Timestamp | O | 최근 로그인 |

나이는 매년 바뀌므로 저장하지 않고 `birthDate`에서 계산한다.

### exerciseGoals 허용값

- `weight_loss`
- `body_fat_reduction`
- `muscle_gain`
- `fitness_improvement`
- `health_management`
- `body_profile`
- `rehabilitation_function`

---

# 2. 동의 내역

## `users/{uid}/consents/{consentId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| consentType | String | O | 약관 종류 |
| documentVersion | String | O | 동의한 문서 버전 |
| required | Boolean | O | 필수 여부 |
| agreed | Boolean | O | 동의 상태 |
| agreedAt | Timestamp/null | X | 동의 시각 |
| withdrawnAt | Timestamp/null | X | 철회 시각 |
| locale | String | O | `ko-KR` |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

문서 ID 예: `terms_v1`, `privacy_v1`, `health_data_v1`.

---

# 3. 일반 신체 측정

## `users/{uid}/bodyMeasurements/{recordId}`

인바디 기기가 없어도 체중과 신체 둘레를 기록할 수 있다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| measuredAt | Timestamp | O | 측정 시각 |
| dateId | String | O | 사용자 시간대 `yyyy-MM-dd` |
| weightKg | Number | O | 체중 |
| waistCm | Number/null | X | 허리둘레 |
| chestCm | Number/null | X | 가슴둘레 |
| hipCm | Number/null | X | 엉덩이둘레 |
| thighCm | Number/null | X | 허벅지둘레 |
| upperArmCm | Number/null | X | 팔둘레 |
| note | String/null | X | 메모 |
| source | String | O | `manual`, `inbody`, 추후 `health_platform` |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

---

# 4. 인바디 기록

## `users/{uid}/inbodyRecords/{recordId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| measuredAt | Timestamp | O | 측정 시각 |
| dateId | String | O | 사용자 시간대 날짜 |
| weightKg | Number | O | 측정 체중 |
| skeletalMuscleMassKg | Number/null | X | 골격근량 |
| bodyFatMassKg | Number/null | X | 체지방량 |
| bodyFatPercent | Number/null | X | 체지방률 |
| bmi | Number/null | X | BMI |
| basalMetabolicRateKcal | Number/null | X | 기기 표시 BMR |
| visceralFatLevel | Number/null | X | 내장지방 레벨 |
| bodyWaterLiters | Number/null | X | 체수분 |
| proteinKg | Number/null | X | 단백질 |
| mineralsKg | Number/null | X | 무기질 |
| deviceName | String/null | X | 측정 기기 |
| note | String/null | X | 메모 |
| source | String | O | `manual` |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

앱은 이전 기록과 비교하지만 원본 기록 자체는 덮어쓰지 않는다.

---

# 5. 캐릭터

## `users/{uid}/character/profile`

사용자당 하나의 현재 캐릭터 문서다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| characterVersion | Number | O | 캐릭터 데이터 버전 |
| bodyTypeBase | String | O | 최초 선택 기본 체형 |
| faceAssetId | String | O | 얼굴 파츠 ID |
| hairAssetId | String | O | 머리 파츠 ID |
| skinToneAssetId | String | O | 피부톤 ID |
| outfitAssetId | String | O | 운동복 ID |
| shoesAssetId | String/null | X | 신발 ID |
| backgroundAssetId | String/null | X | 배경 ID |
| equippedAssetIds | Array<String> | O | 현재 장착 파츠 |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

## `users/{uid}/character/bodyStatus`

실제 기록을 반영한 캐릭터 체형값이며 서버만 수정한다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| bodyFatStage | Number | O | 0~10 단계 |
| muscleStage | Number | O | 0~10 단계 |
| shoulderStage | Number | O | 0~10 |
| chestStage | Number | O | 0~10 |
| armStage | Number | O | 0~10 |
| waistStage | Number | O | 0~10 |
| legStage | Number | O | 0~10 |
| definitionStage | Number | O | 근육 선명도 0~10 |
| confidence | Number | O | 계산 신뢰도 0~1 |
| baselineInbodyId | String/null | X | 기준 인바디 ID |
| latestInbodyId | String/null | X | 최근 인바디 ID |
| algorithmVersion | String | O | 변화 공식 버전 |
| calculatedAt | Timestamp | O | 서버 계산 시각 |

## `users/{uid}/character/stats`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| strength | Number | O | STR |
| endurance | Number | O | END |
| cardio | Number | O | CARDIO |
| body | Number | O | BODY |
| consistency | Number | O | CONSISTENCY |
| chestExp | Number | O | 가슴 부위 EXP |
| backExp | Number | O | 등 EXP |
| shoulderExp | Number | O | 어깨 EXP |
| armExp | Number | O | 팔 EXP |
| legExp | Number | O | 하체 EXP |
| coreExp | Number | O | 코어 EXP |
| cardioExp | Number | O | 심폐 EXP |
| updatedAt | Timestamp | O | 갱신 시각 |

---

# 6. 운동 DB

## `exercises/{exerciseId}`

관리자가 등록하고 사용자는 읽기만 가능하다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| nameKo | String | O | 한글 운동명 |
| nameEn | String | O | 영문 운동명 |
| searchKeywords | Array<String> | O | 검색 키워드 |
| mainBodyPart | String | O | 대표 부위 |
| targetMuscles | Array<String> | O | 주요 근육 |
| secondaryMuscles | Array<String> | O | 보조 근육 |
| equipment | String | O | 기구 |
| difficulty | String | O | 난이도 |
| unilateral | Boolean | O | 단측 여부 |
| exerciseType | String | O | `strength`, `cardio`, `stretching` |
| calorieCalculationType | String | O | 계산 방식 코드 |
| metValue | Number/null | X | 유산소 MET 값 |
| imageUrl | String/null | X | 자세 이미지 |
| animationUrl | String/null | X | 애니메이션 |
| description | String | O | 운동 설명 |
| cautions | Array<String> | O | 주의 사항 |
| bodyPartExpWeights | Map<String, Number> | O | 부위별 EXP 가중치 |
| active | Boolean | O | 앱 노출 여부 |
| sortOrder | Number | O | 정렬값 |
| version | Number | O | 데이터 버전 |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

예: 벤치프레스 `bodyPartExpWeights = {chest: 0.65, arm: 0.20, shoulder: 0.15}`.

---

# 7. 운동 세션

## `users/{uid}/workoutSessions/{sessionId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| dateId | String | O | 사용자 시간대 날짜 |
| startedAt | Timestamp | O | 시작 시각 |
| completedAt | Timestamp/null | X | 완료 시각 |
| status | String | O | `draft`, `completed`, `cancelled` |
| workoutType | String | O | `strength`, `cardio`, `mixed` |
| durationSeconds | Number | O | 총 운동시간 |
| restSeconds | Number | O | 총 휴식시간 |
| totalVolumeKg | Number | O | 서버 검증 총 볼륨 |
| estimatedCaloriesKcal | Number | O | 예상 소비량 |
| calorieSource | String | O | `formula`, `manual`, `device` |
| exerciseCount | Number | O | 운동 종목 수 |
| setCount | Number | O | 완료 세트 수 |
| memo | String/null | X | 세션 메모 |
| expStatus | String | O | `pending`, `awarded`, `recalculated` |
| awardedExp | Number | O | 확정 EXP |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

## `users/{uid}/workoutSessions/{sessionId}/exercises/{sessionExerciseId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| exerciseId | String | O | 운동 DB ID |
| exerciseNameSnapshot | String | O | 기록 당시 이름 |
| exerciseType | String | O | 운동 유형 |
| orderIndex | Number | O | 세션 내 순서 |
| totalVolumeKg | Number | O | 해당 운동 볼륨 |
| durationSeconds | Number | O | 운동시간 |
| distanceKm | Number/null | X | 유산소 거리 |
| averageSpeedKph | Number/null | X | 평균속도 |
| averageHeartRate | Number/null | X | 평균심박수 |
| estimatedCaloriesKcal | Number | O | 예상 소비 |
| memo | String/null | X | 메모 |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

## `.../exercises/{sessionExerciseId}/sets/{setId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| orderIndex | Number | O | 세트 순서 |
| setType | String | O | `warmup`, `working`, `drop`, `failure` |
| weightKg | Number | O | 중량 |
| reps | Number | O | 반복 수 |
| durationSeconds | Number/null | X | 시간형 세트 |
| distanceMeters | Number/null | X | 거리형 세트 |
| restSeconds | Number/null | X | 세트 후 휴식 |
| rpe | Number/null | X | 운동자각도 1~10 |
| completed | Boolean | O | 완료 여부 |
| volumeKg | Number | O | `weightKg × reps` |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

단측 운동의 중량 계산 규칙은 운동 DB의 `unilateral`과 별도 계산 설정을 사용한다.

---

# 8. 음식 기록

## `users/{uid}/foodLogs/{foodLogId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| dateId | String | O | 사용자 시간대 날짜 |
| eatenAt | Timestamp | O | 섭취 시각 |
| mealType | String | O | `breakfast`, `lunch`, `dinner`, `snack` |
| foodId | String/null | X | 공용 음식 DB ID |
| foodNameSnapshot | String | O | 음식명 |
| amount | Number | O | 섭취량 |
| unit | String | O | `g`, `ml`, `serving`, `piece` |
| caloriesKcal | Number | O | 칼로리 |
| carbohydrateG | Number/null | X | 탄수화물 |
| proteinG | Number/null | X | 단백질 |
| fatG | Number/null | X | 지방 |
| fiberG | Number/null | X | 식이섬유 |
| source | String | O | `manual`, `database` |
| note | String/null | X | 메모 |
| createdAt | Timestamp | O | 생성 시각 |
| updatedAt | Timestamp | O | 수정 시각 |

## `foods/{foodId}`

MVP에서는 소수의 기본 음식만 제공하고 직접 입력을 우선한다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| nameKo | String | O | 음식명 |
| searchKeywords | Array<String> | O | 검색어 |
| servingAmount | Number | O | 기준량 |
| servingUnit | String | O | 기준 단위 |
| caloriesKcal | Number | O | 기준 칼로리 |
| carbohydrateG | Number/null | X | 탄수화물 |
| proteinG | Number/null | X | 단백질 |
| fatG | Number/null | X | 지방 |
| fiberG | Number/null | X | 식이섬유 |
| sourceName | String | O | 데이터 출처 |
| active | Boolean | O | 노출 여부 |
| updatedAt | Timestamp | O | 수정 시각 |

---

# 9. 날짜별 요약

## `users/{uid}/dailySummaries/{dateId}`

문서 ID는 예: `2026-09-01`. 원본 기록을 매번 모두 읽지 않도록 Cloud Functions가 집계한다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| dateId | String | O | 문서 날짜 |
| timezone | String | O | 집계 시간대 |
| basalMetabolicRateKcal | Number | O | BMR 추정 |
| dailyActivityKcal | Number | O | 일상 활동 추정 |
| workoutCaloriesKcal | Number | O | 운동 소비 |
| totalExpenditureKcal | Number | O | 총 소비 |
| intakeCaloriesKcal | Number | O | 총 섭취 |
| calorieBalanceKcal | Number | O | 섭취 - 소비 |
| carbohydrateG | Number | O | 탄수화물 합 |
| proteinG | Number | O | 단백질 합 |
| fatG | Number | O | 지방 합 |
| fiberG | Number | O | 식이섬유 합 |
| workoutCount | Number | O | 완료 운동 수 |
| workoutDurationSeconds | Number | O | 운동시간 합 |
| workoutVolumeKg | Number | O | 운동 볼륨 합 |
| steps | Number/null | X | 걸음 수 |
| waterMl | Number/null | X | 물 섭취 |
| expEarned | Number | O | 당일 확정 EXP |
| expCapReached | Boolean | O | 일일 한도 도달 |
| updatedAt | Timestamp | O | 집계 시각 |

`calorieBalanceKcal`는 음수일수록 좋은 점수로 사용하지 않는다.

---

# 10. EXP와 레벨 기록

## `users/{uid}/experienceLogs/{experienceLogId}`

EXP의 원장이다. 수정 대신 취소 보정 로그를 추가한다.

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| sourceType | String | O | `workout`, `streak`, `pr`, `inbody`, `adjustment` |
| sourceId | String | O | 원인이 된 기록 ID |
| baseExp | Number | O | 기본 EXP |
| multiplier | Number | O | 적용 배율 |
| finalExp | Number | O | 확정 EXP |
| bodyPartExp | Map<String, Number> | O | 부위별 EXP |
| dailyCapApplied | Boolean | O | 일일 제한 적용 여부 |
| fatigueFactor | Number | O | 피로도 계수 |
| algorithmVersion | String | O | EXP 공식 버전 |
| idempotencyKey | String | O | 중복 지급 방지 키 |
| reversed | Boolean | O | 취소 여부 |
| createdAt | Timestamp | O | 서버 생성 시각 |

## `users/{uid}/levelHistory/{historyId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| fromLevel | Number | O | 이전 레벨 |
| toLevel | Number | O | 새 레벨 |
| totalExp | Number | O | 당시 누적 EXP |
| titleCode | String | O | 등급 |
| triggeredByExpLogId | String | O | 원인 로그 |
| leveledUpAt | Timestamp | O | 레벨업 시각 |

## `levelDefinitions/{level}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| level | Number | O | 레벨 |
| cumulativeExpRequired | Number | O | 해당 레벨 누적 필요 EXP |
| expToNextLevel | Number | O | 다음 레벨까지 |
| titleCode | String | O | 등급 코드 |
| titleKo | String | O | 표시 명칭 |
| rewardAssetIds | Array<String> | O | 해금 파츠 |
| active | Boolean | O | 사용 여부 |

---

# 11. 퀘스트와 업적

MVP 초기 화면에는 구조만 준비하고 본격 보상은 후속 개발한다.

## `questDefinitions/{questId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| questType | String | O | `daily`, `weekly` |
| titleKo | String | O | 제목 |
| descriptionKo | String | O | 설명 |
| metric | String | O | 측정 항목 |
| targetValue | Number | O | 목표값 |
| expReward | Number | O | EXP 보상 |
| assetRewardIds | Array<String> | O | 아이템 보상 |
| active | Boolean | O | 활성 |
| version | Number | O | 버전 |

## `users/{uid}/userQuests/{userQuestId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| questId | String | O | 정의 ID |
| periodStart | Timestamp | O | 시작 |
| periodEnd | Timestamp | O | 종료 |
| currentValue | Number | O | 진행값 |
| targetValue | Number | O | 목표값 스냅샷 |
| status | String | O | `active`, `completed`, `claimed`, `expired` |
| completedAt | Timestamp/null | X | 완료 시각 |
| claimedAt | Timestamp/null | X | 수령 시각 |

## `achievementDefinitions/{achievementId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| titleKo | String | O | 업적명 |
| descriptionKo | String | O | 조건 설명 |
| metric | String | O | 누적 지표 |
| threshold | Number | O | 달성 기준 |
| expReward | Number | O | EXP |
| badgeAssetId | String | O | 배지 |
| hidden | Boolean | O | 숨김 업적 |
| active | Boolean | O | 활성 |

## `users/{uid}/userAchievements/{achievementId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| achievementId | String | O | 정의 ID |
| currentValue | Number | O | 현재 누적값 |
| unlocked | Boolean | O | 달성 여부 |
| unlockedAt | Timestamp/null | X | 달성 시각 |
| rewardClaimed | Boolean | O | 보상 수령 |
| claimedAt | Timestamp/null | X | 수령 시각 |

---

# 12. 성장 리포트

## `users/{uid}/growthReports/{reportId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| reportType | String | O | `weekly`, `monthly` |
| periodStart | Timestamp | O | 시작일 |
| periodEnd | Timestamp | O | 종료일 |
| workoutCount | Number | O | 운동 횟수 |
| workoutMinutes | Number | O | 운동시간 |
| workoutVolumeKg | Number | O | 총 볼륨 |
| workoutCaloriesKcal | Number | O | 운동 소비 |
| averageIntakeKcal | Number/null | X | 평균 섭취 |
| weightChangeKg | Number/null | X | 체중 변화 |
| muscleChangeKg | Number/null | X | 골격근 변화 |
| bodyFatPercentChange | Number/null | X | 체지방률 변화 |
| fromLevel | Number | O | 시작 레벨 |
| toLevel | Number | O | 종료 레벨 |
| earnedExp | Number | O | 기간 EXP |
| generatedAt | Timestamp | O | 생성 시각 |
| algorithmVersion | String | O | 리포트 계산 버전 |

---

# 13. 캐릭터 공용 에셋

## `characterAssets/{assetId}`

| Field | Type | 필수 | 설명 |
|---|---|---:|---|
| assetType | String | O | `face`, `hair`, `skin`, `outfit`, `shoes`, `background` |
| nameKo | String | O | 표시명 |
| imageUrl | String | O | Storage 이미지 |
| thumbnailUrl | String | O | 미리보기 |
| layerOrder | Number | O | 합성 순서 |
| compatibleBodyTypes | Array<String> | O | 호환 체형 |
| unlockType | String | O | `default`, `level`, `achievement` |
| unlockValue | String/null | X | 해금 조건 |
| active | Boolean | O | 노출 여부 |
| version | Number | O | 에셋 버전 |

---

# 14. 앱 설정

## `appConfig/gameBalance`

| Field | Type | 설명 |
|---|---|---|
| expAlgorithmVersion | String | 현재 EXP 공식 |
| characterAlgorithmVersion | String | 캐릭터 공식 |
| dailyBaseExpCap | Number | 기본 일일 EXP 한도 |
| maxLevel | Number | 최고 레벨 |
| maintenanceMode | Boolean | 점검 모드 |
| minimumAppVersion | String | 최소 지원 버전 |
| updatedAt | Timestamp | 변경 시각 |

클라이언트는 설정을 읽지만 EXP 계산에서는 Cloud Functions가 신뢰 가능한 서버 설정을 사용한다.

---

# 문서 ID 규칙

| 데이터 | 문서 ID |
|---|---|
| 사용자 | Auth UID |
| 날짜 요약 | 사용자 시간대 `yyyy-MM-dd` |
| 운동 세션 | Firestore 자동 ID |
| 운동 세션 내 운동 | 자동 ID |
| 세트 | 자동 ID |
| 인바디 | 자동 ID |
| 음식 기록 | 자동 ID |
| 운동 DB | 안정적인 영문 slug 또는 자동 ID |
| 레벨 정의 | `1`, `2`, `3` 문자열 |
| 캐릭터 단일 문서 | `profile`, `bodyStatus`, `stats` |

운동명처럼 나중에 바뀔 수 있는 표시 문구를 문서 ID로 직접 사용하지 않는다.

# 클라이언트와 서버 수정 권한

| 데이터 | 앱 직접 생성·수정 | Cloud Functions |
|---|---:|---:|
| 프로필 입력값 | O | 검증 가능 |
| 인바디 원본 | O | 변화 계산 |
| 운동 draft·세트 | O | 완료 시 집계·검증 |
| 음식 원본 | O | 일일 합계 집계 |
| 캐릭터 외형 선택 | O | 해금 여부 검증 |
| totalExp·level | X | O |
| character bodyStatus | X | O |
| dailySummaries 확정값 | X | O |
| experienceLogs | X | O |
| 공용 운동·음식 DB | X | 관리자만 |
| 퀘스트·업적 결과 | X | O |

# 보안 규칙 설계 원칙

실제 `firestore.rules` 코드는 Firebase 연결 단계에서 작성한다.

1. 로그인한 사용자는 `users/{uid}`에서 자신의 UID와 일치할 때만 접근한다.
2. `level`, `totalExp`, 서버 집계 필드는 클라이언트가 바꾸지 못한다.
3. 공용 운동·레벨·캐릭터 에셋은 로그인 사용자에게 읽기만 허용한다.
4. 관리자 쓰기는 Firebase Custom Claims의 `admin == true`로 확인한다.
5. 필드 타입과 허용 범위를 Rules에서 검사한다.
6. 운동 완료 후 EXP 지급은 Callable Function 또는 Firestore Trigger에서 처리한다.
7. 계정 삭제 시 하위 컬렉션을 서버가 재귀 삭제한다.
8. 공개 저장소에는 서비스 계정 키를 절대 저장하지 않는다.

# 주요 입력 범위 검증

정확한 의료 기준이 아니라 잘못된 입력 방지를 위한 넓은 기술 범위다.

| Field | 허용 예시 범위 |
|---|---|
| heightCm | 80~250 |
| weightKg | 20~400 |
| bodyFatPercent | 1~75 |
| skeletalMuscleMassKg | 1~150 |
| caloriesKcal 단일 음식 | 0~10,000 |
| set weightKg | 0~1,500 |
| reps | 0~1,000 |
| durationSeconds | 0~86,400 |
| heartRate | 20~250 |
| rpe | 1~10 |

범위를 벗어나면 자동으로 수정하지 않고 사용자에게 확인을 요청한다.

# 필요한 복합 색인

`firestore.indexes.json`에 다음 쿼리 기준을 준비한다.

| Collection group | 필드 |
|---|---|
| workoutSessions | `status ASC, startedAt DESC` |
| workoutSessions | `dateId ASC, startedAt DESC` |
| foodLogs | `dateId ASC, eatenAt ASC` |
| inbodyRecords | `measuredAt DESC` |
| bodyMeasurements | `measuredAt DESC` |
| exercises | `active ASC, mainBodyPart ASC, sortOrder ASC` |
| exercises | `active ASC, equipment ASC, sortOrder ASC` |
| growthReports | `reportType ASC, periodStart DESC` |
| experienceLogs | `createdAt DESC` |

# 데이터 중복과 스냅샷 원칙

- 운동 기록에는 `exerciseId`와 당시 운동명을 함께 저장한다.
- 음식 기록에는 `foodId`와 당시 음식명·영양값을 함께 저장한다.
- 공용 DB 이름이 바뀌어도 과거 기록 표시가 달라지지 않는다.
- `users.currentWeightKg`와 일일 합계는 화면 속도를 위한 캐시다.
- 캐시는 원본이 아니며 Cloud Functions로 다시 계산할 수 있어야 한다.

# 삭제와 보존

- 사용자가 일반 기록을 삭제하면 관련 일일 요약과 EXP를 재계산한다.
- 이미 지급된 EXP는 원장을 지우지 않고 반대 부호의 조정 로그로 보정한다.
- 계정 삭제는 재인증 후 서버 작업으로 모든 사용자 하위 데이터를 삭제한다.
- 분석 데이터에는 건강 수치 원문을 이벤트 파라미터로 보내지 않는다.

# STEP 3 완료 기준

- 개인 데이터와 공용 데이터 위치 확정
- 컬렉션·문서·필드와 타입 확정
- 운동 세션·종목·세트의 계층 구조 확정
- EXP·레벨·캐릭터 서버 관리 원칙 확정
- 보안 규칙과 복합 색인 방향 확정
- 삭제·재계산·중복 지급 방지 원칙 확정

다음 단계는 **STEP 4 — 운동 기록이 EXP와 능력치로 변환되는 실제 계산식 설계**다.
