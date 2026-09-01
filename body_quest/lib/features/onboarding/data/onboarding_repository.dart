import '../domain/onboarding_data.dart';

abstract interface class OnboardingRepository {
  Future<void> createAccount(String email, String password);
  Future<void> saveProfile(ProfileInput input);
  Future<void> saveInbody(InbodyInput? input);
  Future<void> saveCharacter(CharacterInput input);
}
