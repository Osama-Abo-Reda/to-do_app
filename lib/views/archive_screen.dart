import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:todo_app/widgets/tasks_builder.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = BlocProvider.of<TodoCubit>(context).archiveTasks;
        return tasksBuilder(
          tasks: tasks,image: 'assets/archiveTask.png',
        );
      },
    );
  }
}
