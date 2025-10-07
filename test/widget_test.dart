import 'package:flutter_test/flutter_test.dart';

import 'package:catbreedsflutter/main.dart';

void main() {
  testWidgets('Catbreeds app ', (WidgetTester tester) async {
    await tester.pumpWidget(const CatBreedsApp());
    expect(find.text('Catbreeds'), findsOneWidget);
  });
}
