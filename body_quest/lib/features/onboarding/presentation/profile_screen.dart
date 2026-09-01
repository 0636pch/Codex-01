import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';
import '../domain/onboarding_data.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final nickname = TextEditingController();
  final birth = TextEditingController(text: '1990-01-01');
  final height = TextEditingController();
  final weight = TextEditingController();
  String gender = 'male';
  String experience = 'beginner';
  int weeklyGoal = 3;
  final goals = <String>{'muscle_gain'};

  Future<void> submit() async {
    final date = DateTime.tryParse(birth.text);
    final h = double.tryParse(height.text);
    final w = double.tryParse(weight.text);
    if (nickname.text.trim().isEmpty || date == null || h == null || w == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('입력값을 확인해 주세요.')),
      );
      return;
    }
    await ref.read(onboardingRepositoryProvider).saveProfile(ProfileInput(
          nickname: nickname.text,
          gender: gender,
          birthDate: date,
          heightCm: h,
          weightKg: w,
          experience: experience,
          goals: goals.toList(),
          weeklyGoal: weeklyGoal,
        ));
    if (mounted) context.go('/inbody');
  }

  @override
  Widget build(BuildContext context) {
    return QuestScaffold(
      step: 'QUEST 2/4',
      title: '기본 능력치 설정',
      child: Column(
        children: [
          TextField(controller: nickname, decoration: const InputDecoration(labelText: '닉네임')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: gender,
            decoration: const InputDecoration(labelText: '성별'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('남성')),
              DropdownMenuItem(value: 'female', child: Text('여성')),
              DropdownMenuItem(value: 'undisclosed', child: Text('밝히지 않음')),
            ],
            onChanged: (value) => setState(() => gender = value!),
          ),
          const SizedBox(height: 12),
          TextField(controller: birth, decoration: const InputDecoration(labelText: '생년월일 (YYYY-MM-DD)')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: height, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '키 cm'))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: weight, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '체중 kg'))),
          ]),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: experience,
            decoration: const InputDecoration(labelText: '운동 경험'),
            items: const [
              DropdownMenuItem(value: 'beginner', child: Text('초보')),
              DropdownMenuItem(value: 'intermediate', child: Text('중급')),
              DropdownMenuItem(value: 'advanced', child: Text('상급')),
            ],
            onChanged: (value) => setState(() => experience = value!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: weeklyGoal,
            decoration: const InputDecoration(labelText: '주당 운동 목표'),
            items: [2, 3, 4, 5, 6].map((v) => DropdownMenuItem(value: v, child: Text('주 $v회'))).toList(),
            onChanged: (value) => setState(() => weeklyGoal = value!),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: submit, child: const Text('능력치 저장')),
        ],
      ),
    );
  }
}
