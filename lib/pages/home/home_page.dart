import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/pages/compra/compra.dart';
import 'package:controledecompras/pages/compra/compra_data_repository.dart';
import 'package:controledecompras/pages/compra/compras_grid_view.dart';
import 'package:controledecompras/pages/compra/compras_page.dart';
import 'package:controledecompras/pages/drawer.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CompraDataRepository repository = CompraDataRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        drawer: MenuDrawer(),
        body: _body(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.local_grocery_store),
          onPressed: _onClickAdicionarCompra,
        ));
  }

  _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, top: 40, right: 16),
          child: Column(
            children: <Widget>[
              _header(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Compras",
                    style: Theme.of(context).textTheme.headline5.apply(
                          color: Colors.white,
                          fontWeightDelta: 1,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.0),
                topRight: Radius.circular(35.0),
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: repository.getStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Nenhuma compra encontrada"),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _buildComprasList(context, snapshot.data.documents);
              },
            ),
          ),
        )
      ],
    );
  }

  _header() {
    // Get current user
    Future<FirebaseUser> future = FirebaseAuth.instance.currentUser();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        FutureBuilder<FirebaseUser>(
          future: future,
          builder: (context, snapshot) {
            FirebaseUser user = snapshot.data;
            if (user != null) {
              return ClipOval(
                child: CachedNetworkImage(
                  height: 45,
                  imageUrl: user.photoUrl,
                ),
              );
            } else {
              return FlutterLogo();
            }
          },
        ),
      ],
    );
  }

  void _onClickAdicionarCompra() {
    push(context, ComprasPage());
  }

  _buildComprasList(BuildContext context, List<DocumentSnapshot> documents) {
    List<Compra> compras = documents.map((DocumentSnapshot document) {
      return Compra.fromSnapshot(document);
    }).toList();

    if (compras != null && compras.isEmpty) {
      return Center(
        child: Text("Nenhuma compra cadastrada."),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
      ),
      child: ComprasGridView(
        compras,
        callback: _onCallback,
      ),
    );
  }

  _onCallback(int action, Compra c) {
    if (action == 0) {
      c.dateTime = DateTime.now();
      c.status = true;
      repository.updateCompra(c);
    } else {
      repository.deleteCompra(c);
    }
  }
}
