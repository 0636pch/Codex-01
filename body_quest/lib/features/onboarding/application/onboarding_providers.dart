import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../data/firebase_onboarding_repository.dart';
import '../data/memory_onboarding_repository.dart';
import '../data/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  if (useFirebase) {
    return FirebaseOnboardingRepository(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    );
  }
  return MemoryOnboardingRepository();
});

final savingProvider = StateProvider<bool>((ref) => false);
