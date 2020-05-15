import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/firebase/firebase_service.dart';
import 'package:controledecompras/pages/produtos/produto.dart';

class ProdutoDataRepository {
  final CollectionReference collection =
      Firestore.instance.collection('produtos');

  Stream<QuerySnapshot> getStream() {
    return collection.orderBy("nome", descending: false).snapshots();
  }

  Future<DocumentReference> addProduto(Produto produto, File imageFile) async {
    // First, we need to add the photo file to Firebase Storage if available
    if (imageFile != null) {
      String firebaseUrl = await FirebaseService.uploadFirebaseStorage(imageFile);
      produto.imgUrl = firebaseUrl;
    }

    return collection.add(produto.toJson());
  }

  updateProduto(Produto produto, File imageFile) async {
    if (imageFile != null) {
      // First, we need to delete product image if available
      if (produto.imgUrl != null && produto.imgUrl.isNotEmpty) {
        FirebaseService.deleteFirebaseStorage(produto.imgUrl);
      }
      // Then, we need to add the photo file to Firebase Storage if available
      String firebaseUrl = await FirebaseService.uploadFirebaseStorage(imageFile);
      produto.imgUrl = firebaseUrl;
    }

    await collection
        .document(produto.reference.documentID)
        .updateData(produto.toJson());
  }

  deleteProduto(Produto produto) async {
    if (produto.imgUrl != null && produto.imgUrl.isNotEmpty) {
      FirebaseService.deleteFirebaseStorage(produto.imgUrl);
    }
    await collection.document(produto.reference.documentID).delete();
  }

  Future<Produto> getProdutoById(String documentId) async {
    final produto = await collection.document(documentId).snapshots().first;
    if (produto != null) {
      return Produto.fromSnapshot(produto);
    }
    return null;
  }
}
