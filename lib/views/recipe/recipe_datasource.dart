import 'package:dio/dio.dart';
import 'package:tutachef_project/views/recipe/receita_requests.dart';
import 'package:tutachef_project/views/recipe/recipe_entity.dart';

import '../../core/const/headers_key.dart';

class ReceitasDataSource {
  Future<List<Receita>> getReceitasFiltradas(List<String> ingredientes) async {
    try {
      // Simulando uma chamada à API ou a um repositório de dados
      List<Receita> todasAsReceitas = await getReceitasFromApi();

      // Filtro básico: retorna as receitas que contenham pelo menos um ingrediente selecionado
      List<Receita> receitasFiltradas = todasAsReceitas
          .where((receita) => ingredientes.any(
              (ingrediente) => receita.ingredientes!.contains(ingrediente)))
          .toList();

      return receitasFiltradas;
    } catch (error) {
      // Trate o erro conforme necessário
      print('Erro ao buscar receitas filtradas: $error');
      rethrow; // Propague o erro para quem chamou o método, se necessário
    }
  }

  Future<void> createReceitaFromApi(Receita receita, String userId) async {
    try {
      final response = await Dio().post(ReceitasRequest.createReceita,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {
            "title_receita": receita.titleReceita,
            "sugestao_chef": receita.sugestaoChef,
            "modo_preparo": receita.modoPreparo,
            "userId": userId,
            "ingredientes": receita.ingredientes,
            "categorieId": receita.categorie ?? "w8jJ76lGcM",
            "photo": receita.photo
          });

      if (response.statusCode == 200) {
        return print(
            'printou ---> Categoria ${receita.titleReceita} criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<List<Receita>> getReceitasFromApi() async {
    try {
      final response = await Dio().post(
        ReceitasRequest.getReceita,
        options: Options(headers: {
          'X-Parse-Application-Id': HeadersKey.appID,
          'X-Parse-REST-API-Key': HeadersKey.restID
        }),
      );

      if (response.statusCode == 200) {
        List<Receita> receitas = List<Receita>.from(
          (response.data['result'] as List<dynamic>)
              .map((receitaJson) => Receita.fromMap(receitaJson)),
        );
        return receitas;
      } else {
        throw Exception('Erro ao carregar receitas do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<List<Receita>> getMinhasReceitasFromApi(String userId) async {
    try {
      final response = await Dio().post(
        ReceitasRequest.getUserReceitas,
        options: Options(headers: {
          'X-Parse-Application-Id': HeadersKey.appID,
          'X-Parse-REST-API-Key': HeadersKey.restID
        }),
        data: {"userId": userId},
      );

      if (response.statusCode == 200) {
        List<Receita> receitas = List<Receita>.from(
          (response.data['result'] as List<dynamic>)
              .map((receitaJson) => Receita.fromMap(receitaJson)),
        );
        return receitas;
      } else {
        throw Exception('Erro ao carregar receitas do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateReceitaFromApi(Receita receita) async {
    try {
      final response = await Dio().post(ReceitasRequest.updateReceita,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {
            "receitaId": receita.objectId,
            "title_receita": receita.titleReceita,
            "sugestao_chef": receita.sugestaoChef,
            "modo_preparo": receita.modoPreparo,
            "ingredientes":
                receita.ingredientes == [] ? null : receita.ingredientes,
            "photo": receita.photo
          });

      if (response.statusCode == 200) {
        return print(
            'printou ---> Categoria ${receita.titleReceita} criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> deleteReceitasFromApi(String receitaId) async {
    try {
      final response = await Dio().post(ReceitasRequest.deleteReceita,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"receitaId": receitaId});

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
