import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/rooms/controllers/cubit.dart';
import 'package:formation_front/modules/rooms/repository/rooms_repository.dart';

import '../../utils/mouse_back_detector.dart';
import '../common/alert/controllers/cubit.dart';
import 'widgets/rooms_view.dart';

class RoomsPage extends StatelessWidget {
  RoomsPage({super.key});

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
          create: (context) =>
              RoomsCubit(
                roomsRepository,
                BlocProvider.of<NotificationCubit>(context),
              ),
          child: const RoomsView()),
    );
  }
}
