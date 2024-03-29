import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/Models/note.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper; // Singleton databasehelper
  static Database _database;


  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String coleDate = 'date';
  String colPriority = 'priority';

  DatabaseHelper._createInstance(); // Named Constructor to create instance of databaseHelper

  factory DatabaseHelper() {
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
// it is for the initializing the database
   Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database; // Singleton database
   }
//database initialization function code
   Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    // open/ create a database at a given path
     var notesDatabase = await openDatabase(path,version: 1,onCreate: _createDb);

     return notesDatabase;
  }

  void _createDb(Database db, int version) async{
    await db.execute('CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $coleDate TEXT )');
  }


  //fetch Operation:get all Note Objects from the database
  Future<List<Map<String,dynamic>>> getNoteMapList() async{
    Database db = await this.database;

   var result =  await db.query(noteTable,orderBy: '$colPriority ASC');

   return result;
  }

  // Insert Operation: insert note into the database
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    
    var result = await db.insert(noteTable,note.toMap());

    return result;
  }

  // Update Operation : update the details of the note in the database

Future<int> updateNote(Note note) async{
    Database db = await this.database;
    
    var result = await db.update(noteTable, note.toMap(),where: '$colId =?', whereArgs: [note.id]);
    
    return result;
}

// delete Operation: delete note from database

Future<int> deleteNote(int id) async{
    Database db = await this.database;
    
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');

    return result;
}

// getItem nuber of note objects from the database

Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
}

//First get the 'Map list|List<Map>' and Convert it into 'Note List |List<Note>'
Future<List<Note>> getNoteList() async{

    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    
    List<Note> noteList = List<Note>();
    
    for(int i=0;i<count;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
}

}