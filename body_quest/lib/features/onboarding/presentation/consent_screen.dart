import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';

class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool terms = false;
  bool privacy = false;
  bool health = false;
  bool marketing = false;

  bool get requiredAccepted => terms && privacy && health;

  Future<void> submit() async {
    if (!requiredAccepted) return;
    ref.read(savingProvider.notifier).state = true;
    try {
      await ref
          .read(onboardingRepositoryProvider)
          .saveConsents(marketing: marketing);
      if (mounted) context.go('/profile');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('동의 저장 실패: $error')),
        );
      }
    } finally {
      ref.read(savingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(savingProvider);
    return QuestScaffold(
      step: 'QUEST 1/5',
      title: '모험 시작 동의',
      child: Column(
        children: [
          CheckboxListTile(
            value: terms,
            onChanged: (value) => setState(() => terms = value ?? false),
            title: const Text('[필수] 서비스 이용약관'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: privacy,
            onChanged: (value) => setState(() => privacy = value ?? false),
            title: const Text('[필수] 개인정보 처리방침'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: health,
            onChanged: (value) => setState(() => health = value ?? false),
            title: const Text('[필수] 건강정보 수집 및 이용'),
            subtitle: const Text('운동, 식단 및 인바디 기록 저장에 필요합니다.'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: marketing,
            onChanged: (value) => setState(() => marketing = value ?? false),
            title: const Text('[선택] 소식 및 이벤트 알림'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: requiredAccepted && !saving ? submit : null,
            child: Text(saving ? '저장 중...' : '동의하고 계속하기'),
          ),
        ],
      ),
    );
  }
}
