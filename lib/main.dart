import 'package:flutter/material.dart';
import 'package:fetch_data/page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

 void initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() {
  initFirebase();
  runApp(MaterialApp(
    title: 'Air quality',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      fontFamily: 'Hind',
    ),
    home: MyApp(),
    )
  );
} 

