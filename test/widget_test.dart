import 'package:baby_f_words/widgets/sparkle_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SparkleOverlay renders child and responds to tap gestures', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SparkleOverlay(
          child: Scaffold(
            body: Center(
              child: Text('Test Child'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Child'), findsOneWidget);

    // Perform tap to trigger sparkles
    await tester.tap(find.text('Test Child'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Test Child'), findsOneWidget);
  });
}
