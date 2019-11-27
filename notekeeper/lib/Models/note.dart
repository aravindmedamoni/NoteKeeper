

class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get priority => _priority;

  String get date => _date;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  set priority(int value) {
    if (value >= 1 && value <= 2) {
      _priority = value;
    }
  }

  set date(String value) {
    _date = value;
  }

  set description(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  set title(String value) {
    if (value.length <= 255) {
      _title = value;
    }
  }

  // It is a Function Convert Note Object into the Map object Because SQFlite Deals with Only maps
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

// Extract Note Object from Map Object

  Note.fromMapObject(Map<String, dynamic> map) {

    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _date = map['date'];
    _priority = map['priority'];
  }
}
