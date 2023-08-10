// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:brew_crew/models/brew_model.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

import 'brew_list.dart';
import 'settings_form.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    // this function responsible for showing the bottom sheet
    void _showSettingsPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0)
              .copyWith(bottom: 40.0),
          child: const SettingsForm(),
        ),
      );
    }

    return StreamProvider<List<BrewModel>>.value(
      value: DatabaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: const Text("Brew Crew"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async => _showSettingsPanel(),
              icon: const Icon(
                Icons.settings,
              ),
            ),
            IconButton(
              onPressed: () async => _auth.singOut(),
              icon: const Icon(
                Icons.logout_rounded,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: const BrewList(),
        ),
      ),
    );
  }
}
