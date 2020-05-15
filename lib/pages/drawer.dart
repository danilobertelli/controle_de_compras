import 'package:controledecompras/firebase/firebase_service.dart';
import 'package:controledecompras/pages/login/login_page.dart';
import 'package:controledecompras/pages/produtos/produtos_page.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current user
    Future<FirebaseUser> future = FirebaseAuth.instance.currentUser();

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder<FirebaseUser>(
              future: future,
              builder: (context, snapshot) {
                FirebaseUser user = snapshot.data;
                return user != null ? _header(user) : Container();
              },
            ),
            ListTile(
              leading: Icon(Icons.local_grocery_store),
              title: Text("Produtos"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onClickLProdutos(context),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onClickLogout(context),
            )
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader _header(FirebaseUser user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.displayName ?? ""),
      accountEmail: Text(user.email),
      currentAccountPicture: user.photoUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            )
          : FlutterLogo(),
    );
  }

  _onClickLogout(BuildContext context) {
    FirebaseService().logout();
    Navigator.pop(context);
    push(context, LoginPage(), replace: true);
  }

  _onClickLProdutos(context) {
    Navigator.pop(context);
    push(context, ProdutosPage());
  }
}
