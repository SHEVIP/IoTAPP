enum MachineStatus {
  zero(name: '从1开始索引'),
  running(name: '运行'),
  waiting(name: '等待'),
  closed(name: '关机'),
  exception(name: '异常');

  const MachineStatus({required this.name});
  final String name;
}

extension MachineStatusType on MachineStatus {
  static MachineStatus getTypeFormIndex(int index) {
    return MachineStatus.values[index];
  }
}