import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/common/customText/custom_text.dart';

void main() {
  testWidgets('CustomText', (WidgetTester tester) async {
    final List<String> texts = ['Hello', 'World'];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomText(
            texts: texts,
          ),
        ),
      ),
    );

    expect(find.byType(CustomText), findsOneWidget);

    final textWidgets = tester.widget<Text>(find.text(texts[0]));
    expect(textWidgets.style!.fontWeight, FontWeight.normal);

    final textWidget = tester.widget<Text>(find.text(texts[1]));
    expect(textWidget.style!.fontWeight, FontWeight.bold);
  });
}
