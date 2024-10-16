import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      return SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                  label: Text(AppLocalizations.of(context)!.users_data_id)),
              DataColumn(
                  label: Text(AppLocalizations.of(context)!.users_data_name)),
              DataColumn(
                  label: Text(AppLocalizations.of(context)!.users_data_email)),
            ],
            rows: (state as UsersLoadSuccess).users.map<DataRow>((user) {
              return DataRow(cells: [
                DataCell(Text(user.id.toString())),
                DataCell(Text(user.name)),
                DataCell(Text(user.email)),
              ]);
            }).toList(),
          ),
        ),
      );
    } else if (state is UsersLoadError) {
      return Center(
          child: Text(AppLocalizations.of(context)!.users_reload_error));
    }
    return const Text('Error');
  }
}
