import 'package:flutter/material.dart';

import 'model/tag_model.dart';

class Tag extends StatelessWidget {
  final TagModel tag;

  const Tag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: tag.color,
      ),
      child: Text(
        tag.message,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
