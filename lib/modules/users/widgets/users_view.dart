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
        child: FractionallySizedBox(
          widthFactor: 2 / 3,
          heightFactor: 5 / 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.users_list,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 5),
                  Center(child: IconButton(onPressed: () => context.read<UsersCubit>().getUsers(), icon: const Icon(Icons.refresh))),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: UsersTable(state: state),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.read<UsersCubit>().getUsers(),
                child: Text(
                  AppLocalizations.of(context)!.users_reload,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
