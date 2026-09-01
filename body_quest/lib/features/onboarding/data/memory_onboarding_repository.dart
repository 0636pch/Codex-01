import '../domain/onboarding_data.dart';
import 'onboarding_repository.dart';

class MemoryOnboardingRepository implements OnboardingRepository {
  ProfileInput? profile;
  InbodyInput? inbody;
  CharacterInput? character;

  @override
  Future<void> createAccount(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

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
