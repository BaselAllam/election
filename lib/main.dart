import 'package:election/models/main_model.dart';
import 'package:election/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: MainModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}