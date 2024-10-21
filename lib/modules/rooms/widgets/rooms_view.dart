import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/rooms/controllers/cubit.dart';
import 'package:formation_front/modules/rooms/controllers/state.dart';
import 'package:formation_front/modules/rooms/widgets/create_room_dialog.dart';
import 'package:formation_front/modules/rooms/widgets/rooms_table.dart';

import '../../../i18n/strings.g.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({super.key});

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  @override
  void initState() {
    super.initState();
    context.read<RoomsCubit>().getRooms();
  }

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<RoomsCubit>(context),
          child: const CreateRoomDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.rooms.title),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: Container(
          width: 1200,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: BlocBuilder<RoomsCubit, RoomsState>(builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        t.rooms.list,
                        style: const TextStyle(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Center(
                      child: IconButton(
                        onPressed: () => context.read<RoomsCubit>().getRooms(),
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: RoomsTable(state: state),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showCreateRoomDialog(context),
                  child: Text(
                    t.rooms.room.title,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
