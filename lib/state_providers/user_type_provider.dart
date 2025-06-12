import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';

class UserTypeProvider extends Notifier<UserType?> {
  @override
  UserType? build() {
    return null;
  }

  void setType(UserType uType) {
    state = uType;
  }
}

final userTypeProvider = NotifierProvider<UserTypeProvider, UserType?>(
  () => UserTypeProvider(),
);
