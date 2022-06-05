import 'package:election/models/user_model/user_controller.dart';
import 'package:election/models/user_model/vooter_controller.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainModel extends Model with UserController, VooterController {}

class MainData {
  static String url = 'http://vote.webeetec.com/api/';
  static Map<String, String>? defaultHeader = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  static saveToLocalStorage(String key, String value) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    _shared.setString(key, value);
  }

  static Future<String> getFromLocalStorage(String key) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? _data;

    try {
      _data = _shared.getString(key);
    } catch (e) {
      _data = '';
    }
    return _data!;
  }
}
