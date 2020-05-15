import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/pages/produtos/produto.dart';
import 'package:controledecompras/pages/produtos/produto_data_repository.dart';
import 'package:controledecompras/pages/produtos/produto_form_page.dart';
import 'package:controledecompras/pages/produtos/produtos_list_view.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:flutter/material.dart';

class ProdutosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProdutosPageState();
}

class ProdutosPageState extends State<ProdutosPage> {
  final ProdutoDataRepository repository = ProdutoDataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addNewProduto(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Produtos",
              style: Theme.of(context).textTheme.headline5.apply(
                    color: Colors.white,
                    fontWeightDelta: 2,
                  ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: repository.getStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Não foi possível buscar os produtos"),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return _buildProdutoList(
                            context, snapshot.data.documents);
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildProdutoList(
      BuildContext context, List<DocumentSnapshot> documents) {
    List<Produto> produtos = documents.map((DocumentSnapshot document) {
      return Produto.fromSnapshot(document);
    }).toList();

    if (produtos != null && produtos.isEmpty) {
      return Center(
        child: Text("Nenhum produto cadastrado."),
      );
    }
    return ProdutosListView(produtos);
  }

  _addNewProduto(context) {
    push(context, ProdutoFormPage());
  }
}
