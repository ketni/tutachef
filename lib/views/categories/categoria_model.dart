import 'categoria_entity.dart';

class CategoriaListModel {
  final List<Categorie> result;

  CategoriaListModel({required this.result});

  factory CategoriaListModel.fromJson(Map<String, dynamic> json) {
    List<Categorie> categorias = List<Categorie>.from(
      json['result'].map((categoriaJson) => Categorie.fromJson(categoriaJson)),
    );

    return CategoriaListModel(result: categorias);
  }
}
