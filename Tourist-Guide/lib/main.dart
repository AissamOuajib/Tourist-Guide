import 'package:flutter/material.dart';
import 'package:tourist_guide/Classes/auth.dart';
import 'package:tourist_guide/Auth/root.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material Page Reveal',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(auth: AuthService(),),
        // home: Explore(),
    )
  );
}