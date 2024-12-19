import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task/domain/entity/task_entity.dart';
import 'package:task/domain/repository/task_repository.dart';
import 'package:task/ui/task_list_screen.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final TaskHiveRepository _repository = TaskHiveRepositoryImpl();

  Future<void> fetchTask() async {
    var result = await _repository.getTask();

    result.fold(
      (error) {

      },
      (success) async {
        emit(TaskLoad(success));
      },
    );

    print('');
  }

  void addTask() {
    emit(TaskAdd());
  }

  Future<void> addTaskItem(Map<String, dynamic> data) async {

    var objectToAdd =
        TaskEntity(id: DateTime.now().microsecond, task: data[TASK_TO_ADD], date: data[DATE_TO_ADD], complete: false);

    var result = await _repository.saveTask(objectToAdd);

    result.fold(
      (error) {

      },
      (success) async {
        fetchTask();
      },
    );
  }

  Future<void> updateTask(int pos, TaskEntity data) async {

    data.complete=!data.complete;
    var result = await _repository.updateTask(pos,data);

    result.fold(
          (error) {

      },
          (success) async {
        fetchTask();
      },
    );
  }

  Future<void> deleteTask(int pos) async {

    var result = await _repository.deleteTask(pos);

    result.fold(
          (error) {

      },
          (success) async {
        fetchTask();
      },
    );
  }
}
