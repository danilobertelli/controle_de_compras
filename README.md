# Flutter - Controle De Compras (Versão Mobile)

Aplicação responsável por controlar compras do supermercado.
Esta aplicação ainda está em desenvolvimento e tem como objetivo o de se aprofundar nos estudos do Flutter SDK.

Tecnologias utilizadas:
-- Dart  - Linguagem de desenvolvimento.
-- Firebase Google Sign-in - Para fazer controle de usuários.
-- Firebase Cloud Firestore - Banco de dados para armazenar os produtos, compras, etc.
-- Firebase Storage - Armazenamento das imagens dos produtos.

### Visão geral
Ideia de projeto para o controle de compras, para fim de ter um controle financeiro e dos itens a serem comprados.

### Objetivos
1. Facilidade em montar a lista de compras.
2. Controle/Comparação dos valores dos itens, assim como evolução do preço e estimativas de gastos.

### Especificações
Este aplicativo deverá facilitar a ida ao supermercado, exibindo a lista de produtos que precisam ser comprados;

Cada produto deverá ser cadastrado, respeitando quantidade e valor;

A lista de compra deverá exibir o valor estimado para a compra, baseado em compras passadas;

O local de compra também deve ser respeitado e cadastrado corretamente; 

### Screenshots

<img src="/images/login.png" width="300" height="592"> <img src="/images/login_accounts.png" width="300" height="592">
<img src="/images/menu.png" width="300" height="592"> <img src="/images/produtos.png" width="300" height="592">
<img src="/images/produtos_add.png" width="300" height="592"> <img src="/images/compras.png" width="300" height="592">
<img src="/images/tela_compras_1.png" width="300" height="592"> <img src="/images/tela_compras_2.png" width="300" height="592">  <img src="/images/tela_compras_add.png" width="300" height="592"> <img src="/images/tela_compras_carrinho.png" width="300" height="592">
<img src="/images/tela_compras_3.png" width="300" height="592">

## Release notes:
v1.0.0 - Initial version

#### Bibliotecas utilizadas

```yaml
# Load images from Internet
  cached_network_image: ^2.2.0+1

  # Responsible for rendering login buttons
  flutter_auth_buttons: ^0.8.0

  # Google Sign-in
  firebase_auth: ^0.16.0
  google_sign_in: ^4.4.6
  firebase_core: ^0.4.4+3

  # Firestore database
  cloud_firestore: ^0.13.5

  #Firebase Storage
  firebase_storage: ^3.1.5

  # Plugin for imaging pick
  image_picker: ^0.6.6+1

  # For date and time conversion
  intl: ^0.16.1
```

##### Done:
- CRUD de produto.
- CRUD de compras.

##### Missing:
- CRUD de local de compra.
- Gráfico de variação de preços.
- Compras por usuário (atualmente qualquer usuário pode acessar qualquer compra).

#### Agradecimentos:
https://github.com/cybdom/storage_manager 
Ideia para o design da aplicação.

https://pub.dev/packages/multiselect_formfield 
Código para adicionar produtos em uma compra baseado na biblioteca multiselect_formfield.

Dialogos para confirmação de finalizar a compra e confirmar quantidade e preço baseados em https://medium.com/@excogitatr/custom-dialog-in-flutter-d00e0441f1d5

# Flutter - Controle De Compras (Versão WEB)
--- TODO()
