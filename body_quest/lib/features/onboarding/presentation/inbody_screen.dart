import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';
import '../domain/onboarding_data.dart';

class InbodyScreen extends ConsumerStatefulWidget {
  const InbodyScreen({super.key});

  @override
  ConsumerState<InbodyScreen> createState() => _InbodyScreenState();
}

class _InbodyScreenState extends ConsumerState<InbodyScreen> {
  final weight = TextEditingController();
  final muscle = TextEditingController();
  final bodyFat = TextEditingController();

  Future<void> save() async {
    final w = double.tryParse(weight.text);
    if (w == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('체중을 입력해 주세요.')),
      );
      return;
    }
    await ref.read(onboardingRepositoryProvider).saveInbody(InbodyInput(
          measuredAt: DateTime.now(),
          weightKg: w,
          skeletalMuscleMassKg: double.tryParse(muscle.text),
          bodyFatPercent: double.tryParse(bodyFat.text),
        ));
    if (mounted) context.go('/character');
  }

  Future<void> skip() async {
    await ref.read(onboardingRepositoryProvider).saveInbody(null);
    if (mounted) context.go('/character');
  }

  @override
  Widget build(BuildContext context) {
    return QuestScaffold(
      step: 'QUEST 3/4',
      title: '현재 신체 기록',
      child: Column(
        children: [
          const Text('인바디가 없다면 건너뛸 수 있어요.'),
          const SizedBox(height: 16),
          TextField(controller: weight, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '체중 kg')),
          const SizedBox(height: 12),
          TextField(controller: muscle, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '골격근량 kg (선택)')),
          const SizedBox(height: 12),
          TextField(controller: bodyFat, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '체지방률 % (선택)')),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: save, child: const Text('기록 저장')),
          TextButton(onPressed: skip, child: const Text('나중에 입력하기')),
        ],
      ),
    );
  }
}
