import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/pages/produtos/produto.dart';
import 'package:controledecompras/pages/produtos/produto_data_repository.dart';
import 'package:controledecompras/pages/produtos/produto_form_page.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:flutter/material.dart';

class CompraAddProdutoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CompraAddProdutoPageState();

  CompraAddProdutoPage({this.alreadyInCompra});

  final List<String> alreadyInCompra;
}

class CompraAddProdutoPageState extends State<CompraAddProdutoPage> {
  final _repository = ProdutoDataRepository();
  final _selectedValues = List<String>();

  get alreadyInCompra => widget.alreadyInCompra;

  @override
  void initState() {
    super.initState();
    if (alreadyInCompra != null) {
      _selectedValues.addAll(alreadyInCompra);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          leading: BackButton(
            onPressed: _onSubmitTap,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: _addProduto,
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: _onSubmitTap,
              icon: Icon(Icons.save),
            ),
            IconButton(
              onPressed: _onCancelTap,
              icon: Icon(Icons.cancel),
            ),
          ],
        ),
        body: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Colors.white),
        padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
        constraints: BoxConstraints.expand(),
        child: _buildProdutosList());
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  _buildProdutosList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _repository.getStream(),
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

        return ListTileTheme(
          child: ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              final produto = Produto.fromSnapshot(document);
              final checked = _selectedValues.contains(document.documentID);
              return CheckboxListTile(
                value: checked,
                title: Text(produto.nome),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (checked) =>
                    _onItemCheckedChange(document.documentID, checked),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _onItemCheckedChange(String documentID, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(documentID);
      } else {
        _selectedValues.remove(documentID);
      }
    });
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    _onSubmitTap();
  }

  void _addProduto() {
    push(context, ProdutoFormPage());
  }
}
