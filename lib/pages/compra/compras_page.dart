import 'package:cached_network_image/cached_network_image.dart';
import 'package:controledecompras/firebase/firebase_service.dart';
import 'package:controledecompras/pages/compra/carrinho.dart';
import 'package:controledecompras/pages/compra/compra.dart';
import 'package:controledecompras/pages/compra/compra_add_produto_page.dart';
import 'package:controledecompras/pages/compra/compra_data_repository.dart';
import 'package:controledecompras/pages/produtos/produto.dart';
import 'package:controledecompras/pages/produtos/produto_data_repository.dart';
import 'package:controledecompras/pages/produtos/valor.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:controledecompras/utils/widgets/app_dialog.dart';
import 'package:controledecompras/utils/widgets/app_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComprasPage extends StatefulWidget {
  final Compra compra;

  @override
  State<StatefulWidget> createState() => ComprasPageState(compra);

  ComprasPage({this.compra});
}

class ComprasPageState extends State<ComprasPage> {
  final CompraDataRepository _repository = CompraDataRepository();
  var _isNewCompra;
  var _produtosCompra = <Produto>[];
  var _carrinho = <Carrinho>[];
  var owners = <String>[];

  Compra compraStateObject;

  ComprasPageState(Compra compra) {
    compraStateObject = compra;
  }

