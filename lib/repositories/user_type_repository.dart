import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/utils/app_config.dart';

class UserTypeRepository {
  Future<UserType?> loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString(AppConfig.kUserTypeKey);
    if (userTypeString == null) return null;

    try {
      return UserType.values.firstWhere((e) => e.name == userTypeString);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserType(UserType userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.kUserTypeKey, userType.name);
  }
}

final userTypeRepositoryProvider = Provider<UserTypeRepository>((ref) {
  return UserTypeRepository();
});