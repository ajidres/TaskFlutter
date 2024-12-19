part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}
final class TaskLoading extends TaskState {}
final class TaskHideLoading extends TaskState {}

final class TaskAdd extends TaskState {}
final class TaskLoad extends TaskState {
  final List<TaskEntity> data;

  TaskLoad(this.data);
}

