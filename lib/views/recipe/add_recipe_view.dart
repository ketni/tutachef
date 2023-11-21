import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';
import 'package:tutachef_project/views/categories/categorie_datasource.dart';
import 'package:tutachef_project/views/ingredients/ingredients_view.dart';
import 'package:tutachef_project/views/recipe/recipe_datasource.dart';
import 'package:tutachef_project/views/recipe/recipe_entity.dart';

import '../../controllers/home_controller.dart';
import '../categories/categoria_entity.dart';
import '../profile/user.dart';

class AddRecipeView extends StatefulWidget {
  const AddRecipeView({super.key, this.editRecipe = false, this.user});
  final bool editRecipe;
  final User? user;

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  String? selectedCategory;
  List<String> listaDeCategorias = [];

  ReceitasDataSource receitaDataSource = ReceitasDataSource();
  TextEditingController titulo = TextEditingController();
  TextEditingController modopreparo = TextEditingController();
  TextEditingController sugestao = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCategories();
  }

  Future<void> initCategories() async {
    List<Categorie> categoriesList =
        await CategorieDataSource().getCategoriasFromApi();
    setState(() {
      listaDeCategorias = categoriesList.map((e) => e.categorie).toList();
    });
  }

  void _showImagePickerDialog(HomeController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Escolha uma fonte de imagem"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galeria"),
                onTap: () {
                  Navigator.pop(context);
                  controller.getImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Câmera"),
                onTap: () {
                  Navigator.pop(context);
                  controller.getImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<HomeController>(context);
    User user = Provider.of<User>(context);

    return user.userId != null
        ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !widget.editRecipe
                        ? const Text(
                            'Cadastrar Receita',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          )
                        : const SizedBox(),
                    Observer(
                      builder: (_) {
                        return Stack(
                          children: [
                            Hero(
                              tag: 'recipe_image',
                              child: CircleAvatar(
                                backgroundColor: Colors.orangeAccent[200],
                                maxRadius: 50,
                                child: controller.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          height: 100,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(48)),
                                          child: Image.file(controller.image!,
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.fastfood_outlined,
                                        size: 50,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () => _showImagePickerDialog(controller),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.fromBorderSide(
                              BorderSide(width: 1, color: Colors.orange))),
                      height: 40,
                      width: 300,
                      child: Center(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          underline: const DropdownButtonHideUnderline(
                              child: SizedBox()),
                          value: selectedCategory,
                          items: listaDeCategorias
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          },
                          hint: const Text('Categoria'),
                        ),
                      ),
                    ),
                    CustomTextField(
                      hint: 'Título',
                      controller: titulo,
                    ),
                    SizedBox(
                      width: 400,
                      child: CustomButton(
                          textButton: 'Adicionar Ingrediente',
                          function: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IngredientsView(
                                        controller: controller,
                                      )))),
                    ),
                    CustomTextField(
                      hint: 'Modo de Preparo',
                      controller: modopreparo,
                    ),
                    CustomTextField(
                      hint: 'Sugestão do Chef',
                      controller: sugestao,
                    ),
                    !widget.editRecipe
                        ? CustomButton(
                            textButton: 'Enviar',
                            function: () {
                              if (selectedCategory == null ||
                                  titulo.text.isEmpty ||
                                  modopreparo.text.isEmpty ||
                                  sugestao.text.isEmpty ||
                                  controller.ingredientMap.isEmpty) {
                                AppCore().errorDialog(
                                  context,
                                  'Preencha todos os campos obrigatórios',
                                );
                              } else {
                                // Criar uma instância de Receita com os dados fornecidos
                                Receita novaReceita = Receita(
                                  titleReceita: titulo.text,
                                  ingredientes: controller
                                      .formatIngredientMap()
                                      .toString(),
                                  user: user.userId,
                                  modoPreparo: modopreparo.text,
                                  sugestaoChef: sugestao.text,
                                  photo: controller.imagePath,
                                );
                                // Adicionar a nova receita à lista usando o HomeController
                                controller.addRecipe(novaReceita, user.userId!);

                                controller.ingredientMap.clear();
                                setState(() {
                                  titulo.clear();
                                  modopreparo.clear();
                                  sugestao.clear();
                                  selectedCategory = null;
                                });
                                controller.image = null;

                                // Exibir o diálogo de sucesso
                                AppCore().successDialog(
                                    context, 'Receita cadastrada com sucesso!');
                              }
                            },
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: Text(
              'Realize o login para \n enviar sua receita',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
  }
}
