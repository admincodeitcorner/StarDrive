


import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../domain/entities/auth_user.dart';
import '../../model/auth_response_model.dart';

class AuthLocalStorage {
  static const String _boxName = 'authBox';
  static const String _userKey = 'authUser';

  Box get _box => Hive.box(_boxName);

  
  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Future<void> saveUser(AuthUser user) async {
    await _box.put(_userKey, AuthResponseModel.fromEntity(user).toJson());
  }

  AuthUser? getUser() {
    final data = _box.get(_userKey);
    if (data == null) return null;
    return AuthResponseModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> clearUser() async {
    await _box.delete(_userKey);
  }
}