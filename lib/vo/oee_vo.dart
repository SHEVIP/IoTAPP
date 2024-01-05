class OEEVO {
  final int machineID;
  final double run;
  final double waiting;
  final double closed;
  final double error;

  OEEVO({
    required this.machineID,
    required this.run,
    required this.waiting,
    required this.closed,
    required this.error,
  });

  factory OEEVO.fromJson(Map<String, dynamic> json) {
    var total = json['Run'] + json['Wating'] + json['Closed'] + json['Error'];
    return OEEVO(
      machineID: json['MachineID'],
      run: json['Run'] / total,
      waiting: json['Wating'] / total,
      closed: json['Closed'] / total,
      error: json['Error'] / total,
    );
  }
}