import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_omr/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
  });
}