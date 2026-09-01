import 'package:body_quest/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('시작 화면에서 회원가입과 로그인을 선택할 수 있다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BodyQuestApp()));
    await tester.pumpAndSettle();

    expect(find.text('현실의 나를\n레벨업하세요'), findsOneWidget);
    expect(find.text('새 캐릭터 만들기'), findsOneWidget);
    expect(find.text('기존 캐릭터로 로그인'), findsOneWidget);
  });
}
