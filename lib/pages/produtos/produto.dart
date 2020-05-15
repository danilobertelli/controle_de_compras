import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/pages/produtos/valor.dart';

class Produto {
  String barcode;
  String nome;
  String imgUrl;
  List<Valor> valores = List<Valor>();

  // Databse reference
  DocumentReference reference;

  Produto(this.nome, this.valores, {this.imgUrl, this.barcode});

  factory Produto.fromSnapshot(DocumentSnapshot snapshot) {
    Produto newProduto = Produto.fromJson(snapshot.data);
    newProduto.reference = snapshot.reference;
    return newProduto;
  }

  factory Produto.fromJson(Map<dynamic, dynamic> json) =>
      _ProdutoFromJson(json);

  Map<String, dynamic> toJson() => _ProdutoToJson(this);

  // Retorna o ultimo valor para o produto
  String getValor() {
    if (valores != null && valores.isNotEmpty) {
      return valores[valores.length -1].valor.toString();
    }
    return "";
  }

  @override
  String toString() {
    return nome;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Produto &&
          runtimeType == other.runtimeType &&
          reference.documentID == other.reference.documentID;

  @override
  int get hashCode => reference.documentID.hashCode;
}

Produto _ProdutoFromJson(Map<dynamic, dynamic> json) {
  return Produto(
    json['nome'] as String,
    json['valores'] = _convertValores(json["valores"] as List),
    imgUrl: json['img_url'] as String,
    barcode: json['barcode'] as String,
  );
}

List<Valor> _convertValores(List valorMap) {
  if (valorMap == null) {
    return null;
  }
  List<Valor> valores = List<Valor>();
  valorMap.forEach((value) {
    valores.add(Valor.fromJson(value));
  });
  return valores;
}

Map<String, dynamic> _ProdutoToJson(Produto instance) => <String, dynamic>{
      'nome': instance.nome,
      'valores': _valoresList(instance.valores),
      'img_url': instance.imgUrl,
      'barcode': instance.barcode,
    };

List<Map<String, dynamic>> _valoresList(List<Valor> valores) {
  if (valores == null) {
    return null;
  }
  List<Map<String, dynamic>> valoresMap = List<Map<String, dynamic>>();
  valores.forEach((valor) {
    valoresMap.add(valor.toJson());
  });
  return valoresMap;
}
