import 'package:flutter/material.dart';
import 'package:formation_front/utils/api/api_service.dart';

import '../../../i18n/strings.g.dart';
import '../../rooms/model/room_model.dart';

class DropdownWidget extends StatefulWidget {
  final TextEditingController controller;

  const DropdownWidget({super.key, required this.controller});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  final ApiService apiService = ApiService();
  Room? dropdownValue;
  Future<List<DropdownMenuItem<Room>>>? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _data = apiService.get('/salles').then(
      (response) {
        return response.map<DropdownMenuItem<Room>>((room) {
          final roomObj = Room.fromJson(room);
          return DropdownMenuItem<Room>(
            value: roomObj,
            child: Text(roomObj.name),
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(t.meetings.meeting.room, style: const TextStyle(fontSize: 12)),
        ),
        FutureBuilder<List<DropdownMenuItem<Room>>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text(t.meetings.meeting.noRoom);
            } else {
              if (dropdownValue == null) {
                dropdownValue = snapshot.data!.first.value;
                widget.controller.text = snapshot.data!.first.value!.name;
              }
              return _dropdownButton(snapshot.data!);
            }
          },
        ),
      ],
    );
  }

  DropdownButton<Room> _dropdownButton(List<DropdownMenuItem<Room>> items) {
    return DropdownButton<Room>(
      isExpanded: true,
      isDense: true,
      underline: Container(height: 1, color: Colors.black),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      padding: const EdgeInsets.symmetric(vertical: 4),
      value: dropdownValue,
      items: items,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            dropdownValue = value;
            widget.controller.text = value.name;
          });
        }
      },
    );
  }
}
