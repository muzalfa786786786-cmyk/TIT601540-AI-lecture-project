import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/main.dart';

void main() {
  testWidgets('Message change smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our message starts as "Hello, World!".
    expect(find.text('Hello, World!'), findsOneWidget);
    expect(find.text('Hello Flutter!'), findsNothing);

    // Tap the refresh icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Verify that our message has changed.
    expect(find.text('Hello, World!'), findsNothing);
    expect(find.text('Hello Flutter!'), findsOneWidget);
  });
}
