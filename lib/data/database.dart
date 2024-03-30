import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  //reference the hive box
  final _todoBox = Hive.box('todoBox');

  //run this if first time ever opening the app
  void createInitialData() {
    toDoList = [
      {'taskName': 'Go for a run', 'taskCompleted': false},
      {'taskName': 'Go to school', 'taskCompleted': false},
    ];
  }

  //load the data from database
  void loadData() {
    toDoList = _todoBox.get("TODOLIST");
  }

  //update database
  void updateDatabase() {
    _todoBox.put("TODOLIST", toDoList);
  }
}

//update edits
