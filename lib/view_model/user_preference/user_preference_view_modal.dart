
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modal/login/user_modal.dart';

class UserPreference{

  Future<bool> saveUser(UserModal responseModal)async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    final res = await sp.setString('token', responseModal.token ?? '');
    return res;
  }
  Future<UserModal> getUser()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    return UserModal(
        token: token
    );
  }
  Future<bool> removeUser()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    return true;
  }
}