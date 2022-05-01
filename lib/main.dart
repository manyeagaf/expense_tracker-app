// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/screens/expenses_history_screen.dart';
import 'package:expenses_tracker/screens/gerd.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:expenses_tracker/screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<DBHelper>(
      create: (context) => DBHelper(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Expense Tracker',
        theme: ThemeData(),
        home: HomeScreen());
  }
}
