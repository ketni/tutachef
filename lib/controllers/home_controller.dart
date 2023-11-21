import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/views/ingredients/ingrediente_datasource.dart';
import 'package:tutachef_project/views/ingredients/ingrediente_entity.dart';
import 'package:tutachef_project/views/recipe/recipe_datasource.dart';
import 'package:tutachef_project/views/reports/report_datasource.dart';

import '../core/user_datasource.dart';
import '../views/profile/user.dart';
import '../views/recipe/recipe_entity.dart';
part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store, ChangeNotifier {
  final ReceitasDataSource _receitasDataSource = ReceitasDataSource();
  final ReportDataSource _reportDataSource = ReportDataSource();
  final IngredienteDataSource _ingredienteDataSource = IngredienteDataSource();

  UserDataSource userDataSource = UserDataSource();

  @observable
  int indexHome = 0;

  @action
  void selectIndex(value) => indexHome = value;

  @observable
  ObservableMap ingredientMap = ObservableMap<String, dynamic>();

  @observable
  ObservableList<Receita> receitas = ObservableList<Receita>();

  @observable
  ObservableList<Receita> minhasReceitas = ObservableList<Receita>();

  @observable
  Color colorStar = Colors.black;

  @action
  Future<void> loadFavorites(List<String> userFavoritos) async {
    for (var receita in receitas) {
      receita.colorStar = userFavoritos.contains(receita.objectId)
          ? Colors.amber
          : Colors.black;
    }

    // Notifique os ouvintes sobre a mudança na lista de receitas
  }

  @action
  Future<void> fetchReceitasFromApi(List<String> userFavoritos) async {
    try {
      List<Receita> receitasFromApi =
          await ReceitasDataSource().getReceitasFromApi();
      receitas = receitasFromApi.asObservable();

      // Chame o método para carregar os favoritos ao carregar a página

      notifyListeners();
    } catch (error) {
      print('Erro ao buscar receitas da API: $error');
    }
  }

  bool isLoading = false;

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      await userDataSource.logInFromApi(
        email: email,
        password: password,
        context: context, // Passa o contexto aqui
      );

      // O usuário está disponível agora em UserState
      User? loggedInUser = Provider.of<User>(context, listen: false);

      bool loginSuccess = loggedInUser.sessionToken != null;

      isLoading = false;
      notifyListeners();

      return loginSuccess;
    } catch (error) {
      print('Erro no login: $error');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void resetPassword({required String userEmail}) {
    userDataSource.resetPassword(userEmail: userEmail);
  }

  String convertDateFormat(String originalDateString) {
    // Formato de entrada
    final DateFormat inputFormat =
        DateFormat('dd MMM yyy \'at\' HH:mm:ss \'UTC\'');

    // Formato de saída
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');

    // Parse a string de data original
    final DateTime dateTime = inputFormat.parse(originalDateString);

    // Formata a data no novo formato
    final String formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }

  @observable
  Future<Color> colorsStar(
      {required List<String> userFavoritos, required Receita receita}) async {
    return userFavoritos.contains(receita.objectId)
        ? Colors.amber
        : Colors.black;
  }

  @action
  Future<void> adicionarFavoritos(
      {required String userId, required receitaId}) async {
    await userDataSource.addFavorite(userId: userId, receitaId: receitaId);
  }

  @action
  Future<void> removerFavoritos(
      {required String userId, required receitaId}) async {
    await userDataSource.removeFavorite(userId: userId, receitaId: receitaId);
  }

  @action
  Future<void> favoriteReceita({
    required String user,
    required String receitaId,
    required List<String> userFavoritos,
    required BuildContext context,
  }) async {
    await userDataSource.addFavorite(userId: user, receitaId: receitaId);

    // Atualize a lista de favoritos diretamente na instância do usuário
    User userInstance = Provider.of<User>(context, listen: false);
    userInstance.updateFavorites(userFavoritos);

    // Notifique os ouvintes sobre a mudança na instância do usuário
    Provider.of<User>(context, listen: false).notifyListeners();

    // Atualize a cor da estrela diretamente na receita
    Receita receita =
        receitas.firstWhere((receita) => receita.objectId == receitaId);
    receita.colorStar = Colors.amber;

    // Notifique os ouvintes sobre a mudança na lista de receitas
    notifyListeners();
  }

  @action
  void addRecipe(Receita receita, String userId) {
    _receitasDataSource.createReceitaFromApi(receita, userId);
  }

  @action
  void getCurrentUser(
      {required String sessionToken, required BuildContext context}) {
    userDataSource.getCurrentUser(currentUser: sessionToken, context: context);
  }

  @action
  void addIngrediente({required String ingredienteTitle}) {
    _ingredienteDataSource.createIngredientesFromApi(ingredienteTitle);
  }

  @action
  void deleteIngrediente({required String ingredienteTitle}) {
    _ingredienteDataSource.deleteIngredientesFromApi(ingredienteTitle);
  }

  @action
  void updateRecipe(Receita receita, String userId) {
    _receitasDataSource.updateReceitaFromApi(
      receita,
    );
  }

  @action
  void updateIngredienteStatus(
      {required Ingrediente ingrediente, required bool ingredienteStatus}) {
    _ingredienteDataSource.updateIngredienteStatusFromApi(
        ingredienteID: ingrediente.objectId, ingredienteStatus: false);
    _ingredienteDataSource.updateIngredientesFromApi(
        ingredienteTitle: ingrediente.ingrediente,
        ingredienteID: ingrediente.objectId);
  }

  @action
  void deleteRecipe(String receitaId) {
    _receitasDataSource.deleteReceitasFromApi(receitaId);
  }

  @action
  void addReport(
      {required String receitaId,
      required String report,
      required String userEmail}) {
    _reportDataSource.createReportsFromApi(receitaId, report, userEmail);
  }

  @action
  void deleteReport({required String reportId}) {
    _reportDataSource.deleteReportsFromApi(reportId);
  }

  @observable
  ObservableList<String> listSelectedIngredients = ObservableList<String>();

  @action
  void addIngredientsToList(String ingredients) =>
      listSelectedIngredients.add(ingredients);

  @action
  void addIngredientMap({
    required String medida,
    required String ingrediente,
    required String quantidade,
  }) {
    if (ingrediente.isNotEmpty && medida.isNotEmpty && quantidade.isNotEmpty) {
      runInAction(() {
        // Verifica se o ingrediente já existe no mapa
        if (ingredientMap.containsKey(ingrediente)) {
          // Atualiza a quantidade e a medida se o ingrediente já existir
          ingredientMap[ingrediente] = {
            'quantidade': quantidade,
            'unidadeMedida': medida,
          };
        } else {
          // Adiciona um novo ingrediente ao mapa
          ingredientMap[ingrediente] = {
            'quantidade': quantidade,
            'unidadeMedida': medida,
          };
        }
      });
    }
  }

  String formatarDouble(double numero) {
    if (numero % 1 == 0) {
      // Se a parte decimal é zero, exiba apenas a parte inteira
      return numero.toInt().toString();
    } else {
      // Caso contrário, exiba o número formatado normalmente
      return numero.toString();
    }
  }

  List<String> formatIngredientMap() {
    List<String> formattedIngredients = [];

    ingredientMap.forEach((ingrediente, values) {
      String quantidade = values['quantidade'];
      String medida = values['unidadeMedida'];

      String formattedIngredient = '$quantidade $medida de $ingrediente';
      formattedIngredients.add(formattedIngredient);
    });

    return formattedIngredients;
  }

  @observable
  String? imagePath;

  @observable
  File? image;

  @action
  Future getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      final bytes = await image?.readAsBytes();
      String base64Image = base64Encode(bytes!);
      imagePath = base64Image;
    }
  }

  @action
  Future getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      final bytes = await image?.readAsBytes();
      String base64Image = base64Encode(bytes!);
      imagePath = base64Image;
    }
  }

  @observable
  bool isStrictMode = true;

  @action
  void setStrictMode() {
    if (!isStrictMode) {
      isStrictMode = true;

      listSelectedIngredients
          .clear(); // Limpa os ingredientes ao trocar para o modo restrito
    }
  }

  @action
  void setFlexibleMode() {
    if (isStrictMode) {
      listSelectedIngredients.clear();
      isStrictMode = false;
    }
  }

  @action
  Future<void> fetchReceitasFiltradas() async {
    try {
      List<Receita> receitasFiltradas = await ReceitasDataSource()
          .getReceitasFiltradas(
              listSelectedIngredients); // Supondo que você tenha um método para filtrar as receitas
      receitasFiltradas = receitasFiltradas.asObservable();
    } catch (error) {
      // Trate o erro conforme necessário
      print('Erro ao buscar receitas filtradas da API: $error');
    }
  }

  List<String> extrairIngredientes(String ingredientesString) {
    // Remove os colchetes iniciais e finais e divide a string em uma lista
    List<String> partes = ingredientesString
        .substring(1, ingredientesString.length - 1)
        .split(", ");

    // Extrai apenas os nomes dos ingredientes
    List<String> ingredientes = partes.map((parte) {
      return parte.split(" ").sublist(3).join(" ");
    }).toList();

    return ingredientes;
  }

  @observable
  Future<List<Receita>> receitasFiltradasRestrita() async {
    return receitas
        .where((receita) => const ListEquality().equals(
            extrairIngredientes(receita.ingredientes!),
            listSelectedIngredients))
        .toList();
  }

  @observable
  Future<List<Receita>> receitasFiltradasFlexivel() async {
    return receitas
        .where((receita) => listSelectedIngredients.any((selectedIngredient) =>
            receita.ingredientes!.contains(selectedIngredient)))
        .toList();
  }
}
