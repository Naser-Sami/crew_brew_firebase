import 'package:brew_crew/models/user_model.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text("Sign In to Brew Crew"),
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
                Text("Sign In")
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
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
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
                            await _auth.registerWithEmailAndPassword(
                                email: email, password: password);

                        if (result == null) {
                          setState(() {
                            loading = false;
                            error = 'please supply a valid email';
                          });
                        }

                        setState(() => loading = false);
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
