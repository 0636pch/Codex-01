import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/presentation/character_screen.dart';
import 'features/onboarding/presentation/consent_screen.dart';
import 'features/onboarding/presentation/inbody_screen.dart';
import 'features/onboarding/presentation/profile_screen.dart';
import 'features/onboarding/presentation/reset_password_screen.dart';
import 'features/onboarding/presentation/sign_in_screen.dart';
import 'features/onboarding/presentation/sign_up_screen.dart';
import 'features/onboarding/presentation/splash_screen.dart';
import 'features/onboarding/presentation/welcome_screen.dart';

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
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/sign-up', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/sign-in', builder: (_, __) => const SignInScreen()),
    GoRoute(
      path: '/reset-password',
      builder: (_, __) => const ResetPasswordScreen(),
    ),
    GoRoute(path: '/consent', builder: (_, __) => const ConsentScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/inbody', builder: (_, __) => const InbodyScreen()),
    GoRoute(path: '/character', builder: (_, __) => const CharacterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
  ],
);
