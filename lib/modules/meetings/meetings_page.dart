import 'package:flutter/material.dart';
import 'package:formation_front/modules/meetings/widgets/meetings.dart';

import '../../utils/mouse_back_detector.dart';

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        MouseBackRecognizer: GestureRecognizerFactoryWithHandlers<MouseBackRecognizer>(
              () => MouseBackRecognizer(),
              (instance) => instance.onTapUp = (details) => handleMouseBackButton(context),
        ),
      },
      child: const Meetings(),
    );
  }
}