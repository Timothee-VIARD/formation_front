import 'dart:ui';

import '../../i18n/strings.g.dart';

enum DateState {
  late,
  now,
  soon;

  String get message => switch (this) {
        DateState.now => t.global.dateState.now,
        DateState.soon => t.global.dateState.soon,
        DateState.late => t.global.dateState.late,
      };

  Color get color => switch (this) {
        DateState.now => const Color(0xA1ff9800),
        DateState.soon => const Color(0xA14caf50),
        DateState.late => const Color(0xB6FA6565),
      };
}
