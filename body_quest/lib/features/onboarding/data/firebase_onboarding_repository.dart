import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/onboarding_data.dart';
import 'onboarding_repository.dart';

class FirebaseOnboardingRepository implements OnboardingRepository {
  FirebaseOnboardingRepository(this.auth, this.firestore);

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  String get uid => auth.currentUser!.uid;

  @override
  Future<void> createAccount(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email.trim(),
      'onboardingStep': 'profile',
      'onboardingCompleted': false,
      'level': 1,
      'totalExp': 0,
      'currentLevelExp': 0,
      'nextLevelExp': 100,
      'titleCode': 'STARTER',
      'streakDays': 0,
      'timezone': 'Asia/Seoul',
      'unitSystem': 'metric',
      'role': 'user',
      'profileVersion': 1,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> saveProfile(ProfileInput input) async {
    await firestore.collection('users').doc(uid).set({
      'nickname': input.nickname.trim(),
      'gender': input.gender,
      'birthDate': Timestamp.fromDate(input.birthDate),
      'heightCm': input.heightCm,
      'currentWeightKg': input.weightKg,
      'exerciseExperience': input.experience,
      'exerciseGoals': input.goals,
      'weeklyWorkoutGoal': input.weeklyGoal,
      'activityLevel': 'moderate',
      'onboardingStep': 'inbody',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> saveInbody(InbodyInput? input) async {
    if (input != null) {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('inbodyRecords')
          .add({
        'measuredAt': Timestamp.fromDate(input.measuredAt),
        'dateId': input.measuredAt.toIso8601String().substring(0, 10),
        'weightKg': input.weightKg,
        'skeletalMuscleMassKg': input.skeletalMuscleMassKg,
        'bodyFatPercent': input.bodyFatPercent,
        'source': 'manual',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await firestore.collection('users').doc(uid).update({
      'onboardingStep': 'character',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> saveCharacter(CharacterInput input) async {
    final user = firestore.collection('users').doc(uid);
    final batch = firestore.batch();
    batch.set(user.collection('character').doc('profile'), {
      'characterVersion': 1,
      'bodyTypeBase': 'balanced',
      'faceAssetId': input.face,
      'hairAssetId': input.hair,
      'skinToneAssetId': input.skinTone,
      'outfitAssetId': input.outfit,
      'equippedAssetIds': [input.face, input.hair, input.skinTone, input.outfit],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    batch.set(user.collection('character').doc('stats'), {
      'strength': 10,
      'endurance': 10,
      'cardio': 10,
      'body': 10,
      'consistency': 10,
      'chestExp': 0,
      'backExp': 0,
      'shoulderExp': 0,
      'armExp': 0,
      'legExp': 0,
      'coreExp': 0,
      'cardioExp': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    batch.update(user, {
      'onboardingStep': 'completed',
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }
}
