import '../domain/onboarding_data.dart';
import 'onboarding_repository.dart';

class MemoryOnboardingRepository implements OnboardingRepository {
  ProfileInput? profile;
  InbodyInput? inbody;
  CharacterInput? character;

  @override
  Future<String> resolveStartRoute() async => '/welcome';

  @override
  Future<void> createAccount(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> saveConsents({required bool marketing}) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> saveProfile(ProfileInput input) async {
    profile = input;
  }

  @override
  Future<void> saveInbody(InbodyInput? input) async {
    inbody = input;
  }

  @override
  Future<void> saveCharacter(CharacterInput input) async {
    character = input;
  }
}
