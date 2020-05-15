class Carrinho {
  String produtoId;
  double quantidade;

  Carrinho(this.produtoId, this.quantidade);

  factory Carrinho.fromJson(Map<dynamic, dynamic> json) => _CarrinhoFromJson(json);

  Map<String, dynamic> toJson() => _CarrinhoToJson(this);

  @override
  String toString() {
    return produtoId;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Carrinho &&
          runtimeType == other.runtimeType &&
          produtoId == other.produtoId;

  @override
  int get hashCode => produtoId.hashCode;
}

Carrinho _CarrinhoFromJson(Map<dynamic, dynamic> json) {
  return Carrinho(
    json['produtoId'] as String,
    json['quantidade'] as double,
  );
}

Map<String, dynamic> _CarrinhoToJson(Carrinho instance) => <String, dynamic>{
  'produtoId': instance.produtoId,
  'quantidade': instance.quantidade,
};
