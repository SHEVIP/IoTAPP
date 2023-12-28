import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/components/work/device_card.dart';
import 'package:untitled/model/device.dart';
import 'package:untitled/model/exception.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/prefs_util.dart';
class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({super.key});

  @override
  State<DeviceManagementPage> createState() => _DeviceManagementPageState();
}
class _DeviceManagementPageState extends State<DeviceManagementPage> {
  List<Device> _devices = [];
  List<DeviceException> _deviceExceptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> params = {
      "user_id": CommonPreferences.userid.value.toString(), // 确保这里是获取值的正确方式
      "start": 1,
      "limit": 10,
    };

    try {
      var exceptionResult = await NetworkUtil.getInstance().get("machineStatus/machineStatuss");
      if (exceptionResult != null && exceptionResult.data['status'] == 200) {
        List<dynamic> items = exceptionResult.data['data']['item'];
        for (var item in items) {
            int deviceExceptionId = item['id'];
            String deviceExceptionName = item['status_name'];
            // 创建设备对象并添加到设备列表
            DeviceException deviceException = DeviceException(id: deviceExceptionId,name: deviceExceptionName);
            _deviceExceptions.add(deviceException);
          }
      }
      var result = await NetworkUtil.getInstance().get("worker/workers", params: params);
      if (result != null && result.data['status'] == 200) {
      // 解析设备信息
        List<dynamic> items = result.data['data']['item'];
        for (var item in items) {
          List<dynamic> machineWorkers = item['machine_workers'];
          for (var machineWorker in machineWorkers) {
            int machineId = machineWorker['machine_id'];
            // 创建设备对象并添加到设备列表
            Device device = Device(id: machineId,);
            _devices.add(device);

            // 发送请求获取设备名称
            await _fetchDeviceName(device);
          }
        }
      }
      // 处理结果，更新状态等
      } catch (e) {
        // 错误处理
        debugPrint("网络请求错误: $e");
      } finally {
        setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchDeviceName(Device device) async {
  try {
    var response = await NetworkUtil.getInstance().get('machine/${device.id}');
    if (response != null && response.data['status'] == 200) {
      String deviceName = response.data['data']['machine_name']; // 根据实际返回的数据结构进行调整
      int workshopId = response.data['data']['workshop_id']; // 根据实际返回的数据结构进行调整
      device.updateName(deviceName);
      device.updateworkshopId(workshopId);
    }
  } catch (e) {
    debugPrint("获取设备名称出错: $e");
  }
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 0,
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _devices.length, // 使用_devices列表的长度作为列表项计数
            itemBuilder: (context, index) {
              // 获取对应索引的设备
              final device = _devices[index];
              return DeviceCard(
                deviceName: device.name, // 使用设备的名称
                deviceId: device.id,
                onTap: () => reportException(context, device), // 传入设备名称到异常上报函数
              );
            },
          ),
  );
}
void reportException(BuildContext context, Device device) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '设备状态上报 - ${device.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text('选择上报内容：'),
              const SizedBox(height: 8.0),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 两列
                    crossAxisSpacing: 10, // 水平间距
                    mainAxisSpacing: 10, // 垂直间距
                    childAspectRatio: 3, // 宽高比为3
                  ),
                  itemCount: _deviceExceptions.length,
                  itemBuilder: (context, index) {
                    final exception = _deviceExceptions[index];
                    return ElevatedButton(
                      onPressed: () async {
                        await reportDeviceException(device, exception.id);
                        Navigator.pop(context);
                      },
                      child: Text(exception.name),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String formatTimestamp(DateTime dateTime) {
  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  return formatter.format(dateTime);
}

Future<void> reportDeviceException(Device device, int exceptionId) async {
  String timestamp = formatTimestamp(DateTime.now());
  int deviceId = device.id;
  int workshopId = device.workshopId;
  Map<String, dynamic> params = {
    "machine_id": deviceId,
    "machine_status_id": exceptionId,
    "time": timestamp, // ISO 8601 格式的时间戳
  };
  Map<String, dynamic> deviceParams = {
    "workshop_id": workshopId,
    "machine_status_id": exceptionId,
  };

  try {
    var deviceResult = await NetworkUtil.getInstance().put("machine/$deviceId", params: deviceParams);

    var result = await NetworkUtil.getInstance().post("machineLog", params: params);
    params.remove("time");
    var response = await NetworkUtil.getInstance().post('machineAnomaly',params: params);

    // 根据 response 处理结果
    if (response?.data['status'] == 200 && result?.data['status']==200  && deviceResult?.data['status']==200) {
      // 弹出提醒
      const snackBar = SnackBar(
        content: Text('异常上报成功!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      debugPrint('异常上报成功');
    } else {
      debugPrint('异常上报失败：${response?.data['status']}');
    }
  } catch (e) {
    debugPrint('发送异常上报请求错误：$e');
  }
}

}

