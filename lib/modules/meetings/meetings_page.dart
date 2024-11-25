import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/common/snack_bar/controllers/cubit.dart';
import 'package:formation_front/modules/meetings/controllers/cubit.dart';
import 'package:formation_front/modules/meetings/widgets/meetings_view.dart';
import 'package:formation_front/modules/rooms/repository/rooms_repository.dart';

import '../../utils/mouse_back_detector.dart';
import 'repository/meetings_repository.dart';

class MeetingsPage extends StatelessWidget {
  MeetingsPage({super.key});

  final MeetingsRepository repository = MeetingsRepository();
  final RoomsRepository roomsRepository = RoomsRepository();

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
      child: BlocProvider(
          create: (context) => MeetingsCubit(
                repository,
                BlocProvider.of<NotificationCubit>(context),
                roomsRepository,
              ),
          child: const MeetingsView()),
    );
  }
}
