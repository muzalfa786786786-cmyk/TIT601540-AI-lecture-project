import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login screen is shown.
    expect(find.text('AI Lecturer Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    
    // Verify the Login button exists.
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Verify that we have the school icon.
    expect(find.byIcon(Icons.school), findsOneWidget);
  });
}
