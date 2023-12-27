import 'package:shared_preferences/shared_preferences.dart';

/// 对Preferences数据存储进行封装
/// 获取值：CommonPreferences.<field_name>.value
/// 存储值：CommonPreferences.<field_name>.value = ?

class CommonPreferences {
  CommonPreferences._();

  static late SharedPreferences sharedPref;

  // 用户信息
  static final isLogin = PrefsBean<bool>('login');  // 是否已登录
  static final phone = PrefsBean<String>('phone');  // 手机号
  static final password = PrefsBean<String>('password');  // 密码
  static final username = PrefsBean<String>('username');  // 用户令牌
  static final workername = PrefsBean<String>('workername');  // 用户令牌
  static final userid = PrefsBean<int>('userid');  // userid
  static final workerid = PrefsBean<int>('workerid');  // userid

  // 初始化
  static Future<void> init() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  /// 清除所有缓存
  static void clearAllPrefs() {
    sharedPref.clear();
  }
}

class PrefsBean<T> with PreferencesUtil<T> {
  PrefsBean(this._key, [this._default]) {
    _default ??= _getDefaultValue();
  }

  final String _key;
  T? _default;

  T get value => _getValue(_key) ?? _default;

  set value(T newValue) => _setValue(newValue, _key);

  void clear() => _clearValue(_key);
}

mixin PreferencesUtil<T> {
  static SharedPreferences get pref => CommonPreferences.sharedPref;

  dynamic _getValue(String key) => pref.get(key);

  _setValue(T value, String key) async {
    switch (T) {
      case String:
        await pref.setString(key, value as String);
        break;
      case bool:
        await pref.setBool(key, value as bool);
        break;
      case int:
        await pref.setInt(key, value as int);
        break;
      case double:
        await pref.setDouble(key, value as double);
        break;
      case List:
        await pref.setStringList(key, value as List<String>);
        break;
    }
  }

  void _clearValue(String key) async => await pref.remove(key);

  dynamic _getDefaultValue() {
    switch (T) {
      case String:
        return '';
      case int:
        return 0;
      case double:
        return 0.0;
      case bool:
        return false;
      case List:
        return [];
      default:
        return null;
    }
  }
}
