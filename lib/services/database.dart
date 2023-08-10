import 'package:brew_crew/models/brew_model.dart';
import 'package:brew_crew/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brew');

  Future updateUserData(
      {required String sugar,
      required String name,
      required int strength}) async {
    return await brewCollection.doc(uid).set({
      'sugar': sugar,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<BrewModel> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (e) => BrewModel(
            name: e['name'] ?? "",
            sugar: e['sugar'] ?? "0",
            strength: e['strength'] ?? 0,
          ),
        )
        .toList();
  }

  // userData model from snapshot
  // user data obj
  UserDataModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserDataModel(
      uid: uid ?? "",
      name: snapshot['name'],
      sugar: snapshot['sugar'],
      strength: snapshot['strength'],
    );
  }

  // get data from firestore into our app
  // notify any changes
  // get brews Stream
  // Stream<QuerySnapshot> get brews {
  Stream<List<BrewModel>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  // Stream<QuerySnapshot>
  // Stream<DocumentSnapshot> get userData {
  Stream<UserDataModel> get userData {
    // we convert it to UserDataModel in _userDataFromSnapshot method
    // .. document for user id
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
