import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    ref.read(savingProvider.notifier).state = true;
    try {
      await ref.read(onboardingRepositoryProvider).createAccount(
            email.text,
            password.text,
          );
      if (mounted) context.go('/consent');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $error')),
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
      step: 'CREATE HERO',
      title: '모험가 등록',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: '이메일'),
              validator: (value) =>
                  value != null && value.contains('@') ? null : '이메일을 확인해 주세요.',
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
              validator: (value) =>
                  (value?.length ?? 0) >= 8 ? null : '8자 이상 입력해 주세요.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saving ? null : submit,
              child: Text(saving ? '등록 중...' : '다음 퀘스트'),
            ),
            TextButton(
              onPressed: () => context.go('/sign-in'),
              child: const Text('이미 캐릭터가 있나요? 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
