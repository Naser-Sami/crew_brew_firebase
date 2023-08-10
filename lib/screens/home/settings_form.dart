// ignore_for_file: unused_field

import 'package:brew_crew/models/user_model.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return StreamBuilder<UserDataModel>(
        stream: DatabaseService(uid: user?.uid ?? "").userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDataModel? userData = snapshot.data;
            return FormWidget(userData: userData);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error happened"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          return const SizedBox();
        });
  }
}

class FormWidget extends StatefulWidget {
  final UserDataModel? userData;
  const FormWidget({super.key, required this.userData});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Update your brew settings.',
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            initialValue: widget.userData?.name ?? "",
            decoration: textInputDecoration,
            validator: (String? value) =>
                value!.isEmpty ? "Please enter a value." : null,
            onChanged: (value) => setState(() => _currentName = value),
          ),
          const SizedBox(height: 20.0),
          DropdownButtonFormField(
            decoration: textInputDecoration,
            value: _currentSugars ?? widget.userData?.sugar ?? '0',
            items: sugars
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text("$e sugars"),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _currentSugars = value),
          ),
          const SizedBox(height: 20.0),
          Slider(
            min: 100.0,
            max: 900.0,
            divisions: 8,
            value: (_currentStrength ?? widget.userData?.strength ?? 100)
                .toDouble(),
            onChanged: (value) =>
                setState(() => _currentStrength = value.round()),
            activeColor: Colors.brown[_currentStrength ?? 100],
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // <-- Radius
                ),
                side: const BorderSide(color: Colors.black, width: 2),
                backgroundColor: Colors.black, // Background color
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await DatabaseService(uid: user?.uid)
                      .updateUserData(
                        name: _currentName ?? widget.userData?.name ?? "",
                        sugar: _currentSugars ?? widget.userData?.sugar ?? "0",
                        strength:
                            _currentStrength ?? widget.userData?.strength ?? 0,
                      )
                      .then(
                        (value) => Navigator.pop(context),
                      );

                  print(_currentName);
                  print(_currentSugars);
                  print(_currentStrength);
                }
              },
              child: const Text("Update"),
            ),
          ),
        ],
      ),
    );
  }
}
