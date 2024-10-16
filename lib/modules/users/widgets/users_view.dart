import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/users/controllers/state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/cubit.dart';
import 'users_table.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  UsersViewState createState() => UsersViewState();
}

class UsersViewState extends State<UsersView> {
  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.users),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.users_list),
            const SizedBox(height: 20),
            BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                return UsersTable(state: state);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<UsersCubit>().getUsers(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.users_reload,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
