import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/core/const/api_requests.dart';

import '../views/profile/user.dart';
import 'const/headers_key.dart';

class UserDataSource {
  Future<void> signUpFromApi(User user) async {
    try {
      final response = await Dio().post(ApiRequests.signUp,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID
            },
          ),
          data: {
            "email": user.email,
            "phone": user.phone,
            "fullname": user.fullname,
            "password": user.password,
            "type": "hobbychef"
          });

      if (response.statusCode == 200) {
        return print('printou ---> criada com sucesso');
      } else {
        throw Exception('Erro ao carregar categorias do servidor');
      }
    } catch (error) {
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> addFavorite(
      {required String userId, required String receitaId}) async {
    try {
      final response = await Dio().post(ApiRequests.addFavorite,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID,
            },
          ),
          data: {"userId": userId, "receitaId": receitaId});
      if (response.statusCode == 200) {
        return print('printou ---> Favoritos adicionado com sucesso');
      }
    } catch (error) {
      print('Erro ao conectar ao servidor: $error');
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> resetPassword({required String userEmail}) async {
    try {
      final response = await Dio().post(ApiRequests.resetPassword,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID,
            },
          ),
          data: {"email": userEmail});
      if (response.statusCode == 200) {
        return print('printou ---> Favoritos adicionado com sucesso');
      }
    } catch (error) {
      print('Erro ao conectar ao servidor: $error');
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> getCurrentUser(
      {required String currentUser, required BuildContext context}) async {
    try {
      final response = await Dio().post(
        ApiRequests.getCurrentUser,
        options: Options(
          headers: {
            'X-Parse-Application-Id': HeadersKey.appID,
            'X-Parse-REST-API-Key': HeadersKey.restID,
            'X-Parse-Session-Token': currentUser
          },
        ),
      );
      if (response.data != null) {
        User user = User.fromJson(response.data);
        if (user != null) {
          Provider.of<User>(context, listen: false).setUser(user);
        } else {
          print('Erro ao converter JSON para User');
          throw Exception('Erro ao converter JSON para User');
        }
      } else {
        print('Resposta da API está vazia');
        throw Exception('Resposta da API está vazia');
      }
    } catch (error) {
      print('Erro ao conectar ao servidor: $error');
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> removeFavorite(
      {required String userId, required String receitaId}) async {
    try {
      final response = await Dio().post(ApiRequests.removeFavorite,
          options: Options(
            headers: {
              'X-Parse-Application-Id': HeadersKey.appID,
              'X-Parse-REST-API-Key': HeadersKey.restID,
            },
          ),
          data: {"userId": userId, "receitaId": receitaId});
    } catch (error) {
      print('Erro ao conectar ao servidor: $error');
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }

  Future<void> logInFromApi(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final response = await Dio().post(
        ApiRequests.logIn,
        options: Options(
          headers: {
            'X-Parse-Application-Id': HeadersKey.appID,
            'X-Parse-REST-API-Key': HeadersKey.restID,
          },
        ),
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        print('Login com sucesso');

        if (response.data != null) {
          User user = User.fromJson(response.data);
          if (user != null) {
            Provider.of<User>(context, listen: false).setUser(user);
          } else {
            print('Erro ao converter JSON para User');
            throw Exception('Erro ao converter JSON para User');
          }
        } else {
          print('Resposta da API está vazia');
          throw Exception('Resposta da API está vazia');
        }
      } else {
        print('Erro ao fazer login: ${response.statusCode}');
        throw Exception('Erro ao fazer login: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao conectar ao servidor: $error');
      throw Exception('Erro ao conectar ao servidor: $error');
    }
  }
}
