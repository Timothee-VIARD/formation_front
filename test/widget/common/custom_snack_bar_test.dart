import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/common/snackBar/custom_snack_bar.dart';

void main() {
  testWidgets('CustomSnackBar error displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBarPage(
                    title: 'Test',
                    level: SnackBarLevel.error,
                  ).build(context);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('Show SnackBar'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show SnackBar'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('CustomSnackBar success displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBarPage(
                    title: 'Test2',
                    level: SnackBarLevel.success,
                  ).build(context);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('Show SnackBar'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show SnackBar'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.green);
    expect(find.text('Test2'), findsOneWidget);
  });
}