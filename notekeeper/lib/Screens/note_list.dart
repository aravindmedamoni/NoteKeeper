import 'package:flutter/material.dart';
import 'note_details.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:notekeeper/Utils/database_helper.dart';
import 'package:notekeeper/Models/note.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Future Tasks'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Add Note',
        onPressed: () {
         navigateToDetails(Note('', '', 2), 'Add Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //This method will shows list of our tasks

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:gettingPriorityColor(this.noteList[position].priority),
              child: gettingPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: textStyle,
            ),
            subtitle: Text(
              this.noteList[position].date,
              style: textStyle,
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: (){
                _deleteNote(context, noteList[position]);
              },
            ),
            onTap: () {
              navigateToDetails(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // This function is to navigate NoteDetails class
  void navigateToDetails(Note note, String title) async{
     bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetails(note:note, appBarTitle:title);
    }));

     if(result == true){
       updateListView();
     }
  }


  // Getting the color based on the priority for the ListTile Leading icon
Color gettingPriorityColor(int priority){

    switch(priority){
      case 1:
        return Colors.deepOrange;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
}

// Getting the Icon based on the priority for the ListTile Leading Icon
Icon gettingPriorityIcon(int priority){

    switch(priority){
      case 1:
        return Icon(Icons.star,color: Colors.white);
        break;
      case 2:
        return Icon(Icons.star_border,color: Colors.white);
        break;

      default:
        return Icon(Icons.star_border,color: Colors.white);
    }
}

// This is for deleting the note whenever click on the delete icon from the ListTile

void _deleteNote(BuildContext context,Note note) async{

    int result = await this.databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context,'Note is Delete Successfully');
      updateListView();
    }
}

void _showSnackBar(BuildContext context, String message){

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
}

void updateListView(){

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
}

}
