class ProfileInput {
  const ProfileInput({
    required this.nickname,
    required this.gender,
    required this.birthDate,
    required this.heightCm,
    required this.weightKg,
    required this.experience,
    required this.goals,
    required this.weeklyGoal,
  });

  final String nickname;
  final String gender;
  final DateTime birthDate;
  final double heightCm;
  final double weightKg;
  final String experience;
  final List<String> goals;
  final int weeklyGoal;
}

class InbodyInput {
  const InbodyInput({
    required this.measuredAt,
    required this.weightKg,
    this.skeletalMuscleMassKg,
    this.bodyFatPercent,
  });

  final DateTime measuredAt;
  final double weightKg;
  final double? skeletalMuscleMassKg;
  final double? bodyFatPercent;
}

class CharacterInput {
  const CharacterInput({
    required this.face,
    required this.hair,
    required this.skinTone,
    required this.outfit,
  });

  final String face;
  final String hair;
  final String skinTone;
  final String outfit;
}
