import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/presentation/character_screen.dart';
import 'features/onboarding/presentation/inbody_screen.dart';
import 'features/onboarding/presentation/profile_screen.dart';
import 'features/onboarding/presentation/sign_up_screen.dart';

class BodyQuestApp extends StatelessWidget {
  const BodyQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Body Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/sign-up',
  routes: [
    GoRoute(path: '/sign-up', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/inbody', builder: (_, __) => const InbodyScreen()),
    GoRoute(path: '/character', builder: (_, __) => const CharacterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
  ],
);
