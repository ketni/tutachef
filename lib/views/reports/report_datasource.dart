import 'package:dio/dio.dart';
import 'package:tutachef_project/views/reports/report_entity.dart';
import 'package:tutachef_project/views/reports/report_request.dart';

import '../../core/const/headers_key.dart';

class ReportDataSource {
  Future<List<Report>> getReportsFromApi() async {
    try {
      final response = await Dio().post(ReportRequest.getReport,
          options: Options(headers: {
            'X-Parse-Application-Id': HeadersKey.appID,
            'X-Parse-REST-API-Key': HeadersKey.restID
          }));

      if (response.statusCode == 200) {
        print(response.data);
        List<Report> reports = List<Report>.from(
          response.data['result']
              .map((reportJson) => Report.fromJson(reportJson)),
        );
        return reports;
      } else {
        throw Exception('Erro ao carregar denúncias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> createReportsFromApi(
      String receitaId, String reportText, String userEmail) async {
    try {
      final response = await Dio().post(ReportRequest.createReport,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {
            "report": reportText,
            "receitaId": receitaId,
            "user": userEmail
          });

      if (response.statusCode == 200) {
        return print(
            'printou ---> Denúncia da receita $receitaId criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> deleteReportsFromApi(String reportId) async {
    try {
      final response = await Dio().post(ReportRequest.deleteReport,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {"reportId": reportId});

      if (response.statusCode == 200) {
        return print('printou ---> Denúncia $reportId ');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }
}
