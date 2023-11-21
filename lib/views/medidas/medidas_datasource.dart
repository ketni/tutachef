import 'package:dio/dio.dart';

import '../../core/const/headers_key.dart';
import 'medida_entity.dart';
import 'medidas_requrest.dart';

class MedidaDataSource {
  Future<List<Medida>> getMedidasFromApi() async {
    try {
      final response = await Dio().post(MedidasRequest.getMedidas,
          options: Options(headers: {
            'X-Parse-Application-Id': HeadersKey.appID,
            'X-Parse-REST-API-Key': HeadersKey.restID
          }));

      if (response.statusCode == 200) {
        List<Medida> medidas = List<Medida>.from(
          response.data['result']
              .map((medidasJson) => Medida.fromJson(medidasJson)),
        );
        return medidas;
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> createMedidasFromApi(String medidaTitle) async {
    try {
      final response = await Dio().post(MedidasRequest.createMedida,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"medida": medidaTitle});

      if (response.statusCode == 200) {
        return print('printou ---> Medida $medidaTitle criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateMedidasFromApi(
      {required String medidaTitle, required String medidaID}) async {
    try {
      final response = await Dio().post(MedidasRequest.updateMedida,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"medidaId": medidaID, "medida": medidaTitle});

      if (response.statusCode == 200) {
        return print('printou ---> Medida $medidaTitle alterada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> updateMedidaStatusFromApi(
      String medidaID, bool medidaStatus) async {
    try {
      final response = await Dio().post(MedidasRequest.updateStatusMedida,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"medidaId": medidaID, "pendente": medidaStatus});

      if (response.statusCode == 200) {
        return print('printou ---> Status da categoria alterado com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> deleteMedidasFromApi(String medidaID) async {
    try {
      final response = await Dio().post(MedidasRequest.deleteMedida,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"medidaId": medidaID});

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
