
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel{

  @HiveField(0)
  int id;

  @HiveField(1)
  String task;

  @HiveField(2)
  String date;

  @HiveField(3)
  bool complete;

  TaskModel({required this.id, required this.task, required this.date, required this.complete});
}