import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/meetings/model/meeting_model.dart';
import 'package:formation_front/utils/dateTime/date_time.dart';
import 'package:intl/intl.dart';

import '../../../app/controllers/login_cubit.dart';
import '../../../app/controllers/login_state.dart';
import '../../../i18n/strings.g.dart';
import '../controllers/cubit.dart';

class CreateMeetingDialog extends StatefulWidget {
  const CreateMeetingDialog({super.key});

  @override
  CreateMeetingDialogState createState() => CreateMeetingDialogState();
}

class CreateMeetingDialogState extends State<CreateMeetingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _durationController = TextEditingController();
  final _peopleNbController = TextEditingController();
  final _roomIdController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _peopleNbController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  void _createMeeting() {
    if (_formKey.currentState!.validate()) {
      final Meeting meeting = Meeting(
        date: DateTimeUtils.mergeDateAndTimeString(
            _dateController.text, _timeController.text),
        duration: int.parse(_durationController.text),
        peopleNb: int.parse(_peopleNbController.text),
        roomId: _roomIdController.text,
      );
      String token =
          (context.read<LoginCubit>().state as LoginSuccess).token.accessToken;
      context.read<MeetingsCubit>().createMeeting(meeting, token);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(40.0),
            width: 420,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogTitle,
                const SizedBox(height: 16),
                _dialogForm,
                const SizedBox(height: 16),
                _dialogConfirm,
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  final Center _dialogTitle = Center(
    child: Text(
      t.meetings.meeting.title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  late final Form _dialogForm = Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _dateController,
          onTap: () => _selectDate(context),
          readOnly: true,
          decoration: InputDecoration(
            labelText: t.meetings.meeting.date,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.meetings.meeting.date_hint;
            }
            return null;
          },
        ),
        TextFormField(
          controller: _timeController,
          onTap: () => _selectTime(context),
          readOnly: true,
          decoration: InputDecoration(
            labelText: t.meetings.meeting.time,
            suffixIcon: const Icon(Icons.more_time),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.meetings.meeting.time_hint;
            }
            return null;
          },
        ),
        TextFormField(
          controller: _durationController,
          decoration: InputDecoration(
            labelText: t.meetings.meeting.duration,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.meetings.meeting.duration_hint;
            }
            return null;
          },
        ),
        TextFormField(
          controller: _peopleNbController,
          decoration: InputDecoration(
            labelText: t.meetings.meeting.nbUsers,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.meetings.meeting.nbUsers_hint;
            }
            return null;
          },
        ),
        TextFormField(
          controller: _roomIdController,
          decoration: InputDecoration(
            labelText: t.meetings.meeting.room,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.meetings.meeting.room_hint;
            }
            return null;
          },
        ),
      ],
    ),
  );

  late final ElevatedButton _dialogConfirm = ElevatedButton(
    onPressed: _createMeeting,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        t.rooms.room.confirm,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
