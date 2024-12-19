import 'package:hive/hive.dart';
import 'package:task/data/model/task_model.dart';

abstract class TaskHiveDataSource {
  Future<void> saveTask(TaskModel task);

  Future<void> updateTask(int pos,TaskModel task);

  Future<List<TaskModel>> getTask();

  Future<void> deleteTask(int pos);
}

class TaskHiveDataSourceImpl implements TaskHiveDataSource {
  final String _boxName = "tasks";

  Future<Box<TaskModel>> get _box async => await Hive.openBox<TaskModel>(_boxName);

  @override
  Future<void> saveTask(TaskModel task) async {
    var box = await _box;
    await box.add(task);
  }

  @override
  Future<void> updateTask(int pos, TaskModel task) async {
    var box = await _box;
    await box.putAt(pos, task);
  }

  @override
  Future<List<TaskModel>> getTask() async {
    var box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> deleteTask(int pos) async {
    var box = await _box;
    await box.deleteAt(pos);
  }
}
