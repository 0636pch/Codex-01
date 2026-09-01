import 'package:body_quest/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('회원가입 첫 화면이 표시된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BodyQuestApp()));
    expect(find.text('모험가 등록'), findsOneWidget);
    expect(find.text('다음 퀘스트'), findsOneWidget);
  });
}
