class Device {
  final int id;
  String name;
  int workshopId;
  int machine_status_id;


  Device({required this.id, this.name = '',this.workshopId = 0, this.machine_status_id = 0});

  // 添加一个方法来更新设备名称
  void updateName(String newName) {
    name = newName;
  }
  // 添加一个方法来更新设备名称
  void updateworkshopId(int newid) {
    workshopId = newid;
  }
}