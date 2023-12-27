class WorkshopStatusVO {
    final int machineId;
    final String machineName;
    final int machineStatus;
    final String workerName;
    final int procedureId;
    final String procedureName;
    final String procedureType;
    final int taskId;
    final String time;
    final num percent;

    WorkshopStatusVO({
        required this.machineId,
        required this.machineName,
        required this.machineStatus,
        required this.workerName,
        required this.procedureId,
        required this.procedureName,
        required this.procedureType,
        required this.taskId,
        required this.time,
        required this.percent,
    });

    factory WorkshopStatusVO.fromJson(Map<String, dynamic> json) {
        return WorkshopStatusVO(
            machineId: json['machine_id'],
            machineName: json['machine_name'],
            machineStatus: json['machine_status'],
            workerName: json['worker_name'],
            procedureId: json['procrdure_id'],
            procedureName: json['procrdure_name'],
            procedureType: json['procrdure_type'],
            taskId: json['task_id'],
            time: json['time'],
            percent: json['percent'],
        );
    }
}