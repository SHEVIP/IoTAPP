enum MachineStatus {
  zero(name: '从1开始索引'),
  running(name: '运行'),
  waiting(name: '等待'),
  closed(name: '关机'),
  exception(name: '设备异常'),
  exception1(name: '电气故障'),
  exception2(name: '程序出错'),
  exception3(name: '控制故障'),
  exception4(name: '操作失误'),
  exception5(name: '机械磨损'),
  exception6(name: '电器维修');


  const MachineStatus({required this.name});
  final String name;
}

extension MachineStatusType on MachineStatus {
  static MachineStatus getTypeFormIndex(int index) {
    return MachineStatus.values[index];
  }
}