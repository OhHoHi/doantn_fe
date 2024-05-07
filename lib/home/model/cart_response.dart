import 'dart:convert';

import 'package:doan_tn/home/model/product_reponse.dart';

List<CartResponse> cartResponseFromJson(String str) => List<CartResponse>.from(json.decode(str).map((x) => CartResponse.fromJson(x)));

String cartResponseToJson(List<CartResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponse {
  int id;
  User user;
  ProductResponse product;
  int quantity;
  DateTime createdAt;


  CartResponse({
    required this.id,
    required this.user,
    required this.product,
    required this.quantity,
    required this.createdAt,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    id: json["id"],
    user: User.fromJson(json["user"]),
    product: ProductResponse.fromJson(json["product"]),
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "product": product.toJson(),
    "quantity": quantity,
  };
}
class User {
  int id;
  String fullName;
  String userName;
  String email;
  String password;
  List<dynamic> roles;
  bool enabled;
  String username;
  List<Authority> authorities;
  bool accountNonLocked;
  bool credentialsNonExpired;
  bool accountNonExpired;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    userName: json["user_name"],
    email: json["email"],
    password: json["password"],
    roles: List<dynamic>.from(json["roles"].map((x) => x)),
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
    "roles": List<dynamic>.from(roles.map((x) => x)),
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
