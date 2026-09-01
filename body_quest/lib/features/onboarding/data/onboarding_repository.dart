import '../domain/onboarding_data.dart';

abstract interface class OnboardingRepository {
  Future<String> resolveStartRoute();
  Future<void> createAccount(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> saveConsents({required bool marketing});
  Future<void> signOut();
  Future<void> saveProfile(ProfileInput input);
  Future<void> saveInbody(InbodyInput? input);
  Future<void> saveCharacter(CharacterInput input);
}
