import 'package:flutter/material.dart';
import 'Screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note keeper App',
      theme: ThemeData(
       // primaryColorDark: Colors.blue[900],
        primaryColor: Colors.deepPurple[700],
      ),
      debugShowCheckedModeBanner: false,
      home:NoteList()
    );
  }
}
