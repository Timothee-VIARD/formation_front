import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../controllers/cubit.dart';
import '../controllers/state.dart';
import '../model/room_model.dart';

class RoomsTable extends StatelessWidget {
  final RoomsState state;

  RoomsTable({super.key, required this.state});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RoomsLoading():
        return const Center(child: CircularProgressIndicator());
      case RoomsLoadSuccess(:final rooms):
        return LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.top,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
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
                      rows: _dataRows(context, constraints, rooms),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      default:
        return Center(
          child: Text(t.rooms.reload.error),
        );
    }
  }

  List<DataRow> _dataRows(BuildContext context, BoxConstraints constraints, List<Room> rooms) {
    List<DataRow> list = rooms.map<DataRow>((room) {
      final double idColumnWidth = constraints.minWidth * 0.05;
      final double nameColumnWidth = constraints.minWidth * 0.4;
      final double capacityColumnWidth = constraints.minWidth * 0.3;
      final double actionsColumnWidth = constraints.minHeight * 0.1;

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
            width: capacityColumnWidth,
            child: Text(room.nbMax.toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: actionsColumnWidth,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => context.read<RoomsCubit>().deleteRoom(room.id),
            ),
          ),
        ),
      ]);
    }).toList();
    return list;
  }
}
