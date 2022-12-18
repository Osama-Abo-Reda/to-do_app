import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is TodoInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text(
                'To-do App',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: ConditionalBuilder(
              condition: state is! TodoGetDatabaseLoadingState,
              builder: (context) => BlocProvider.of<TodoCubit>(context)
                  .screens[BlocProvider.of<TodoCubit>(context).currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).primaryColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.7),
              currentIndex: BlocProvider.of<TodoCubit>(context).currentIndex,
              onTap: ((value) {
                BlocProvider.of<TodoCubit>(context).changeIndex(value);
                // setState(() {
                //   currentIndex = value;
                // });
              }),
              items: [
                BottomNavigationBarItem(
                  label: 'Tasks',
                  icon: BlocProvider.of<TodoCubit>(context).currentIndex == 0
                      ? const Icon(
                          Icons.menu_open,
                        )
                      : const Icon(
                          Icons.menu,
                        ),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon: BlocProvider.of<TodoCubit>(context).currentIndex == 1
                      ? const Icon(
                          Icons.done_all_sharp,
                        )
                      : const Icon(
                          Icons.done,
                        ),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon: BlocProvider.of<TodoCubit>(context).currentIndex == 2
                      ? const Icon(
                          Icons.archive,
                        )
                      : const Icon(
                          Icons.archive_outlined,
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                BlocProvider.of<TodoCubit>(context).floatIcon,
              ),
              onPressed: () {
                if (BlocProvider.of<TodoCubit>(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    BlocProvider.of<TodoCubit>(context).insertDataToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        status: 'new');
                    BlocProvider.of<TodoCubit>(context)
                        .changeBotoomSheetState(isShow: false, icon: Icons.add);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                    (context) => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: const Color(0xfff6f5ee).withOpacity(.5),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Tasks Title'),
                                prefixIcon: Icon(Icons.task),
                                filled: true,
                              ),
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Tasks Time'),
                                prefixIcon: Icon(Icons.watch_later_outlined),
                                filled: true,
                              ),
                              controller: timeController,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Tasks Date'),
                                prefixIcon: Icon(Icons.date_range),
                                filled: true,
                              ),
                              controller: dateController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  keyboardType: TextInputType.datetime,
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              keyboardType: TextInputType.none,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Date must not be empty';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  BlocProvider.of<TodoCubit>(context).changeBotoomSheetState(
                      isShow: true, icon: Icons.add_task);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
