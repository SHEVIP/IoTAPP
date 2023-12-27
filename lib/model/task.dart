import 'package:untitled/model/procedure.dart';

class Task {
  int id;
  int workshopId;
  String taskName;
  String description;
  String startDate;
  String effectiveTime;
  int taskStatusId;
  int isFinished;
  List<Procedure> procedures;
  int taskTypeId;

  Task({
    required this.id,
    required this.workshopId,
    required this.taskName,
    required this.description,
    required this.startDate,
    required this.effectiveTime,
    required this.taskStatusId,
    required this.isFinished,
    required this.procedures,
    required this.taskTypeId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    List<Procedure> procedures = [];
    if (json['procedures'] != null) {
      for (var procedureJson in json['procedures']) {
        procedures.add(Procedure.fromJson(procedureJson));
      }
    }

    return Task(
      id: json['id'],
      workshopId: json['workshop_id'],
      taskName: json['task_name'],
      description: json['description'],
      startDate: json['start_date'],
      effectiveTime: json['effective_time'],
      taskStatusId: json['task_status_id'],
      isFinished: json['is_finished'],
      procedures: procedures,
      taskTypeId: json['task_type_id'],
    );
  }
}
