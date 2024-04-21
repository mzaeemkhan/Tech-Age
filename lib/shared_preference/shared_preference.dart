import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences _sharedPrefs;

  setMaxAge(int value) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    _sharedPrefs.setInt("max_age", value);
  }

  Future<int> getMaxAge() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    int value = 0;
    if (_sharedPrefs.containsKey("max_age")) {
      value = _sharedPrefs.getInt("max_age");
    }
    return value;
  }

  setMainAge(int value) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    _sharedPrefs.setInt("min_age", value);
  }

  Future<int> getMinAge() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    int value = 0;
    if (_sharedPrefs.containsKey("min_age")) {
      value = _sharedPrefs.getInt("min_age");
    }
    return value;
  }

}