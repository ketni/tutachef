import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';
import 'package:tutachef_project/views/categories/categorie_datasource.dart';
import 'package:tutachef_project/views/ingredients/ingredients_view.dart';
import 'package:tutachef_project/views/pages_view.dart';
import 'package:tutachef_project/views/recipe/recipe_datasource.dart';
import 'package:tutachef_project/views/recipe/recipe_entity.dart';

import '../../controllers/home_controller.dart';
import '../categories/categoria_entity.dart';
import '../profile/user.dart';

class UpdateRecipeView extends StatefulWidget {
  const UpdateRecipeView({super.key, this.user, required this.receita});
  final User? user;
  final Receita receita;

  @override
  State<UpdateRecipeView> createState() => _UpdateRecipeViewState();
}

class _UpdateRecipeViewState extends State<UpdateRecipeView> {
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
                    Observer(
                      builder: (_) {
                        return Stack(
                          children: [
                            Hero(
                              tag: 'recipe_image',
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow[200],
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
                    CustomButton(
                      textButton: 'Alterar',
                      function: () {
                        // Criar uma instância de Receita com os dados fornecidos
                        Receita novaReceita = Receita(
                          objectId: widget.receita.objectId,
                          categorie: widget.receita.categorie,
                          titleReceita: titulo.text,
                          ingredientes:
                              controller.formatIngredientMap().toString(),
                          user: user.userId,
                          modoPreparo: modopreparo.text,
                          sugestaoChef: sugestao.text,
                          photo: controller.imagePath,
                        );
                        // Adicionar a nova receita à lista usando o HomeController
                        controller.updateRecipe(novaReceita, user.userId!);

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
                        Future.delayed(const Duration(seconds: 3));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PagesView(
                                  controller: controller,
                                )));
                      },
                    )
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
