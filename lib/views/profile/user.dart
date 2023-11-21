import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String? email;
  String? phone;
  String? fullname;
  String? password;
  String? type;
  String? sessionToken;
  List<String>? favoritos;
  String? userId;

  User(
      {this.email,
      this.phone,
      this.fullname,
      this.password,
      this.type,
      this.sessionToken,
      this.favoritos,
      this.userId});

  factory User.fromJson(Map<String, dynamic> json) {
    final result = json['result']; // Acesse a camada 'result' no JSON

    List<String>? favoritosList = [];
    if (result['favoritos'] != null) {
      // Verifique se 'favoritos' não é nulo
      if (result['favoritos'] is List) {
        // Verifique se 'favoritos' é uma lista
        favoritosList = (result['favoritos'] as List<dynamic>)
            .map((dynamic item) => item.toString())
            .toList();
      } else {
        // Se 'favoritos' não for uma lista, adicione o valor diretamente à lista
        favoritosList.add(result['favoritos'].toString());
      }
    }

    return User(
      email: result['email'] ?? '',
      phone: result['phone'] ?? '',
      fullname: result['fullname'] ?? '',
      password: '', // Certifique-se de tratar a senha adequadamente.
      type: result['type'] ?? '',
      sessionToken: result['sessionToken'] ?? '',
      favoritos: favoritosList,
      userId: result['userId'],
    );
  }

  void setSessionToken(String? token) {
    sessionToken = token;
    notifyListeners();
  }

  void setUser(User newUser) {
    email = newUser.email;
    phone = newUser.phone;
    fullname = newUser.fullname;
    sessionToken = newUser.sessionToken;
    type = newUser.type;
    favoritos = newUser.favoritos;
    userId = newUser.userId;

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'fullname': fullname,
      'password': password,
      'type': type,
      'sessionToken': sessionToken,
      'favoritos': favoritos,
      'userId': userId
    };
  }

  void updateFavorites(List<String> newFavorites) {
    favoritos = newFavorites;
    notifyListeners(); // Notifique os ouvintes sobre a mudança na lista de favoritos
  }
}
