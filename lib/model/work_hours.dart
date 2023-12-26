class WorkHours {
  final int attendanceId;
  final int workerId;
  final String date;
  final String arrivalTime;
  final String departureTime;
  final String type;

  // final String status;

  WorkHours({
    required this.attendanceId,
    required this.workerId,
    required this.date,
    required this.arrivalTime,
    required this.departureTime,
    required this.type,
    // required this.status,
  });

  factory WorkHours.fromJson(Map<String, dynamic> json) {
    return WorkHours(
      attendanceId: json['attendance_id'],
      workerId: json['worker_id'],
      date: json['date'],
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
      type: json['type'],
      // status: json['status'],
    );
  }

  double getWorkHours() {
    DateTime arrival = DateTime.parse(arrivalTime);
    DateTime departure = DateTime.parse(departureTime);
    return departure.difference(arrival).inHours.toDouble();
  }
}