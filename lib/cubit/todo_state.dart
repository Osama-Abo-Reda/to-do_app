part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoChangeBottomNavBarState extends TodoState {}

class TodoChangeBottomSheetState extends TodoState {}

class TodoCreateDatabaseState extends TodoState {}

class TodoGetDatabaseLoadingState extends TodoState {}

class TodoGetDatabaseState extends TodoState {}

class TodoInsertDatabaseState extends TodoState {}

class TodoUpdateDatabaseState extends TodoState {}

class TodoDeleteDatabaseState extends TodoState {}
