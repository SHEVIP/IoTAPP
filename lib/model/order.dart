import 'package:untitled/model/procedure.dart';

class Order {
  final String taskName;
  final String workshopName;
  final String startTime;
  final String effectiveTime;
  final String totalNum;
  final String finishNum;
  final String procedureStatusID;
  final String isFinished;
  final String description;

  Order({
    required this.taskName,
    required this.workshopName,
    required this.startTime,
    required this.effectiveTime,
    required this.totalNum,
    required this.finishNum,
    required this.procedureStatusID,
    required this.isFinished,
    required this.description,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      taskName: json['TaskName'] as String,
      workshopName: json['WorkshopName'] as String,
      startTime: json['StartTime'] as String,
      effectiveTime: json['EffectiveTime'] as String,
      totalNum: json['TotalNum'] as String,
      finishNum: json['FinishNum'] as String,
      procedureStatusID: json['ProcedureStatusID'] as String,
      isFinished: json['IsFinished'] as String,
      description: json['Description'] as String,
    );
  }
}
