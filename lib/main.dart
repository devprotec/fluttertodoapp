import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertodoapp/homepage/homepage.dart';

import 'authen/signup_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(FirebaseAuth.instance.currentUser == null
      ? const SignupLogin()
      :  HomePageStateless(studentName:  FirebaseAuth.instance.currentUser!.displayName ?? "",));
}
