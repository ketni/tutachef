import 'package:flutter/material.dart';

class Receita {
  String? titleReceita;
  String? sugestaoChef;
  String? modoPreparo;
  String? ingredientes;
  String? user;
  String? categorie;
  String? photo;
  String? objectId;
  Color colorStar = Colors.black;

  Receita({
    this.titleReceita,
    this.sugestaoChef,
    this.modoPreparo,
    this.ingredientes,
    this.user,
    this.categorie,
    this.photo,
    this.objectId,
  });

  factory Receita.fromMap(Map<String, dynamic>? json) {
    return Receita(
      titleReceita: json?["title_receita"] ?? "",
      sugestaoChef: json?["sugestao_chef"] ?? "",
      modoPreparo: json?["modo_preparo"] ?? "",
      ingredientes: json?["ingredientes"] as String ?? "",
      user: json?["fullname"] ?? "",
      categorie: (json?["categorie"] as Map<String, dynamic>?)
                  ?.containsKey('objectId') ==
              true
          ? (json?["categorie"]["objectId"]) ?? ""
          : "", // Ajuste conforme necessário
      photo: json?["photo"] ?? "",
      objectId: json?["objectId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "title_receita": titleReceita,
        "sugestao_chef": sugestaoChef,
        "modo_preparo": modoPreparo,
        "ingredientes": ingredientes,
        "user": user,
        "categorie": categorie,
        "photo": photo,
        "objectId": objectId,
      };
}
