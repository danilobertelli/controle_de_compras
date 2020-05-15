import 'package:cloud_firestore/cloud_firestore.dart';

class Valor {
  double valor;
  DateTime date;

  Valor(this.valor, this.date);

  factory Valor.fromJson(Map<dynamic, dynamic> json) => _ValorFromJson(json);

  Map<String, dynamic> toJson() => _ValorToJson(this);
}

Valor _ValorFromJson(Map<dynamic, dynamic> json) {
  return Valor(
    json['valor'] as double,
    json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _ValorToJson(Valor instance) => <String, dynamic>{
      'valor': instance.valor,
      'date': instance.date,
    };
