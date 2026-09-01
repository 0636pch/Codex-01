import 'package:flutter/material.dart';

class QuestScaffold extends StatelessWidget {
  const QuestScaffold({
    required this.step,
    required this.title,
    required this.child,
    super.key,
  });

  final String step;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(step),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text('현실의 나를 성장시키는 첫 번째 퀘스트'),
            const SizedBox(height: 28),
            child,
          ],
        ),
      ),
    );
  }
}
