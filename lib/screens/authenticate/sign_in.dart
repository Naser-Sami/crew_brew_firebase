import 'package:brew_crew/models/user_model.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final void Function() toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    }
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text("Sign Up to Brew Crew"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Row(
              children: [
                Icon(
                  Icons.person_3_outlined,
                ),
                Text("Sign Up")
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'email'),
                  validator: (value) => email.isEmpty ? "Enter an email" : null,
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'password'),
                  validator: (value) => password.length < 6
                      ? "Enter a password 6+ chart long"
                      : null,
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
                const SizedBox(height: 40),
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
                        print(email);
                        print(password);

                        setState(() => loading = true);

                        UserModel? result =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);

                        if (result == null) {
                          setState(() {
                            loading = false;
                            error = 'could not sign in with those credentials';
                          });
                        }

                        setState(() => loading = false);
                      }
                    },
                    child: const Text("Sign In"),
                  ),
                ),
                error == '' ? const SizedBox() : const SizedBox(height: 12),
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('or sign in anonymously'),
                    TextButton(
                      onPressed: () async {
                        UserModel? result = await _auth.signInAnon();

                        if (result == null) {
                          print('error sign in');
                        } else {
                          print('user signed in successfully');
                          print(result.uid);
                        }
                      },
                      child: const Text("Sign In Anon"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
