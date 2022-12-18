import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todo_app/views/tasks_screen.dart';
import 'package:todo_app/views/archive_screen.dart';
import 'package:todo_app/views/done_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  List<Widget> screens = const [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  int currentIndex = 0;
  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoChangeBottomNavBarState());
  }

  bool isBottomSheetShown = false;
  IconData floatIcon = Icons.add;
  void changeBotoomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    floatIcon = icon;
    emit(TodoChangeBottomSheetState());
  }

  // Database Logic
  Database? database;
  List<Map> list = [];

  void createDatabase() async {
    // Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        print('Database Created)===================>');
        db
            .execute(
                ' CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created)=============>');
        }).catchError(onError);
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(TodoCreateDatabaseState());
    });
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  void getDataFromDatabase(Database database) {
    emit(TodoGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      list = value;
      newTasks.clear();
      doneTasks.clear();
      archiveTasks.clear();
      list.forEach(
        (element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archiveTasks.add(element);
          }
        },
      );
      emit(TodoGetDatabaseState());
    });
  }

  Future insertDataToDatabase(
      {required String title,
      required String date,
      required String time,
      required String status}) async {
    return await database!
        .rawInsert(
            'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "$status")')
        .then((value) {
      print('$value inserted successfuly)==================>');
      emit(TodoInsertDatabaseState());
      getDataFromDatabase(database!);
    }).catchError((error) {
      print('Error When Inserting New Record ${error.toString()} )=====>');
    });
  }

  void updateDataInDatabase({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database!);
      emit(TodoUpdateDatabaseState());
    });
  }

  void deleteDataInDatabase({
    required int id,
  }) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database!);
      emit(TodoDeleteDatabaseState());
    });
  }
}
