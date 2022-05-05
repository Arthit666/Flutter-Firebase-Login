// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, avoid_print, unused_catch_clause, empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vibrationapp/model/profile.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>(); //chech status of form
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Register'),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username', style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: 'Please enter username'),
                              onSaved: (String? username) {
                                profile.username = username;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Password', style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: 'Please enter password'),
                              obscureText: true,
                              onSaved: (String? password) {
                                profile.password = password;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Email', style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please enter email'),
                                EmailValidator(
                                    errorText: 'Invalid email address format.')
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? email) {
                                profile.email = email;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Company', style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: 'Please enter company'),
                              onSaved: (String? company) {
                                profile.company = company;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text('Register',
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: profile.email!,
                                              password: profile.password!)
                                          .then((value) {
                                        // print('username = ${profile.username}');
                                        // print('password = ${profile.password}');
                                        // print('email = ${profile.email}');
                                        // print('company = ${profile.company}');
                                        formKey.currentState?.reset();
                                        Fluttertoast.showToast(
                                            msg: 'Register complete',
                                            gravity: ToastGravity.TOP);
                                        Navigator.pushReplacementNamed(
                                            context, '/');
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      // print(e.message);
                                      Fluttertoast.showToast(
                                          msg: e.message!,
                                          gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
