import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../controllers/cubit.dart';
import '../controllers/state.dart';

class UsersTable extends StatelessWidget {
  final UsersState state;

  UsersTable({super.key, required this.state});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UsersLoading():
        return const Center(child: CircularProgressIndicator());
      case UsersLoadSuccess():
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
                          label: Text(t.users.data.id),
                        ),
                        DataColumn(
                          label: Text(t.users.data.name),
                        ),
                        DataColumn(
                          label: Text(t.users.data.email),
                        ),
                        DataColumn(
                          label: Text(t.users.data.actions),
                        ),
                      ],
                      rows: _dataRows(context, constraints),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      default:
        return Center(child: Text(t.users.reload.error));
    }
  }

  List<DataRow> _dataRows(BuildContext context, BoxConstraints constraints) {
    List<DataRow> list = (state as UsersLoadSuccess).users.map<DataRow>((user) {
      final double idColumnWidth = constraints.minWidth * 0.05;
      final double nameColumnWidth = constraints.minWidth * 0.3;
      final double emailColumnWidth = constraints.minWidth * 0.4;
      final double actionsColumnWidth = constraints.minHeight * 0.1;

      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: idColumnWidth,
            child: Text(user.id.toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: nameColumnWidth,
            child: Text(user.name),
          ),
        ),
        DataCell(
          SizedBox(
            width: emailColumnWidth,
            child: Text(user.email),
          ),
        ),
        DataCell(
          SizedBox(
            width: actionsColumnWidth,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => context.read<UsersCubit>().deleteUser(user.name),
            ),
          ),
        ),
      ]);
    }).toList();
    return list;
  }
}
