import 'package:brew_crew/models/brew_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brew_tile.dart';

class BrewList extends StatefulWidget {
  const BrewList({super.key});

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    // final brews = Provider.of<QuerySnapshot?>(context);
    // print(brews?.docs);

    // if (brews?.docs != null) {
    //   for (var doc in brews!.docs) {
    //     print(doc.data());
    //     print("name: ${doc['name']}");
    //   }
    // }

    final brews = Provider.of<List<BrewModel>>(context);
    if (brews.isNotEmpty) {
      // for (var doc in brews) {
      // print(doc.name);
      // print(doc.sugar);
      // print(doc.strength);
      // }

      brews.forEach((brew) {
        if (kDebugMode) {
          print(brew.name);
          print(brew.sugar);
          print(brew.strength);
        }
      });
    }

    return ListView.builder(
      itemCount: brews.length,
      itemBuilder: (context, index) => BrewTile(brew: brews[index]),
    );
  }
}
