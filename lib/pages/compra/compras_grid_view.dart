import 'package:controledecompras/pages/compra/compra.dart';
import 'package:controledecompras/pages/compra/compras_page.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:controledecompras/utils/widgets/compras_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComprasGridView extends StatelessWidget {
  final List<Compra> compras;

  final Function callback;

  ComprasGridView(this.compras, {this.callback});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: ScrollPhysics(),
      padding: EdgeInsets.all(0.0),
      itemCount: compras.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 16 / 9,
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        Compra c = compras[index];
        return ComprasCard(
          compra: c,
          onPress: () => _onComprasTap(context, c),
          onLongPress: () => _onComprasLongPressed(context, c),
        );
      },
      shrinkWrap: true,
    );
  }

  void _onComprasTap(context, Compra c) {
    print("Compra tapped: $c");
    print("Compra carrinho: ${c.produtosCart}");
    push(context, ComprasPage(compra: c));
  }

  void _onComprasLongPressed(context, Compra c) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Compra: ${DateFormat("dd-MM-yyyy").format(c.dateTime)}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                title: Text(
                  "Finalizar compra",
                  style: TextStyle(fontSize: 14),
                ),
                leading: Icon(
                  Icons.done,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  pop(context);
                  callback(0, c);
                },
              ),
              ListTile(
                title: Text(
                  "Apagar compra",
                  style: TextStyle(fontSize: 14),
                ),
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  pop(context);
                  callback(1, c);
                },
              ),
            ],
          );
        });
  }
}