  @override
  void initState() {
    super.initState();
    owners.add(firebaseUserUid);
    _isNewCompra = compraStateObject == null;
    compraStateObject =
        compraStateObject ?? Compra(DateTime.now(), owners, status: false);
    _repository
        .getProdutoCompra(compraStateObject)
        .then((List<Produto> values) {
      setState(() {
        _produtosCompra = values;
      });
    });
    if (!_isNewCompra) {
      _carrinho = compraStateObject.produtosCart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onSaveCompra(true),
      child: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          elevation: 0.0,
          leading: BackButton(
            onPressed: () => _onSaveCompra(true),
          ),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            Visibility(
              visible: !compraStateObject.status,
              child: IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () => _onSaveCompra(false),
              ),
            ),
          ],
        ),
        body: _body(context),
      ),
    );
  }

  _body(context) {
    return Column(
      children: <Widget>[
        _header(),
        _comprasList(context),
      ],
    );
  }

  _header() {
    return Flexible(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 16.0, top: 0.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Lista de Compra",
              style: Theme.of(context).textTheme.headline5.apply(
                    color: Colors.white,
                    fontWeightDelta: 1,
                  ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Informações da Compra",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Previsão de valor: R\u0024 ${_getValor()}",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: compraStateObject.status,
                    child: _headerComprasClosed(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _comprasList(context) {
    return Flexible(
      flex: compraStateObject.status ? 2 : 3,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Colors.white),
        padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Produtos",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Builder(
                    builder: (context) => Visibility(
                          visible: !compraStateObject.status,
                          child: FlatButton(
                            child: Text(
                              "ADICIONAR PRODUTOS",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              _showAddProdutos(context);
                            },
                          ),
                        )),
              ],
            ),
            Expanded(
              child: _produtosCompra.isEmpty
                  ? _emptyProdutosView()
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 16.0),
                      itemCount: _produtosCompra.length,
                      itemBuilder: (ctx, i) {
                        if (_produtosCompra.isNotEmpty) {
                          Produto p = _produtosCompra[i];
                          return Container(
                            decoration: new BoxDecoration(
                                color: !compraStateObject.status &&
                                        _carrinhoContainsProduto(p) >= 0
                                    ? Colors.orangeAccent[100]
                                    : Colors.white),
                            child: ListTile(
                              leading: p.imgUrl != null
                                  ? AspectRatio(
                                      aspectRatio: 4 / 4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fitHeight,
                                            alignment:
                                                FractionalOffset.topCenter,
                                            image: CachedNetworkImageProvider(
                                                p.imgUrl),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/images/grocery_bag.png",
                                      height: 50,
                                    ),
                              title: Text(p.nome),
                              trailing: Visibility(
                                visible: !compraStateObject.status,
                                child: IconButton(
                                  icon: _carrinhoContainsProduto(p) >= 0
                                      ? Icon(Icons.remove_shopping_cart)
                                      : Icon(Icons.add_shopping_cart),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () => _addToCart(p),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return _emptyProdutosView();
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  _headerComprasClosed() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 9,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Compra finalizada em: ${DateFormat("dd-MM-yyyy").format(compraStateObject.dateTime)}",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        SizedBox(
          height: 9,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Local de compra: ${compraStateObject.local}",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ],
    );
  }

  _emptyProdutosView() {
    return Center(
      child: Text("Nenhum produto em sua lista de compras"),
    );
  }

  _getValor() {
    double valor = 0.0;
    if (_produtosCompra != null && _produtosCompra.isNotEmpty) {
      for (var produto in _produtosCompra) {
        var valorProduto = _getValorFromCarrinho(produto);
        valor += valorProduto;
      }
    }
    return valor.toString();
  }

  double _getValorFromCarrinho(produto) {
    var index = _carrinhoContainsProduto(produto);
    if (index >= 0) {
      return _carrinho[index].quantidade * double.parse(produto.getValor());
    }
    return double.parse(produto.getValor());
  }

  void _addToCart(Produto produto) async {
    var quantidade = 1.0;
    if (_carrinhoContainsProduto(produto) == -1) {
      quantidade = await _atualizaPrecoGetQtd(produto);
    }

    setState(() {
      if (_carrinhoContainsProduto(produto) >= 0) {
        _removerCarrinho(produto);
      } else {
        _adicionarCarrinho(produto, quantidade);
      }
    });
  }

  void _showAddProdutos(context) async {
    final selectedProdutos = await push(
        context,
        CompraAddProdutoPage(
          alreadyInCompra: _getProdutosKeys(_produtosCompra),
        ));
    if (selectedProdutos != null) {
      _repository
          .getProdutoByDocument(selectedProdutos)
          .then((List<Produto> values) {
        setState(() {
          _produtosCompra = values;
          _checkCarrinho(values);
        });
      });
    }
  }

  int _carrinhoContainsProduto(Produto produto) {
    int index = -1;
    if (_carrinho != null && _carrinho.length > 0) {
      for (int i = 0; i < _carrinho.length; i++) {
        if (_carrinho[i].produtoId == produto.reference.documentID) {
          return i;
        }
      }
    }
    return index;
  }

  _removerCarrinho(Produto produto) {
    int index = _carrinhoContainsProduto(produto);
    if (index >= 0) {
      _carrinho.removeAt(index);
    }
  }

  _adicionarCarrinho(Produto produto, double quantidade) {
    if (_carrinho == null) {
      _carrinho = <Carrinho>[];
    }
    final Carrinho novoProduto =
        Carrinho(produto.reference.documentID, quantidade);
    _carrinho.add(novoProduto);
  }

  List<String> _getProdutosKeys(List<Produto> produtosCompra) {
    var _alreadyIn = <String>[];
    produtosCompra.forEach((element) {
      _alreadyIn.add(element.reference.documentID);
    });
    return _alreadyIn;
  }

  Future<double> _atualizaPrecoGetQtd(Produto produto) async {
    var novoPreco = produto.getValor();
    var quantidade = 1.0;

    final tValorInput = TextEditingController();
    final tQuantInput = TextEditingController();

    tValorInput.text = produto.getValor();
    tQuantInput.text = quantidade.toString();

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) => CustomInputDialog(
        title: "Atualizar informações",
        description: "Gostaria de atualizar o preço e a quantidade?",
        buttonText: "OK",
        inputAction: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Quantidade:'),
                controller: tQuantInput,
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Valor:'),
                controller: tValorInput,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null &&
        result &&
        tValorInput.text != null &&
        tValorInput.text.isNotEmpty) {
      novoPreco = tValorInput.text;
    }

    if (novoPreco != produto.getValor()) {
      produto.valores.add(new Valor(double.parse(novoPreco), DateTime.now()));
      ProdutoDataRepository().updateProduto(produto, null);
    }

    if (tQuantInput.text != null && tQuantInput.text.isNotEmpty) {
      quantidade = double.parse(tQuantInput.text);
    }
    return quantidade;
  }

  Future<bool> _onSaveCompra(bool saveExit) async {
    if (_carrinho != null &&
        compraStateObject.produtosCart != null &&
        compraStateObject.produtos != null &&
        compraStateObject.produtosCart.length ==
            compraStateObject.produtos.length &&
        !compraStateObject.status) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
          title: "Finalizar compra?",
          description:
              "Parece que você já adicionou todos os produtos em seu carrinho, gostaria de fechar a compra?",
          buttonTextConfirm: "Sim",
          buttonTextNegative: "Não",
        ),
      );
      if (result != null && result) {
        compraStateObject.setStatus(true);
        _saveCompra(saveExit);
        return true;
      }
    }
    _saveCompra(saveExit);
    return false;
  }

  void _saveCompra(bool saveExit) async {
    if (_produtosCompra.isNotEmpty) {
      // Now we should save the compra or update it
      compraStateObject.produtos = _getProdutosKeys(_produtosCompra);
      compraStateObject.produtosCart = _carrinho;

      if (_isNewCompra) {
        compraStateObject.dateTime = DateTime.now();
        compraStateObject.reference = await _repository.addCompra(compraStateObject);
        _isNewCompra = false;
      } else {
        compraStateObject.dateTime = DateTime.now();
        _repository.updateCompra(compraStateObject);
      }
    }
    if (saveExit) pop(context);
  }

  void _checkCarrinho(List<Produto> values) {
    var _toRemove = <Carrinho>[];
    _carrinho.forEach((carrinho) {
      var result = values.every(
          (produto) => carrinho.produtoId != produto.reference.documentID);
      if (result) _toRemove.add(carrinho);
    });
    _toRemove.forEach((element) => _carrinho.remove(element));
  }
}
