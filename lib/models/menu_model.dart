import 'dart:convert';

class MenuModel {
  final String id;
  final String idSeller;
  final String nameSeller;
  final String name;
  final String price;
  final String images;
  MenuModel({
    required this.id,
    required this.idSeller,
    required this.nameSeller,
    required this.name,
    required this.price,
    required this.images,
  });

  MenuModel copyWith({
    String? id,
    String? idSeller,
    String? nameSeller,
    String? name,
    String? price,
    String? images,
  }) {
    return MenuModel(
      id: id ?? this.id,
      idSeller: idSeller ?? this.idSeller,
      nameSeller: nameSeller ?? this.nameSeller,
      name: name ?? this.name,
      price: price ?? this.price,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idSeller': idSeller,
      'nameSeller': nameSeller,
      'name': name,
      'price': price,
      'images': images,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'],
      idSeller: map['idSeller'],
      nameSeller: map['nameSeller'],
      name: map['name'],
      price: map['price'],
      images: map['images'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MenuModel(id: $id, idSeller: $idSeller, nameSeller: $nameSeller, name: $name, price: $price, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MenuModel &&
      other.id == id &&
      other.idSeller == idSeller &&
      other.nameSeller == nameSeller &&
      other.name == name &&
      other.price == price &&
      other.images == images;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idSeller.hashCode ^
      nameSeller.hashCode ^
      name.hashCode ^
      price.hashCode ^
      images.hashCode;
  }
}
