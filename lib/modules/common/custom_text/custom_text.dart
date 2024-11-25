import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final List<String> texts;

  const CustomText({super.key, required this.texts});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: texts.asMap().entries.map((entry) {
        int index = entry.key;
        String text = entry.value;
        return Text(
          text,
          style: TextStyle(
              fontWeight: index % 2 == 0 ? FontWeight.normal : FontWeight.bold),
        );
      }).toList(),
    );
  }
}
