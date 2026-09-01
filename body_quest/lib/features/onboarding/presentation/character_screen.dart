import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';
import '../domain/onboarding_data.dart';

class CharacterScreen extends ConsumerStatefulWidget {
  const CharacterScreen({super.key});

  @override
  ConsumerState<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends ConsumerState<CharacterScreen> {
  String face = 'face_01';
  String hair = 'hair_01';
  String skin = 'skin_02';
  String outfit = 'outfit_01';

  Widget choice(String title, String value, List<String> values, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: title),
      items: values.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) => onChanged(v!),
    );
  }

  Future<void> submit() async {
    await ref.read(onboardingRepositoryProvider).saveCharacter(CharacterInput(
          face: face,
          hair: hair,
          skinTone: skin,
          outfit: outfit,
        ));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return QuestScaffold(
      step: 'QUEST 4/4',
      title: '나만의 캐릭터 생성',
      child: Column(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(colors: [Color(0xFF263354), Color(0xFF111728)]),
            ),
            child: const Center(child: Icon(Icons.accessibility_new_rounded, size: 150, color: Color(0xFFF3C969))),
          ),
          const SizedBox(height: 18),
          choice('얼굴', face, ['face_01', 'face_02', 'face_03'], (v) => setState(() => face = v)),
          const SizedBox(height: 10),
          choice('헤어', hair, ['hair_01', 'hair_02', 'hair_03'], (v) => setState(() => hair = v)),
          const SizedBox(height: 10),
          choice('피부톤', skin, ['skin_01', 'skin_02', 'skin_03'], (v) => setState(() => skin = v)),
          const SizedBox(height: 10),
          choice('운동복', outfit, ['outfit_01', 'outfit_02'], (v) => setState(() => outfit = v)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: submit, child: const Text('캐릭터 생성 완료')),
        ],
      ),
    );
  }
}
