// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guide_go/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(initialRoute: '/splash',));

    // Add specific tests for MyApp here. The following is an example of what you might do if MyApp has a counter.
    // Verify that the initial state is as expected. Adjust the widget finding logic to match your app.
    
    // Example of finding a widget with initial text '0'
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Example of finding a button with '+' icon and tapping it.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the state has changed after the tap.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // Add more tests to cover other parts of your app as necessary.
  });
}
