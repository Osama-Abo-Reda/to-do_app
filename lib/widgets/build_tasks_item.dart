import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/todo_cubit.dart';

Widget buildTasksItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}',
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          IconButton(
            onPressed: (() {
              BlocProvider.of<TodoCubit>(context).updateDataInDatabase(
                status: 'done',
                id: model['id'],
              );
            }),
            icon: model['status'] == 'done'
                ? const Icon(
                    Icons.done_all_sharp,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.done,
                    color: Colors.red,
                  ),
          ),
          const SizedBox(
            width: 25,
          ),
          IconButton(
            onPressed: (() {
              BlocProvider.of<TodoCubit>(context).updateDataInDatabase(
                status: 'archive',
                id: model['id'],
              );
            }),
            icon: model['status'] == 'archive'
                ? const Icon(
                    Icons.archive,
                    color: Colors.black54,
                  )
                : const Icon(
                    Icons.archive_outlined,
                    color: Colors.black54,
                  ),
          ),
        ],
      ),
    ),
    onDismissed: (direction) =>
        BlocProvider.of<TodoCubit>(context).deleteDataInDatabase(
      id: model['id'],
    ),
  );
}
