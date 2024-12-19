import 'package:fpdart/fpdart.dart';
import 'package:task/data/mapper/task_mapper.dart';
import 'package:task/data/remote/task_hive_source.dart';
import 'package:task/domain/entity/task_entity.dart';

abstract class TaskHiveRepository {
  Future<Either<String, void>> saveTask(TaskEntity task);

  Future<Either<String, List<TaskEntity>>> getTask();

  Future<Either<String, void>> deleteTask(int pos);

  Future<Either<String, void>> updateTask(int pos,TaskEntity task);
}

class TaskHiveRepositoryImpl implements TaskHiveRepository {
  final TaskHiveDataSource _repository = TaskHiveDataSourceImpl();

  @override
  Future<Either<String, void>> deleteTask(int pos) async {
    try {
      await _repository.deleteTask(pos);
      return const Right("");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TaskEntity>>> getTask() async {
    try {
      var result = await _repository.getTask();
      return Right(TaskMapper().toEntity(result));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> saveTask(TaskEntity task) async {
    try {
      await _repository.saveTask(TaskMapper().toModel(task));
      return const Right("");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateTask(int pos,TaskEntity task) async {
    try {
      await _repository.updateTask(pos, TaskMapper().toModel(task));
      return const Right("");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
