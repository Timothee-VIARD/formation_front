import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../controllers/cubit.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  CreateUserDialogState createState() => CreateUserDialogState();
}

class CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      final user = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      context.read<UsersCubit>().createUser(user);
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
                    t.users.user.alert,
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
                          labelText: t.users.user.name,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.users.user.name_hint;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: t.users.user.email,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.users.user.email_hint;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: t.users.user.password,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.users.user.password_hint;
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
                      t.users.user.confirm,
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
