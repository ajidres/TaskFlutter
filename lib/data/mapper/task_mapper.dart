import 'package:task/data/model/task_model.dart';
import 'package:task/domain/entity/task_entity.dart';

class TaskMapper{

  TaskModel toModel(TaskEntity entity){
    return TaskModel(id: entity.id, task: entity.task, date: entity.date, complete: entity.complete);
  }

  List<TaskEntity> toEntity(List<TaskModel> data){
    return data.isNotEmpty?data.map((element){
      return TaskEntity(id: element.id, task: element.task, date: element.date, complete: element.complete);
    }).toList():[];
  }


}