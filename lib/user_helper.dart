import 'package:F4Lab/api.dart';
import 'package:F4Lab/const.dart';
import 'package:F4Lab/gitlab_client.dart';
import 'package:F4Lab/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static User _user;

  static void setUser(User u) {
    _user = u;
  }

  static User getUser() {
    return _user;
  }

  static Future<String> initUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final private = sp.getString(KEY_PRIVATE_TOKEN) ?? null;
    final access = sp.getString(KEY_OAUTH_TOKEN) ?? null;
    final host = sp.getString(KEY_HOST) ?? null;
    final v = sp.getString(KEY_API_VERSION) ?? null;
    if ((private == null&& access==null) || host == null || v == null) {
      setUser(null);
      return "Not found host or toekn or api_version";
    }
    GitlabClient.setUpTokenAndHost(privateToken:private,oauthToken:access, host: host,version: v);
    final resp = await ApiService.getAuthUser();
    final err = resp.err;
    if (resp.success) {
      setUser(resp.data);
    }
    return err;
  }
}
