import 'package:cached_network_image/cached_network_image.dart';
import 'package:controledecompras/pages/produtos/produto.dart';
import 'package:controledecompras/pages/produtos/produto_data_repository.dart';
import 'package:controledecompras/pages/produtos/produto_form_page.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:flutter/material.dart';

class ProdutosListView extends StatelessWidget {
  final List<Produto> produtos;

  ProdutosListView(this.produtos);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          Produto p = produtos[index];

          return InkWell(
            onTap: () => _onClickProduto(context, p),
            child: ListTile(
              leading: p.imgUrl != null
                  ? AspectRatio(
                      aspectRatio: 4 / 4,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            alignment: FractionalOffset.topCenter,
                            image: CachedNetworkImageProvider(p.imgUrl),
                          ),
                        ),
                      ),
                    )
                  : Image.asset(
                      "assets/images/grocery_bag.png",
                      height: 50,
                    ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case "Editar":
                      push(context, ProdutoFormPage(produto: p));
                      break;
                    case "Deletar":
                      ProdutoDataRepository().deleteProduto(p);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "Editar",
                      child: Text("Editar"),
                    ),
                    PopupMenuItem(
                      value: "Deletar",
                      child: Text("Deletar"),
                    ),
                  ];
                },
              ),
              title: Text(
                p.nome,
                style: (TextStyle(color: Colors.black)),
              ),
              subtitle: Text(
                "R\u0024 ${p.getValor()}",
                style: (TextStyle(color: Theme.of(context).accentColor)),
              ),
            ),
          );
        },
      ),
    );
  }

  _onClickProduto(context, Produto p) {
    push(context, ProdutoFormPage(produto: p));
  }
}
