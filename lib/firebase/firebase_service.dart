import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controledecompras/utils/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;

String firebaseUserUid;

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _databaseReference = Firestore.instance;

  Future<ApiResponse> loginGoogle() async {
    try {
      // Login com o Google
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Google User: ${googleUser.email}");

      // Credenciais para o Firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login no Firebase
      AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser fUser = result.user;
//      print("Firebase Nome: ${fUser.displayName}");
//      print("Firebase Email: ${fUser.email}");
//      print("Firebase Foto: ${fUser.photoUrl}");

      // Salva no Firestore
      saveUser(fUser);

      // Resposta genérica
      return ApiResponse.ok();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  // salva o usuario na collection de usuarios logados
  void saveUser(FirebaseUser fUser) async {
    print("saveUser");
    if (fUser != null) {
      print("Will save user: ${fUser.uid}");
      firebaseUserUid = fUser.uid;
      DocumentReference refUser =
          _databaseReference.collection("usuarios").document(firebaseUserUid);
      refUser.setData({
        'id': fUser.uid,
        'nome': fUser.displayName,
        'email': fUser.email,
        'login': fUser.email,
        'urlFoto': fUser.photoUrl,
      });
      print("User saved: ${refUser.documentID}");
    }
  }

  void listAllUsers() {
    print("Verifica lista de usuarios do servidor!");
    _databaseReference
        .collection("usuarios")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  static Future<String> uploadFirebaseStorage(File file) async {
    print("Upload to Storage $file");
    String fileName = path.basename(file.path);
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    final StorageTaskSnapshot task = await storageRef.putFile(file).onComplete;
    final String urlFoto = await task.ref.getDownloadURL();
    print("Storage > $urlFoto");
    return urlFoto;
  }

  static void deleteFirebaseStorage(String imageUrl) async {
    print("Delete from Storage $imageUrl");

    // THIS IS A HACK, in order to delete, you need to change URL to your Firebase config
    String filePath = imageUrl
        .replaceAll(new
    RegExp(r'https://firebasestorage.googleapis.com/v0/b/carros-flutter-4ce50.appspot.com/o/'), '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    await storageRef.delete().whenComplete(() => "File deleted");
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
