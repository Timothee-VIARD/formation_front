import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../controllers/cubit.dart';

class CreateRoomDialog extends StatefulWidget {
  const CreateRoomDialog({super.key});

  @override
  CreateRoomDialogState createState() => CreateRoomDialogState();
}

class CreateRoomDialogState extends State<CreateRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      final room = {
        'name': _nameController.text,
        'nb_max': _emailController.text,
      };
      context.read<RoomsCubit>().createRoom(room);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = pow(screenWidth / 10, 2) * 0.0225;
    final verticalPadding = pow(screenHeight / 10, 2) * 0.03;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    t.rooms.room.alert,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: t.rooms.room.name,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.rooms.room.name_hint;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: t.rooms.room.capacity,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.rooms.room.capacity_hint;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox(height: 0)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createUser,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      t.rooms.room.confirm,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
}
