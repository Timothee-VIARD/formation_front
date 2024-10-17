import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const int kBackMouseButton = 0x00000008;

class MouseBackRecognizer extends BaseTapGestureRecognizer {
  GestureTapUpCallback? onTapUp;

  MouseBackRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  @override
  void handleTapCancel({
    required PointerDownEvent down,
    PointerCancelEvent? cancel,
    required String reason,
  }) {}

  @override
  void handleTapDown({required PointerDownEvent down}) {}

  @override
  void handleTapUp({
    required PointerDownEvent down,
    required PointerUpEvent up,
  }) {
    final TapUpDetails details = TapUpDetails(
      globalPosition: up.position,
      localPosition: up.localPosition,
      kind: getKindForPointer(up.pointer),
    );

    if (down.buttons == kBackMouseButton && onTapUp != null) {
      invokeCallback<void>('onTapUp', () => onTapUp!(details));
    }
  }
}

void handleMouseBackButton(BuildContext context) {
  Navigator.of(context).pop();
}