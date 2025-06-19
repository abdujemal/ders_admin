import 'package:ders_admin/constants.dart';
import 'package:ders_admin/pages/add_course.dart';
import 'package:ders_admin/pages/courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'database_helper.dart';
import 'firebase_options.dart';

final dotEnv = DotEnv();

main() async {
  // html.window.document.querySelector('body')!.style.fontFamily = 'MyFont';
  WidgetsFlutterBinding.ensureInitialized();
  // DatabaseHelper().initializeDatabase().catchError((e)=>print(e));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  auth
      .signInWithEmailAndPassword(
          email: "ilmfelagiadmins@gmail.com", password: '1234asdf')
      .then((value) {
    Fluttertoast.showToast(msg: "Successfully logged in");
  }).catchError((e) {
    Fluttertoast.showToast(msg: e.toString());
  });
  await dotEnv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: primaryColor,
        primaryColor: primaryColor,
      ),
      home: const Courses(),
    );
  }
}
