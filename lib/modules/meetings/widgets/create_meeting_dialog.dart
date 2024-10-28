import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/common/customDatePicker/custom_date_picker.dart';
import 'package:formation_front/modules/meetings/model/meeting_model.dart';
import 'package:formation_front/utils/dateTime/date_time.dart';
import 'package:intl/intl.dart';

import '../../../app/controllers/login_cubit.dart';
import '../../../app/controllers/login_state.dart';
import '../../../i18n/strings.g.dart';
import '../../common/timeInputField/time_input_field.dart';
import '../controllers/cubit.dart';
import 'dropdown_widget.dart';

class CreateMeetingDialog extends StatefulWidget {
  const CreateMeetingDialog({super.key});

  @override
  CreateMeetingDialogState createState() => CreateMeetingDialogState();
}

class CreateMeetingDialogState extends State<CreateMeetingDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _durationController;
  late TextEditingController _peopleNbController;
  late TextEditingController _roomIdController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _durationController = TextEditingController();
    _peopleNbController = TextEditingController();
    _roomIdController = TextEditingController();
  }

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
      locale: const Locale('fr', 'FR'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Set the border radius here
              ),
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF494949),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
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
                const SizedBox(height: 24),
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

  bool _isOnMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
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
        _isOnMobile(context)
            ? TextFormField(
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
              )
            : CustomCalendarDatePicker(
                controller: _dateController,
              ),
        TimeInputField(controller: _timeController),
        TextFormField(
          controller: _durationController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
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
        DropdownWidget(controller: _roomIdController),
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
