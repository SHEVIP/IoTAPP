class DeviceException {
  final int id;
  String name;

  DeviceException({required this.id, this.name = ''});

  // 添加一个方法来更新设备名称
  void updateName(String newName) {
    name = newName;
  }
}