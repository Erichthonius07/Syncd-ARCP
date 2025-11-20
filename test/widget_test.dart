import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_sync_d/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SyncApp());
  });
}