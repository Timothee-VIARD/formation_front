import 'package:flutter/material.dart';
import 'package:formation_front/utils/api/api_service.dart';

import '../../../i18n/strings.g.dart';
import '../../rooms/model/room_model.dart';

class DropdownWidget extends StatefulWidget {
  final TextEditingController roomNameController;
  final TextEditingController peopleNbController;
  final Function(Room?) onRoomChanged;

  const DropdownWidget({
    super.key,
    required this.roomNameController,
    required this.peopleNbController,
    required this.onRoomChanged,
  });

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
    widget.peopleNbController.addListener(_updateRoomCapacity);
  }

  void _updateRoomCapacity() {
    setState(() {});
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

  bool _isRoomCapacityValid() {
    int peopleNb = int.tryParse(widget.peopleNbController.text) ?? 0;
    if (dropdownValue != null && peopleNb > dropdownValue!.nbMax) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Color dropDownColor =
        _isRoomCapacityValid() ? Colors.black : const Color(0xFFb00020);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(t.meetings.meeting.room,
              style: TextStyle(fontSize: 12, color: dropDownColor)),
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    dropdownValue = snapshot.data!.first.value;
                    widget.onRoomChanged(snapshot.data!.first.value);
                    widget.roomNameController.text =
                        snapshot.data!.first.value!.name;
                  });
                });
              }
              return _dropdownButton(snapshot.data!, dropDownColor);
            }
          },
        ),
        _isRoomCapacityValid()
            ? Container()
            : SizedBox(
                width: double.infinity,
                child: Text(
                    '${t.meetings.meeting.error.tooMuchUsers} (max: ${dropdownValue!.nbMax})',
                    style: TextStyle(fontSize: 12, color: dropDownColor)),
              ),
      ],
    );
  }

  DropdownButton<Room> _dropdownButton(
      List<DropdownMenuItem<Room>> items, Color dropDownColor) {
    return DropdownButton<Room>(
      isExpanded: true,
      isDense: true,
      underline: Container(height: 1, color: dropDownColor),
      style: TextStyle(color: dropDownColor, fontSize: 16),
      padding: const EdgeInsets.symmetric(vertical: 4),
      value: dropdownValue,
      items: items.map((DropdownMenuItem<Room> item) {
        return DropdownMenuItem<Room>(
          value: item.value,
          child: Text(
            item.value!.name,
            style: TextStyle(
              color: item.value == dropdownValue && !_isRoomCapacityValid()
                  ? dropDownColor
                  : Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            dropdownValue = value;
            widget.onRoomChanged(value);
            widget.roomNameController.text = value.name;
          });
        }
      },
    );
  }
}
