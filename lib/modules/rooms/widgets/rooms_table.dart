import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../controllers/cubit.dart';
import '../controllers/state.dart';

class RoomsTable extends StatelessWidget {
  final RoomsState state;

  const RoomsTable({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RoomsInitial():
        return Text(t.rooms.reload.alert);
      case RoomsLoading():
        return const Center(child: CircularProgressIndicator());
      case RoomsLoadSuccess():
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
                      label: Text(t.rooms.data.id),
                    ),
                    DataColumn(
                      label: Text(t.rooms.data.name),
                    ),
                    DataColumn(
                      label: Text(t.rooms.data.capacity),
                    ),
                    DataColumn(
                      label: Text(t.rooms.data.actions),
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
      case RoomsLoadError():
        return Center(
          child: Text(t.rooms.reload.error),
        );
    }
  }
}
