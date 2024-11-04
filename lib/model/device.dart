// class Device {
//   final int id;
//   String name;
//   int workshopId;
//   int machine_status_id;
//
//
//   Device({required this.id, this.name = '',this.workshopId = 0, this.machine_status_id = 0});
//
//   // 添加一个方法来更新设备名称
//   void updateName(String newName) {
//     name = newName;
//   }
//   // 添加一个方法来更新设备名称
//   void updateworkshopId(int newid) {
//     workshopId = newid;
//   }
// }

abstract class Device {
  int id;
  String name;
  String worker_name;
  int workshopId;
  int machine_status_id;
  String machine_status_name;
  int task_id;
  String time;

  Device({
    required this.id,
    required this.name,
    required this.worker_name,
    required this.workshopId,
    required this.machine_status_id,
    required this.machine_status_name,
    required this.task_id,
    required this.time,
  });

  static Device fromJson(Map<String, dynamic> json, bool isNewMachine) {
    return isNewMachine ? NewMachine.fromJson(json) : ThirdPartyMachine.fromJson(json);
  }

  // 添加一个方法来更新设备名称
  void updateName(String newName) {
    name = newName;
  }
  // 添加一个方法来更新设备名称
  void updateworkshopId(int newid) {
    workshopId = newid;
  }

}

// NewMachine 类
class NewMachine extends Device {
  int procrdure_id;
  String procrdure_name;
  String procrdure_type;
  String machine_type;
  int mode;
  int spindle_speed;
  int spindle_speed_set;
  int spindle_load;
  int spindle_override;
  double feed_rate;
  int feed_override;
  int feed_rate_set;
  int tool_num;
  int products;
  int run_time;
  int cut_time;
  int cycle_time;
  int power_on_time;
  int alm_count;
  int x_cur, y_cur, z_cur;
  int x_mach, y_mach, z_mach;
  int x_work, y_work, z_work;
  int x_res, y_res, z_res;
  int procedure_line_id;
  String status_time;

  NewMachine({
    required int id,
    required String name,
    required String worker_name,
    required int workshopId,
    required int machine_status_id,
    required String machine_status_name,
    required int task_id,
    required String time,
    required this.procrdure_id,
    required this.procrdure_name,
    required this.procrdure_type,
    required this.machine_type,
    required this.mode,
    required this.spindle_speed,
    required this.spindle_speed_set,
    required this.spindle_load,
    required this.spindle_override,
    required this.feed_rate,
    required this.feed_override,
    required this.feed_rate_set,
    required this.tool_num,
    required this.products,
    required this.run_time,
    required this.cut_time,
    required this.cycle_time,
    required this.power_on_time,
    required this.alm_count,
    required this.x_cur,
    required this.y_cur,
    required this.z_cur,
    required this.x_mach,
    required this.y_mach,
    required this.z_mach,
    required this.x_work,
    required this.y_work,
    required this.z_work,
    required this.x_res,
    required this.y_res,
    required this.z_res,
    required this.procedure_line_id,
    required this.status_time,
  }) : super(
    id: id,
    name: name,
    worker_name: worker_name,
    workshopId: workshopId,
    machine_status_id: machine_status_id,
    machine_status_name: machine_status_name,
    task_id: task_id,
    time: time,
  );

