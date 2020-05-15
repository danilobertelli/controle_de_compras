import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/pages/compra/compra.dart';
import 'package:controledecompras/pages/produtos/produto.dart';
import 'package:controledecompras/pages/produtos/produto_data_repository.dart';

class CompraDataRepository {
  final CollectionReference collection =
      Firestore.instance.collection('compras');

  Stream<QuerySnapshot> getStream() {
    return collection.orderBy("dateTime", descending: true).snapshots();
  }

  Future<DocumentReference> addCompra(Compra compra) async {
    return collection.add(compra.toJson());
  }

  updateCompra(Compra compra) async {
    await collection
        .document(compra.reference.documentID)
        .updateData(compra.toJson());
  }

  deleteCompra(Compra compra) async {
    await collection.document(compra.reference.documentID).delete();
  }

  Future<List<Produto>> getProdutoCompra(Compra compra) async {
    var produtos = <Produto>[];
    if (compra != null && compra.produtos != null) {
      ProdutoDataRepository produtoDataRepository = ProdutoDataRepository();
      for(int i = 0; i < compra.produtos.length; i++) {
        final novoProduto = await produtoDataRepository.getProdutoById(compra.produtos[i]);
        if (novoProduto != null) {
          produtos.add(novoProduto);
        }
      }
    }
    return produtos;
  }

  Future<List<Produto>> getProdutoByDocument(List<String> documentIds) async {
    var produtos = <Produto>[];
    if (documentIds != null && documentIds.isNotEmpty != null) {
      ProdutoDataRepository produtoDataRepository = ProdutoDataRepository();
      for(int i = 0; i < documentIds.length; i++) {
        final novoProduto = await produtoDataRepository.getProdutoById(documentIds[i]);
        if (novoProduto != null) {
          produtos.add(novoProduto);
        }
      }
    }
    return produtos;
  }
}
