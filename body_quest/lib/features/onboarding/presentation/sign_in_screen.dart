import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/quest_scaffold.dart';
import '../application/onboarding_providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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
      final repository = ref.read(onboardingRepositoryProvider);
      await repository.signIn(email.text, password.text);
      final route = await repository.resolveStartRoute();
      if (mounted) context.go(route);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $error')),
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
      step: 'RETURNING HERO',
      title: '캐릭터 불러오기',
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
              child: Text(saving ? '불러오는 중...' : '로그인'),
            ),
            TextButton(
              onPressed: () => context.push('/reset-password'),
              child: const Text('비밀번호를 잊으셨나요?'),
            ),
            TextButton(
              onPressed: () => context.go('/sign-up'),
              child: const Text('처음이신가요? 새 캐릭터 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
