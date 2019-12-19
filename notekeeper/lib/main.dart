import 'package:flutter/material.dart';
import 'Screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMP Note',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home:NoteList()
    );
  }
}
