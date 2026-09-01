import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('LV. 1  STARTER', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
                  Text('나의 첫 성장', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
                CircleAvatar(child: Icon(Icons.person)),
              ],
            ),
            const SizedBox(height: 14),
            const LinearProgressIndicator(value: 0, minHeight: 10),
            const SizedBox(height: 4),
            const Text('EXP 0 / 100', textAlign: TextAlign.right),
            const SizedBox(height: 24),
            Container(
              height: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const RadialGradient(colors: [Color(0xFF31456F), Color(0xFF101625)]),
              ),
              child: const Center(child: Icon(Icons.accessibility_new_rounded, size: 230, color: AppTheme.gold)),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat('STR', 10),
                _Stat('END', 10),
                _Stat('CARDIO', 10),
                _Stat('BODY', 10),
              ],
            ),
            const SizedBox(height: 18),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('TODAY QUEST', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('□ 오늘 운동 기록하기'),
                  Text('□ 음식 기록하기'),
                  Text('□ 캐릭터에게 첫 EXP 주기'),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'HOME'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'WORKOUT'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'FOOD'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'GROWTH'),
          NavigationDestination(icon: Icon(Icons.person), label: 'MY'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: const TextStyle(color: AppTheme.cyan, fontSize: 11)),
      Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ]);
  }
}
