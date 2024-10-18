import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';

class Meetings extends StatelessWidget {
  const Meetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.meetings),
      ),
      body: Center(
        child: Text(t.meetings),
      ),
    );
  }
}
