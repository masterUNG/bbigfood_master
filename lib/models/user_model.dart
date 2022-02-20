import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String user;
  final String password;
  final String type;
  final String avatar;
  final String lat;
  final String lng;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.user,
    required this.password,
    required this.type,
    required this.avatar,
    required this.lat,
    required this.lng,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? user,
    String? password,
    String? type,
    String? avatar,
    String? lat,
    String? lng,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      user: user ?? this.user,
      password: password ?? this.password,
      type: type ?? this.type,
      avatar: avatar ?? this.avatar,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'user': user,
      'password': password,
      'type': type,
      'avatar': avatar,
      'lat': lat,
      'lng': lng,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      user: map['user'],
      password: map['password'],
      type: map['type'],
      avatar: map['avatar'],
      lat: map['lat'],
      lng: map['lng'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, user: $user, password: $password, type: $type, avatar: $avatar, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.user == user &&
        other.password == password &&
        other.type == type &&
        other.avatar == avatar &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        user.hashCode ^
        password.hashCode ^
        type.hashCode ^
        avatar.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }
}
