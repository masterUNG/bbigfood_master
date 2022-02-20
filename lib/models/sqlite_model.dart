import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SQLiteModel {
  final int? id;
  final String idSeller;
  final String nameSeller;
  final String idMenu;
  final String nameMenu;
  final String price;
  final String amount;
  final String sum;
  SQLiteModel({
     this.id,
    required this.idSeller,
    required this.nameSeller,
    required this.idMenu,
    required this.nameMenu,
    required this.price,
    required this.amount,
    required this.sum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idSeller': idSeller,
      'nameSeller': nameSeller,
      'idMenu': idMenu,
      'nameMenu': nameMenu,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: (map['id'] ?? 0) as int,
      idSeller: (map['idSeller'] ?? '') as String,
      nameSeller: (map['nameSeller'] ?? '') as String,
      idMenu: (map['idMenu'] ?? '') as String,
      nameMenu: (map['nameMenu'] ?? '') as String,
      price: (map['price'] ?? '') as String,
      amount: (map['amount'] ?? '') as String,
      sum: (map['sum'] ?? '') as String,
    );
  }

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
