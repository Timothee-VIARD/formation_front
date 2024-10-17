import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/cubit.dart';
import '../controllers/state.dart';

class UsersTable extends StatelessWidget {
  final UsersState state;

  const UsersTable({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is UsersInitial) {
      return Text(AppLocalizations.of(context)!.users_reload_alert);
    } else if (state is UsersLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is UsersLoadSuccess) {
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
                      label: Text(AppLocalizations.of(context)!.users_data_id)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.users_data_name)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.users_data_email)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.users_data_actions)),
                ],
                rows: (state as UsersLoadSuccess).users.map<DataRow>((user) {
                  return DataRow(cells: [
                    DataCell(SizedBox(width: idColumnWidth, child: Text(user.id.toString()))),
                    DataCell(SizedBox(width: nameColumnWidth, child: Text(user.name))),
                    DataCell(SizedBox(width: emailColumnWidth, child: Text(user.email))),
                    DataCell(SizedBox(
                        width: actionsColumnWidth,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              context.read<UsersCubit>().deleteUser(user.id),
                        ))),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      );
    } else if (state is UsersLoadError) {
      return Center(
          child: Text(AppLocalizations.of(context)!.users_reload_error));
    }
    return const Text('Error');
  }
}