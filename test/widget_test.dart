import 'package:flutter_test/flutter_test.dart';
import 'package:poliwangi_academic_dashboard/modul_03/modul_03_app.dart';

void main() {
  testWidgets('Modul 03 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Modul03App());
  });
}