class DeviceException {
  final int id;
  String name;

  DeviceException({required this.id, this.name = ''});

  // 添加一个方法来更新设备名称
  void updateName(String newName) {
    name = newName;
  }

  // 静态Map来存储id和name的对应关系
  static final Map<int, String> _deviceExceptionMap = {};

  // 添加异常实例到Map
  static void addException(DeviceException exception) {
    _deviceExceptionMap[exception.id] = exception.name;
  }

  // 根据id查找name
  static String findNameById(int id) {
    if (_deviceExceptionMap.containsKey(id)) {
      return _deviceExceptionMap[id]!;
    } else {
      throw Exception("No DeviceException found with id: $id");
    }
  }

  // 一次性将列表中的所有异常添加到Map
  static void initializeMap(List<DeviceException> exceptions) {
    for (var exception in exceptions) {
      _deviceExceptionMap[exception.id] = exception.name;
    }
  }
}
