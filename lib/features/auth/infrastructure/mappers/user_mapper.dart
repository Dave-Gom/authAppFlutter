import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  static User fromJsonSinToken(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
      fullName: json["fullName"],
      isActive: json["isActive"],
      roles: List<String>.from(json["roles"].map((x) => x)),
      token: '');
}
