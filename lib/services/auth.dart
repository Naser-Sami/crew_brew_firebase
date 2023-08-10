import 'package:brew_crew/models/user_model.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUsers
  UserModel? _userFromFirebaseUsers(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth changes user stream
  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        // .map((User? user) => _userFromFirebaseUsers(user));
        .map(_userFromFirebaseUsers); // do same as above code
  }

  // .. sign in anon
  Future signInAnon() async {
    try {
      /**
       * 
       * FirebaseUser changed to User
       * AuthResult changed to UserCredential
       * GoogleAuthProvider.getCredential() changed to GoogleAuthProvider.credential()
       * onAuthStateChanged which notifies about changes to the user's sign-in state was replaced with authStateChanges()
       * currentUser() which is a method to retrieve the currently logged in user, was replaced with the property currentUser and it no longer returns a Future<FirebaseUser>
       */

      // AuthResult to UserCredential
      final UserCredential result = await _auth.signInAnonymously();

      // FirebaseUser to User
      User? user = result.user;

      print('user is $user');
      return _userFromFirebaseUsers(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // .. sign in with email and password
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;
      return _userFromFirebaseUsers(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // .. sign up with email and password
  Future registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user?.uid ?? "").updateUserData(
        name: 'new crew member',
        sugar: '0',
        strength: 100,
      );

      return _userFromFirebaseUsers(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // .. sign out
  Future singOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
