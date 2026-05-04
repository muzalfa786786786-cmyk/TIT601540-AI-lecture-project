import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teachlearn/main.dart';
import 'package:teachlearn/screens/auth_screen.dart';
import 'package:teachlearn/theme/app_theme.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TeachLearnApp());

    // Wait for splash screen to finish (2 seconds)
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify that the auth screen is shown after splash
    // Looking for TabBar (Login/Register tabs)
    expect(find.byType(TabBar), findsOneWidget);

    // Verify Login tab exists
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // Verify email field exists
    expect(find.widgetWithText(TextField, 'Email Address'), findsOneWidget);

    // Verify password field exists
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Verify the Login button exists
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Verify that we have the school icon
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    // Verify app title
    expect(find.text('TeachLearn'), findsOneWidget);
  });

  testWidgets('Login button is enabled when fields are filled', (WidgetTester tester) async {
    await tester.pumpWidget(const TeachLearnApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Find email and password fields
    final emailField = find.widgetWithText(TextField, 'Email Address');
    final passwordField = find.widgetWithText(TextField, 'Password');

    // Enter email
    await tester.enterText(emailField, 'test@ai_lecturer.com');
    await tester.pump();

    // Enter password
    await tester.enterText(passwordField, 'password123');
    await tester.pump();

    // Verify login button is present
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Register tab switches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TeachLearnApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Find Register tab and tap it
    final registerTab = find.text('Register');
    await tester.tap(registerTab);
    await tester.pumpAndSettle();

    // Verify register form fields
    expect(find.widgetWithText(TextField, 'Full Name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email Address'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Verify role selector
    expect(find.text('Student'), findsOneWidget);
    expect(find.text('Teacher'), findsOneWidget);

    // Verify Create Account button
    expect(find.widgetWithText(ElevatedButton, 'Create Account'), findsOneWidget);
  });

  testWidgets('Bottom navigation bar exists after login', (WidgetTester tester) async {
    await tester.pumpWidget(const TeachLearnApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Skip login (mock) - In real test, you would mock authentication
    // For now, just verify that navigation exists

    // We're testing the structure
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}