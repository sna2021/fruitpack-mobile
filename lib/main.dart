import 'package:flutter/material.dart';
import 'package:fruitpackmobile/packs/packsView.dart';
import 'colors.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PacksView(),
    );
  }
}
