import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.local_fire_department, size: 88),
              const SizedBox(height: 24),
              Text(
                '현실의 나를\n레벨업하세요',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '운동과 신체 변화가 경험치가 되고\n당신의 캐릭터가 함께 성장합니다.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/sign-up'),
                child: const Text('새 캐릭터 만들기'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/sign-in'),
                child: const Text('기존 캐릭터로 로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
