class Procedure {
  int id;
  String procedureType;
  String procedureName;
  int taskId;
  int machineId;
  int workpiecesNum;
  int processedNum;
  int sequence;
  int machineSequence;
  String startDate;
  int isFinished;
  int procedureStatusId;
  dynamic procedureItems;

  Procedure({
    required this.id,
    required this.procedureType,
    required this.procedureName,
    required this.taskId,
    required this.machineId,
    required this.workpiecesNum,
    required this.processedNum,
    required this.sequence,
    required this.machineSequence,
    required this.startDate,
    required this.isFinished,
    required this.procedureStatusId,
    required this.procedureItems,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'],
      procedureType: json['procedure_type'],
      procedureName: json['procedure_name'],
      taskId: json['task_id'],
      machineId: json['machine_id'],
      workpiecesNum: json['workpieces_num'],
      processedNum: json['processed_num'],
      sequence: json['sequence'],
      machineSequence: json['machine_sequence'],
      startDate: json['start_date'],
      isFinished: json['is_finished'],
      procedureStatusId: json['procedure_status_id'],
      procedureItems: json['procedure_items'],
    );
  }
}
