import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool sent = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    ref.read(savingProvider.notifier).state = true;
    try {
      await ref
          .read(onboardingRepositoryProvider)
          .sendPasswordReset(email.text);
      if (mounted) setState(() => sent = true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메일 전송 실패: $error')),
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
      step: 'ACCOUNT RECOVERY',
      title: '비밀번호 재설정',
      child: sent
          ? const Text('재설정 메일을 보냈습니다. 이메일 받은편지함을 확인해 주세요.')
          : Form(
              key: formKey,
              child: Column(
                children: [
                  const Text('가입한 이메일로 비밀번호 재설정 링크를 보내드립니다.'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: '이메일'),
                    validator: (value) => value != null && value.contains('@')
                        ? null
                        : '이메일을 확인해 주세요.',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: saving ? null : submit,
                    child: Text(saving ? '전송 중...' : '재설정 메일 보내기'),
                  ),
                ],
              ),
            ),
    );
  }
}