  factory NewMachine.fromJson(Map<String, dynamic> json) {
    return NewMachine(
      id: json['machine_id'] ?? 0,
      name: json['machine_name'] ?? "Unknown",
      worker_name: json['worker_name'] ?? "",
      workshopId: json['workshop_id'] ?? 0,
      machine_status_id: json['machine_status_id'] ?? 0,
      machine_status_name: json['machine_status_name'] ?? "",
      task_id: json['task_id'] ?? 0,
      time: json['time'] ?? "",
      procrdure_id: json['procrdure_id'] ?? 0,
      procrdure_name: json['procrdure_name'] ?? "",
      procrdure_type: json['procrdure_type'] ?? "",
      machine_type: json['machine_type'] ?? "",
      mode: json['mode'] ?? 0,
      spindle_speed: json['spindle_speed'] ?? 0,
      spindle_speed_set: json['spindle_speed_set'] ?? 0,
      spindle_load: json['spindle_load'] ?? 0,
      spindle_override: json['spindle_override'] ?? 0,
      feed_rate: (json['feed_rate'] ?? 0).toDouble(),
      feed_override: json['feed_override'] ?? 0,
      feed_rate_set: json['feed_rate_set'] ?? 0,
      tool_num: json['tool_num'] ?? 0,
      products: json['products'] ?? 0,
      run_time: json['run_time'] ?? 0,
      cut_time: json['cut_time'] ?? 0,
      cycle_time: json['cycle_time'] ?? 0,
      power_on_time: json['power_on_time'] ?? 0,
      alm_count: json['alm_count'] ?? 0,
      x_cur: json['x_cur'] ?? 0,
      y_cur: json['y_cur'] ?? 0,
      z_cur: json['z_cur'] ?? 0,
      x_mach: json['x_mach'] ?? 0,
      y_mach: json['y_mach'] ?? 0,
      z_mach: json['z_mach'] ?? 0,
      x_work: json['x_work'] ?? 0,
      y_work: json['y_work'] ?? 0,
      z_work: json['z_work'] ?? 0,
      x_res: json['x_res'] ?? 0,
      y_res: json['y_res'] ?? 0,
      z_res: json['z_res'] ?? 0,
      procedure_line_id: json['procedure_line_id'] ?? 0,
      status_time: json['status_time'] ?? "",
    );
  }
}

// ThirdPartyMachine 类
class ThirdPartyMachine extends Device {
  int procedure_id;
  String procedure_name;
  String procedure_type;
  int percent;
  int cur1;
  int cur2;
  int cur3;
  int gt2_h_value;
  int pos1;
  int pos2;
  bool mode;
  bool pl_auto_run;
  bool pl_home_pos;
  int v_mode;
  int procedure_line_id;
  String status_time;

  ThirdPartyMachine({
    required int id,
    required String name,
    required String worker_name,
    required int workshopId,
    required int machine_status_id,
    required String machine_status_name,
    required int task_id,
    required String time,
    required this.procedure_id,
    required this.procedure_name,
    required this.procedure_type,
    required this.percent,
    required this.cur1,
    required this.cur2,
    required this.cur3,
    required this.gt2_h_value,
    required this.pos1,
    required this.pos2,
    required this.mode,
    required this.pl_auto_run,
    required this.pl_home_pos,
    required this.v_mode,
    required this.procedure_line_id,
    required this.status_time,
  }) : super(
    id: id,
    name: name,
    worker_name: worker_name,
    workshopId: workshopId,
    machine_status_id: machine_status_id,
    machine_status_name: machine_status_name,
    task_id: task_id,
    time: time,
  );

  factory ThirdPartyMachine.fromJson(Map<String, dynamic> json) {
    return ThirdPartyMachine(
      id: json['machine_id'] ?? 0,
      name: json['machine_name'] ?? "Unknown",
      worker_name: json['worker_name'] ?? "",
      workshopId: json['workshop_id'] ?? 0,
      machine_status_id: json['machine_status_id'] ?? 0,
      machine_status_name: json['machine_status_name'] ?? "",
      task_id: json['task_id'] ?? 0,
      time: json['time'] ?? "",
      procedure_id: json['procedure_id'] ?? 0,
      procedure_name: json['procedure_name'] ?? "",
      procedure_type: json['procedure_type'] ?? "",
      percent: json['percent'] ?? 0,
      cur1: json['cur1'] ?? 0,
      cur2: json['cur2'] ?? 0,
      cur3: json['cur3'] ?? 0,
      gt2_h_value: json['gt2_h_value'] ?? 0,
      pos1: json['pos1'] ?? 0,
      pos2: json['pos2'] ?? 0,
      mode: json['mode'] ?? false,
      pl_auto_run: json['pl_auto_run'] ?? false,
      pl_home_pos: json['pl_home_pos'] ?? false,
      v_mode: json['v_mode'] ?? 0,
      procedure_line_id: json['procedure_line_id'] ?? 0,
      status_time: json['status_time'] ?? "",
    );
  }
}



