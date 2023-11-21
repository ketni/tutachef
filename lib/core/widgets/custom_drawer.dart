import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/views/favorites/favorites_view.dart';
import 'package:tutachef_project/views/login/login_view.dart';
import 'package:tutachef_project/views/profile/profile_view.dart';
import 'package:tutachef_project/views/recipe/my_recipes.dart';
import 'package:tutachef_project/views/search/search_view.dart';
import 'package:tutachef_project/views/suggestion/suggestion_view.dart';

import '../../controllers/home_controller.dart';
import '../../views/categories/categories_view.dart';
import '../../views/ingredients/ingredientes_indicados_view.dart';
import '../../views/ingredients/ingredients_cadastrados_view.dart';
import '../../views/medidas/medidas_view.dart';
import '../../views/profile/user.dart';
import '../../views/recipe/manage_recipes.dart';
import '../../views/reports/reports_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    User user = Provider.of<User>(context);

    return Drawer(
      width: widthScreen * 0.5,
      child: ListView(
        // Wrap your content in a Column
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppCore.defaultOrangeGradient,
            ),
            child: Align(
              alignment: Alignment.centerLeft, // Alinhar o conteúdo à esquerda
              child: Center(
                child: ListView(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: Image.asset(
                          'assets/images/profile.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileView(
                            controller: controller,
                          ),
                        ));
                      },
                      child: const Text(
                        'Meus dados',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: user.type == null,
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.person),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginView(
                        controller: controller,
                      ),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type != null,
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.restaurant_menu),
                  title: const Text('Minhas Receitas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyRecipesView(
                        controller: controller,
                        user: user,
                      ),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type != null,
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.star),
                  title: const Text('Receitas Favoritas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FavoritesView(
                        user: user,
                        controller: controller,
                        viaDrawer: true,
                      ),
                    ));
                  },
                ),
              ),
              ListTile(
                horizontalTitleGap: 0,
                dense: true,
                leading: const Icon(Icons.search),
                title: const Text('Pesquisar Receita'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchView(viaDrawer: true),
                  ));
                },
              ),
              Visibility(
                visible: user.type != null,
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.settings),
                  title: const Text('Gerenciar Receita'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageRecipes(
                        controller: controller,
                      ),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type == 'admin',
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.food_bank_outlined),
                  title: const Text('Ingredientes Indicados'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => IngredientsIndicadosView(
                        controller: controller,
                      ),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type == 'admin',
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.kitchen),
                  title: const Text('Ingredientes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          IngredientsCadastradosView(controller: controller),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type == 'admin',
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.category),
                  title: const Text('Categorias'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CategoriesView(controller: controller),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type == 'admin',
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.ramen_dining_outlined),
                  title: const Text('Medidas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MedidasView(controller: controller),
                    ));
                  },
                ),
              ),
              Visibility(
                visible: user.type == 'admin',
                child: ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(Icons.warning),
                  title: const Text('Denúncias'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ReportsView(controller: controller)),
                    );
                  },
                ),
              ),
              ListTile(
                horizontalTitleGap: 0,
                dense: true,
                leading: const Icon(Icons.message),
                title: const Text('Sugestão'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SuggestionView(controller: controller),
                  ));
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(controller: controller),
                    ),
                  );
                },
                child: Text(
                  'Sair',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
