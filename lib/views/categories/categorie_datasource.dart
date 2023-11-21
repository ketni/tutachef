import 'package:dio/dio.dart';

import '../../core/const/headers_key.dart';
import 'categoria_entity.dart';
import 'categoria_requests.dart';

class CategorieDataSource {
  Future<List<Categorie>> getCategoriasFromApi() async {
    try {
      final response = await Dio().post(CategoriesRequest.getCategorie,
          options: Options(headers: {
            'X-Parse-Application-Id': HeadersKey.appID,
            'X-Parse-REST-API-Key': HeadersKey.restID
          }));

      if (response.statusCode == 200) {
        List<Categorie> categorias = List<Categorie>.from(
          response.data['result']
              .map((categoriaJson) => Categorie.fromJson(categoriaJson)),
        );
        return categorias;
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> createCategoriasFromApi(String categorieTitle) async {
    try {
      final response = await Dio().post(CategoriesRequest.createCategorie,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"categorie": categorieTitle});

      if (response.statusCode == 200) {
        return print(
            'printou ---> Categoria $categorieTitle criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateCategoriasFromApi(
      {required String categorieTitle, required String categorieID}) async {
    try {
      final response = await Dio().post(CategoriesRequest.updateCategorie,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"categorieId": categorieID, "categorie": categorieTitle});

      if (response.statusCode == 200) {
        return print(
            'printou ---> Categoria $categorieTitle alterada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateCategoriaStatusFromApi(
      String categorieID, bool categorieStatus) async {
    try {
      final response = await Dio().post(CategoriesRequest.updateStatusCategorie,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"categorieId": categorieID, "pendente": categorieStatus});

      if (response.statusCode == 200) {
        return print('printou ---> Status da categoria alterado com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> deleteCategoriasFromApi(String categorieID) async {
    try {
      final response = await Dio().post(CategoriesRequest.deleteCategorie,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"categorieId": categorieID});

      if (response.statusCode == 200) {
        return print('printou ---> Deletado com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }
}
