import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/Utils/database_helper.dart';
import 'package:notekeeper/Models/note.dart';


class NoteDetails extends StatefulWidget {

  final Note note;
  final String appBarTitle;
  NoteDetails({this.note,this.appBarTitle});
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {

  static var _properties = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  @override
  Widget build(BuildContext context) {
    appBarTitle = widget.appBarTitle;
    note = widget.note;

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 13.0,right: 100.0,left: 15.0),
            child: ListTile(
              title: DropdownButton(
                  items: _properties.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem));
                  }).toList(),
                  //style: textStyle,
                  value: updatePriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  }),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value) {
                updateTitle();
              },
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              controller: descriptionController,
              style: textStyle,
              onChanged: (value) {
                updateDescription();
              },
              decoration: InputDecoration(
                  labelText: 'description',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Material(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(18.0),
                    child: MaterialButton(
                        onPressed: (){
                          setState(() {//when you click on save button below function will execute
                            _saveNote();
                            Navigator.pop(context, true);

                          });
                        },
                      child: Text(
                        'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Material(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(18.0),
                    child: MaterialButton(
                      onPressed: (){
                        setState(() {//when you click on delete button below function will execute
                          _deleteNote();
                          Navigator.pop(context,true);
                        });
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // convert the String priority as Integer priority before saving into the database
void updatePriorityAsInt(String priority){

    switch(priority){
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
}

String updatePriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _properties[0];
        break;
      case 2:
        priority = _properties[1];
        break;
    }

    return priority;
}

//Helper function to update title
void updateTitle(){
    note.title = titleController.text;
}
// update the description of the note
void updateDescription(){
    note.description = descriptionController.text;
}

void _saveNote() async{

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){// it will update the note that is already exist
      result = await helper.updateNote(note);
    }else{// in this case it will create the new note in the database
      result = await helper.insertNote(note);
    }

    if(result!=0){
      _showAlertDialog('Status','Your Note saved');
    }else{
      _showAlertDialog('Status','Sorry Your note not saved');
    }
}

void _showAlertDialog(String status, String message){

    AlertDialog alertDialog = AlertDialog(
      title: Text(status),
      content: Text(message),
    );
    showDialog(context: context,
    builder: (_){
      return alertDialog;
    });
}

//delete functionality
void _deleteNote() async{
    if(note.id == null){
      _showAlertDialog('Warning', 'No note was deleted');
      return;
    }else{
      int result = await helper.deleteNote(note.id);
      if(result !=0){
        _showAlertDialog('Status', 'Note deleted successfully');
      }else{
        _showAlertDialog('Status', 'Error occured while deleting the note ');
      }
    }
}
}
