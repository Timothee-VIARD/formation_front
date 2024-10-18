import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/cubit.dart';
import '../controllers/state.dart';

class RoomsTable extends StatelessWidget {
  final RoomsState state;

  const RoomsTable({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is RoomsInitial) {
      return Text(AppLocalizations.of(context)!.rooms_reload_alert);
    } else if (state is RoomsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is RoomsLoadSuccess) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double idColumnWidth = constraints.minWidth * 0.05;
          final double nameColumnWidth = constraints.minWidth * 0.3;
          final double emailColumnWidth = constraints.minWidth * 0.4;
          final double actionsColumnWidth = constraints.minHeight * 0.1;

          return SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 10,
                columns: [
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.rooms_data_id),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.rooms_data_name),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.rooms_data_capacity),
                  ),
                  DataColumn(
                    label:
                    Text(AppLocalizations.of(context)!.rooms_data_actions),
                  ),
                ],
                rows: (state as RoomsLoadSuccess).rooms.map<DataRow>((room) {
                  return DataRow(cells: [
                    DataCell(
                      SizedBox(
                        width: idColumnWidth,
                        child: Text(room.id.toString()),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: nameColumnWidth,
                        child: Text(room.name),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: emailColumnWidth,
                        child: Text(room.nbMax.toString()),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: actionsColumnWidth,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              context.read<RoomsCubit>().deleteRoom(room.id),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      );
    } else if (state is RoomsLoadError) {
      return Center(
          child: Text(AppLocalizations.of(context)!.rooms_reload_error));
    }
    return const Text('Error');
  }
}
