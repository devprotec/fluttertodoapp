import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../homepage/homepage.dart';

class Methods {
  Methods._privateConstructor();
  static final Methods instance = Methods._privateConstructor();

  onLogin(GlobalKey<FormState> _formKey, String email, String password,
      BuildContext context) {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>  HomePage(studentName:value.user!.displayName ,)));
      }).catchError((e) {
        Alert(
            style: const AlertStyle(titleStyle: TextStyle(color: Colors.red)),
            context: context,
            type: AlertType.error,
            title: "Error",
            desc: e.message,
            buttons: [
              DialogButton(
                child: const Text(
                  "Dismiss",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
                width: 120,
              ),
            ]).show();
      });
    }
  }

  onSignup(GlobalKey<FormState> _formKey, String email, String password, String name,
      BuildContext context) {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
            value.user!.updateDisplayName(name);
           // FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>   HomePage(studentName: name,)));
      }).catchError((e) {
        Alert(
            style: const AlertStyle(titleStyle: TextStyle(color: Colors.red)),
            context: context,
            type: AlertType.error,
            title: "Error",
            desc: e.message,
            buttons: [
              DialogButton(
                child: const Text(
                  "Dismiss",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
                width: 120,
              ),
            ]).show();
      });
    }
  }
}
