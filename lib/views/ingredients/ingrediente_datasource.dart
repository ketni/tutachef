import 'package:dio/dio.dart';

import '../../core/const/headers_key.dart';
import 'ingrediente_entity.dart';
import 'ingredientes_request.dart';

class IngredienteDataSource {
  Future<List<Ingrediente>> getIngredientesFromApi() async {
    try {
      final response = await Dio().post(IngredientesRequest.getIngredientes,
          options: Options(headers: {
            'X-Parse-Application-Id': HeadersKey.appID,
            'X-Parse-REST-API-Key': HeadersKey.restID
          }));

      if (response.statusCode == 200) {
        List<Ingrediente> ingredientes = List<Ingrediente>.from(
          response.data['result']
              .map((categoriaJson) => Ingrediente.fromJson(categoriaJson)),
        );
        return ingredientes;
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> createIngredientesFromApi(String ingredienteTitle) async {
    try {
      final response = await Dio().post(IngredientesRequest.createIngrediente,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"ingrediente": ingredienteTitle});

      if (response.statusCode == 200) {
        return print(
            'printou ---> Ingrediente $ingredienteTitle criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateIngredientesFromApi(
      {required String ingredienteTitle, required String ingredienteID}) async {
    try {
      final response = await Dio().post(IngredientesRequest.updateIngrediente,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {
            "ingredienteId": ingredienteID,
            "ingrediente": ingredienteTitle
          });

      if (response.statusCode == 200) {
        return print(
            'printou ---> Ingrediente $ingredienteTitle alterada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateIngredienteStatusFromApi(
      {required String ingredienteID, required bool ingredienteStatus}) async {
    try {
      final response = await Dio().post(
          IngredientesRequest.updateStatusIngrediente,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {
            "ingredienteId": ingredienteID,
            "pendente": ingredienteStatus
          });

      if (response.statusCode == 200) {
        return print('printou ---> Status da categoria alterado com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> deleteIngredientesFromApi(String ingredienteID) async {
    try {
      final response = await Dio().post(IngredientesRequest.deleteIngrediente,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"ingredienteId": ingredienteID});

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
