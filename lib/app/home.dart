import 'package:flutter/material.dart';
import 'package:formation_front/modules/meetings/meetings.dart';
import 'package:formation_front/modules/rooms/rooms.dart';
import 'package:formation_front/modules/users/users_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double containerSize = constraints.maxWidth * 0.2;

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(containerSize, containerSize)),
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UsersPage()),
                        ),
                    child: Text(AppLocalizations.of(context)!.users)),
                const SizedBox(width: 40),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(containerSize, containerSize)),
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Rooms()),
                        ),
                    child: Text(AppLocalizations.of(context)!.rooms)),
                const SizedBox(width: 40),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(containerSize, containerSize)),
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Meetings()),
                        ),
                    child: Text(AppLocalizations.of(context)!.meetings)),
              ],
            ),
          );
        },
      ),
    );
  }
}
