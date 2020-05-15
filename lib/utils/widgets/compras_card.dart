import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:controledecompras/pages/compra/compra.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComprasCard extends StatelessWidget {
  final Compra compra;
  final Function onPress;
  final Function onLongPress;

  const ComprasCard({Key key, this.compra, this.onPress, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: compra.status
              ? Colors.orangeAccent[200]
              : Theme.of(context).accentColor,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 15,
              left: 5,
              child: Container(
                width: 100,
                child: Text(
                  DateFormat("dd-MM-yyyy").format(compra.dateTime),
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 5,
              child: Container(
                width: 100,
                child: Text(
                  compra.status ? "Compra finalizada" : "Compra aberta",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            Positioned(
              right: -5,
              top: 20,
              child: Transform.rotate(
                angle: pi / 9,
                child: Material(
                  elevation: 10,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://img.favpng.com/12/3/23/shopping-bag-grocery-store-shopping-cart-vegetable-png-favpng-kNe42MbW0qHM0GS32nEzGP0tY.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: onPress,
      onLongPress: onLongPress,
    );
  }
}
