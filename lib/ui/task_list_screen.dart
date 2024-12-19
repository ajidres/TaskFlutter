import 'package:date_time_picker_ultra/date_time_piker/dialog_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:task/ui/cubit/task_cubit.dart';
import 'package:task/widget/empty_state_widget.dart';
import 'package:task/widget/loading_widget.dart';
import 'package:task/widget/text_form_widget.dart';

const TASK_TO_ADD = 'task';
const DATE_TO_ADD = 'date';

class TaskListScreen extends StatefulWidget {
  TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  BuildContext? dialogContext;

  bool pendingTask = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TaskCubit()..fetchTask(),
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (contextBloc, state) async {
            if (state is TaskLoading) {
              showDialog(
                  context: contextBloc,
                  barrierDismissible: false,
                  useSafeArea: true,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext contextDialog) {
                    dialogContext = contextDialog;
                    return Container(
                      color: Colors.transparent,
                      child: const LoadingWidget(),
                    );
                  });
            }
            if (state is TaskHideLoading) {
              if (dialogContext != null) {
                Navigator.pop(dialogContext!);
              }
              dialogContext = null;
            }

            if (state is TaskAdd) {
              final formKey = GlobalKey<FormState>();

              final TextEditingController taskController = TextEditingController();

              final TextEditingController dateController = TextEditingController();

              // _taskController.text = 'text1';

              showModalBottomSheet(
                  context: contextBloc,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        height: 400,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormWidget(
                                      textController: taskController,
                                      textInputType: TextInputType.text,
                                      maxLength: 250,
                                      maxLine: 6,
                                      minLine: 1,
                                      hint: 'Do groceries',
                                      label: 'Task',
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please add a valid task';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Stack(
                                      children: [
                                        TextFormWidget(
                                          textController: dateController,
                                          textInputType: TextInputType.text,
                                          maxLength: 250,
                                          maxLine: 6,
                                          minLine: 1,
                                          label: 'Date',
                                          hint: '12/19/2024',
                                          enable: false,
                                          validator: (String? value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please add a valid date';
                                            }
                                            return null;
                                          },
                                        ),
                                        Positioned(
                                          top: 20,
                                          child: DateTimePickerUltraDialog(
                                            selectedDate: DateTime.now(),
                                            initialTime: TimeOfDay.now(),
                                            showDatePicker: true,
                                            showTimePicker: true,
                                            onPress: (DateTime dateTime) {
                                              dateController.text = DateFormat('yyyy/MM/dd hh:mm').format(dateTime);
                                            },
                                            title:
                                                '                                                                    ',
                                            iconColor: Colors.grey,
                                            color: Colors.deepPurple,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FloatingActionButton(
                                          backgroundColor: Colors.deepPurple,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              contextBloc.read<TaskCubit>().addTaskItem({
                                                TASK_TO_ADD: taskController.text,
                                                DATE_TO_ADD: dateController.text
                                              });

                                              Navigator.of(context).pop();
                                            }
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
          buildWhen: (context, state) {
            return state is TaskLoad;
          },
          builder: (contextBloc, state) {
            if (state is TaskInitial || state is TaskLoading) {
              return Container(
                color: Colors.white,
                child: const LoadingWidget(),
              );
            }

            var listData = (state as TaskLoad).data.where((element) {
              return pendingTask?!element.complete:element.complete;
            }).toList();

            return Scaffold(
              appBar: AppBar(
                title: const Text('Tasks'),
                actions: [
                  IconButton(
                      onPressed: () {
                        contextBloc.read<TaskCubit>().addTask();
                      },
                      icon: Image.asset(
                        'assets/add_task.png',
                        height: 25,
                      ))
                ],
              ),
              body: Column(
                children: [
                  Visibility(
                      visible: listData.isEmpty,
                      child: const Expanded(
                        child: EmptyStateWidget(),
                      )),
                  Visibility(
                      visible: listData.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){setState(() {
                                pendingTask=!pendingTask;
                              });},
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: pendingTask?Colors.white:Colors.deepPurple,
                                      border: Border.all(width: 3.0, color: Colors.deepPurple),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        bottomLeft: Radius.circular(18)
                                      ),
                                    ),
                                    child: Text('Pending',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: pendingTask?Colors.deepPurple:Colors.white,
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: !pendingTask?Colors.white:Colors.deepPurple,
                                      border: Border.all(width: 3.0, color: Colors.deepPurple),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(18),
                                          bottomRight: Radius.circular(18)
                                      ),
                                    ),
                                    child: Text('Completed',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: !pendingTask?Colors.deepPurple:Colors.white,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: listData.where((element) {
                                return pendingTask?!element.complete:element.complete;
                              }).length,
                              itemBuilder: (BuildContext context, int index) {
                                return Slidable(
                                  startActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          contextBloc.read<TaskCubit>().deleteTask(index);
                                        },
                                        autoClose: true,
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          contextBloc.read<TaskCubit>().updateTask(index, listData[index]);
                                        },
                                        autoClose: true,
                                        backgroundColor: Colors.green,
                                        icon: Icons.check,
                                        label: 'Complete',
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                listData[index].task,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                listData[index].date,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            );
          },
        ));
  }
}
