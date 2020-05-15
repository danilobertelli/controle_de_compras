import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:controledecompras/pages/produtos/produto.dart';
import 'package:controledecompras/pages/produtos/produto_data_repository.dart';
import 'package:controledecompras/pages/produtos/valor.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:controledecompras/utils/widgets/app_button.dart';
import 'package:controledecompras/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProdutoFormPage extends StatefulWidget {
  final Produto produto;

  ProdutoFormPage({this.produto});

  @override
  State<StatefulWidget> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final ProdutoDataRepository repository = ProdutoDataRepository();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tValor = TextEditingController();

  var _showProgress = false;
  File _file;

  Produto get produto => widget.produto;

  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Informe o nome do produto.';
    }

    return null;
  }

  String _validateValor(String value) {
    if (value.isNotEmpty && double.parse(value) >= 0) {
      return null;
    }

    return "Valor inválido!";
  }

  @override
  void initState() {
    super.initState();

    // Copia os dados do produto para o form
    if (produto != null) {
      tNome.text = produto.nome;
      tValor.text = produto.getValor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          produto != null ? produto.nome : "Novo Produto",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(context),
      ),
    );
  }

  _form(context) {
    return Form(
      key: this._formKey,
      child: ListView(
        children: <Widget>[
          _headerFoto(context),
          Text(
            "Clique na imagem para tirar uma foto",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          AppText(
            "Nome",
            "",
            controller: tNome,
            keyboardType: TextInputType.text,
            validator: _validateNome,
          ),
          AppText(
            "Valor",
            "",
            controller: tValor,
            keyboardType: TextInputType.number,
            validator: _validateValor,
          ),
          AppButton(
            "Salvar",
            onPressed: _onClickSalvar,
            showProgress: _showProgress,
          )
        ],
      ),
    );
  }

  _headerFoto(context) {
    return InkWell(
      onTap: () => _onClickFoto(context),
      child: _file != null
          ? Image.file(
              _file,
              height: 150,
            )
          : produto != null &&
                  produto.imgUrl != null &&
                  produto.imgUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: produto.imgUrl,
                  height: 150,
                )
              : Image.asset(
                  "assets/images/camera.png",
                  height: 150,
                ),
    );
  }

  void _onClickFoto(context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Escolha uma opção para obter a imagem"),
              ),
              ListTile(
                title: Text("Camera"),
                leading: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  File file =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    setState(() {
                      this._file = file;
                    });
                    pop(context);
                  }
                },
              ),
              ListTile(
                title: Text("Galeria"),
                leading: Icon(
                  Icons.photo,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  File file =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      this._file = file;
                    });
                  }
                  pop(context);
                },
              ),
            ],
          );
        });
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    var nome = tNome.text;
    Valor valor = Valor(double.parse(tValor.text), new DateTime.now());
    List<Valor> valores;

    if (produto != null &&
        produto.valores != null &&
        produto.valores.isNotEmpty) {
      produto.valores.add(valor);
    } else {
      valores = List<Valor>();
      valores.add(valor);
    }

    var newProduto =
        produto ?? Produto(nome, valores, imgUrl: null, barcode: "000000000");

    if(produto != null) {
      produto.nome = nome;
      //produto.barcode = b
    }

    setState(() {
      _showProgress = true;
    });

    if (produto == null) {
      repository.addProduto(newProduto, _file);
    } else {
      repository.updateProduto(produto, _file);
    }

    setState(() {
      _showProgress = false;
    });
    pop(context);
  }
}
