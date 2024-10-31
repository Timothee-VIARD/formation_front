import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/common/tag/model/tag_model.dart';
import 'package:formation_front/modules/common/tag/tags.dart';

void main() {
  testWidgets("Tag displays correctly", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Tag(
            tag: TagModel(
              message: 'Test',
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Tag), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container));
    expect(
        container.decoration,
        BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue,
        ));
    final text = tester.widget<Text>(find.text('Test'));
    expect(text.overflow, TextOverflow.ellipsis);
  });
}
