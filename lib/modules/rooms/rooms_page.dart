import 'package:flutter/material.dart';

import '../../utils/mouse_back_detector.dart';
import 'widgets/rooms.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        MouseBackRecognizer:
            GestureRecognizerFactoryWithHandlers<MouseBackRecognizer>(
          () => MouseBackRecognizer(),
          (instance) =>
              instance.onTapUp = (details) => handleMouseBackButton(context),
        ),
      },
      child: const Rooms(),
    );
  }
}
