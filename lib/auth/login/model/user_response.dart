import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());
class UserResponse {
  int id;
  String fullName;
  String userName;
  String email;
  String password;
  List<Role> roles;
  bool enabled;
  String username;
  List<Authority> authorities;
  bool accountNonLocked;
  bool credentialsNonExpired;
  bool accountNonExpired;

  UserResponse({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    required this.roles,
    required this.enabled,
    required this.username,
    required this.authorities,
    required this.accountNonLocked,
    required this.credentialsNonExpired,
    required this.accountNonExpired,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json["id"],
    fullName: json["full_name"],
    userName: json["user_name"],
    email: json["email"],
    password: json["password"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    enabled: json["enabled"],
    username: json["username"],
    authorities: List<Authority>.from(json["authorities"].map((x) => Authority.fromJson(x))),
    accountNonLocked: json["accountNonLocked"],
    credentialsNonExpired: json["credentialsNonExpired"],
    accountNonExpired: json["accountNonExpired"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "user_name": userName,
    "email": email,
    "password": password,
    "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
    "enabled": enabled,
    "username": username,
    "authorities": List<dynamic>.from(authorities.map((x) => x.toJson())),
    "accountNonLocked": accountNonLocked,
    "credentialsNonExpired": credentialsNonExpired,
    "accountNonExpired": accountNonExpired,
  };
}

class Authority {
  String authority;

  Authority({
    required this.authority,
  });

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
    authority: json["authority"],
  );

  Map<String, dynamic> toJson() => {
    "authority": authority,
  };
}

class Role {
  dynamic id;
  String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}