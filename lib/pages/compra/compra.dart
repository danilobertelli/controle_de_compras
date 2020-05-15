import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/pages/compra/carrinho.dart';


class Compra {
  String local;
  DateTime dateTime;
  bool status;
  List<String> produtos;
  List<Carrinho> produtosCart;
  List<String> owners;

  // Databse reference
  DocumentReference reference;

  Compra(this.dateTime, this.owners, {this.produtos, this.local, this.status, this.produtosCart});

  factory Compra.fromSnapshot(DocumentSnapshot snapshot) {
    Compra newCompra = Compra.fromJson(snapshot.data);
    newCompra.reference = snapshot.reference;
    return newCompra;
  }

  factory Compra.fromJson(Map<dynamic, dynamic> json) =>
      _CompraFromJson(json);

  Map<String, dynamic> toJson() => _CompraToJson(this);

  bool getStatus() {
    return status;
  }

  void setStatus(newStatus) {
    status = newStatus;
  }
}

Compra _CompraFromJson(Map<dynamic, dynamic> json) {
  return Compra(
    json['dateTime'] == null ? null : (json['dateTime'] as Timestamp).toDate(),
    json['owners'] = List.from(json["owners"]).cast<String>(),
    produtos: json['produtos'] = List.from(json["produtos"]).cast<String>(),
    local: json['local'] as String,
    status: json['status'] as bool,
    produtosCart: _convertCarrinho(json["produtos_cart"] as List),
  );
}

Map<String, dynamic> _CompraToJson(Compra instance) => <String, dynamic>{
  'dateTime': instance.dateTime,
  'owners': List.from(instance.owners),
  'produtos': List.from(instance.produtos),
  'local': instance.local,
  'status': instance.status,
  'produtos_cart': _carrinhoList(instance.produtosCart),
};

List<Carrinho> _convertCarrinho(List valorMap) {
  if (valorMap == null) {
    return null;
  }
  List<Carrinho> carrinho = List<Carrinho>();
  valorMap.forEach((value) {
    carrinho.add(Carrinho.fromJson(value));
  });
  return carrinho;
}

List<Map<String, dynamic>> _carrinhoList(List<Carrinho> carrinho) {
  if (carrinho == null) {
    return null;
  }
  List<Map<String, dynamic>> carrinhoMap = List<Map<String, dynamic>>();
  carrinho.forEach((valor) {
    carrinhoMap.add(valor.toJson());
  });
  return carrinhoMap;
}
