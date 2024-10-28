import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/meetings/controllers/cubit.dart';
import 'package:formation_front/modules/meetings/controllers/state.dart';
import 'package:formation_front/modules/meetings/widgets/create_meeting_dialog.dart';
import 'package:formation_front/modules/meetings/widgets/meetings_list.dart';

import '../../../i18n/strings.g.dart';
import '../../../utils/api/api_service.dart';
import '../../rooms/model/room_model.dart';

class MeetingsView extends StatefulWidget {
  const MeetingsView({super.key});

  @override
  State<MeetingsView> createState() => _MeetingsViewState();
}

class _MeetingsViewState extends State<MeetingsView> {
  bool showPastMeetings = false;
  final ApiService apiService = ApiService();
  late Future<List<Room>> rooms;

  @override
  void initState() {
    super.initState();
    context.read<MeetingsCubit>().getMeetings();
    rooms = _getRooms();
  }

  Future<List<Room>> _getRooms() {
    Future<List<Room>> data = apiService.get('/salles').then(
      (response) {
        return response.map<Room>((room) {
          return Room.fromJson(room);
        }).toList();
      },
    );
    return data;
  }

  void _showCreateMeetingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<MeetingsCubit>(context),
          child: CreateMeetingDialog(rooms: rooms),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.meetings.title),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: Container(
          width: 1200,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: BlocBuilder<MeetingsCubit, MeetingsState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _topBar(context),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: MeetingsList(
                        state: state,
                        showPastMeetings: showPastMeetings,
                        rooms: rooms,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _addMeetingButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  SizedBox _topBar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWrapped = (450) > constraints.maxWidth;

          return Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      t.meetings.list,
                      style: const TextStyle(fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () =>
                        context.read<MeetingsCubit>().getMeetings(),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              _historySwitch(isWrapped),
            ],
          );
        },
      ),
    );
  }

  Theme _historySwitch(bool isWrapped) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Row(
        mainAxisSize: isWrapped ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(showPastMeetings
              ? t.meetings.hideHistory
              : t.meetings.showHistory),
          Switch(
            value: showPastMeetings,
            onChanged: (value) {
              setState(() {
                showPastMeetings = value;
              });
            },
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }

  ElevatedButton _addMeetingButton() {
    return ElevatedButton(
      onPressed: () => _showCreateMeetingDialog(context),
      child: Text(
        t.meetings.meeting.title,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
