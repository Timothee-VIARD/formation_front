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
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersPage()),
                  ),
                  child: Container(
                    width: containerSize,
                    height: containerSize,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(child: Text(AppLocalizations.of(context)!.users)),
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Rooms()),
                  ),
                  child: Container(
                    width: containerSize,
                    height: containerSize,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(child: Text(AppLocalizations.of(context)!.rooms)),
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Meetings()),
                  ),
                  child: Container(
                    width: containerSize,
                    height: containerSize,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(child: Text(AppLocalizations.of(context)!.meetings)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
