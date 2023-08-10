class UserModel {
  final String uid;
  const UserModel({required this.uid});
}

class UserDataModel {
  final String uid;
  final String name;
  final String sugar;
  final int strength;

  UserDataModel(
      {required this.uid,
      required this.name,
      required this.sugar,
      required this.strength});
}
