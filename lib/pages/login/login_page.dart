import 'package:controledecompras/firebase/firebase_service.dart';
import 'package:controledecompras/pages/home/home_page.dart';
import 'package:controledecompras/utils/api_response.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle de Compras"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _body(),
      ),
    );
  }

  _body() {
    return ListView(
      children: <Widget>[
        Image.asset(
          "assets/images/login_grocery.jpg",
          height: 200,
        ),
        SizedBox(height: 10),
        Text(
          "Este aplicativo irá facilitar a ida ao supermercado, exibindo a lista de produtos que precisam ser comprados com os valores estimados baseados em seu histórico de consumo.",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 20),
        Container(
          height: 46,
          child: GoogleSignInButton(
            onPressed: _onClickGoogle,
            splashColor: Theme.of(context).accentColor,
            textStyle: Theme.of(context).textTheme.button,
            text: "Entrar com Google",
          ),
        ),
      ],
    );
  }

  void _onClickGoogle() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();

    if (response.ok) {
      push(context, HomePage(), replace: true);
    } else {
      print("_onClickGoogle: Auth error");
    }
  }
}
