import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/app/controllers/login_state.dart';

import '../../../i18n/strings.g.dart';
import '../../../modules/meetings/meetings_page.dart';
import '../../../modules/rooms/rooms_page.dart';
import '../../../modules/users/users_page.dart';
import '../controllers/login_cubit.dart';

class NavigationHome extends StatelessWidget {
  const NavigationHome({super.key});

  @override
  Widget build(BuildContext context) {
    LoginSuccess loginSuccess =
        context.read<LoginCubit>().state as LoginSuccess;

    return Scaffold(
      appBar: AppBar(
        title: Text("${t.app_title} - ${loginSuccess.username}"),
        forceMaterialTransparency: true,
        actions: [
          //logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<LoginCubit>().logout();
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double containerSize = 200;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 80,
                  runSpacing: 40,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(containerSize, containerSize),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsersPage(),
                        ),
                      ),
                      child: Text(t.users.title),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(containerSize, containerSize)),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomsPage(),
                        ),
                      ),
                      child: Text(t.rooms.title),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(containerSize, containerSize),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetingsPage(),
                        ),
                      ),
                      child: Text(t.meetings.title),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
