import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formation_front/modules/rooms/controllers/cubit.dart';
import 'package:formation_front/modules/rooms/controllers/state.dart';
import 'package:formation_front/modules/rooms/widgets/create_room_dialog.dart';
import 'package:formation_front/modules/rooms/widgets/rooms_table.dart';

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
        title: Text(AppLocalizations.of(context)!.rooms),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 2 / 3,
          heightFactor: 5 / 6,
          child: BlocBuilder<RoomsCubit, RoomsState>(builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.rooms_list,
                      style: const TextStyle(fontSize: 24),
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
                    AppLocalizations.of(context)!.room_create,
                    style: const TextStyle(fontSize: 16),
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