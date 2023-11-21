import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/views/recipe/recipe_entity.dart';
import 'package:tutachef_project/views/recipe/show_recipe.dart';

import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';
import '../profile/user.dart';
import 'card_manage_recipe.dart';

class ManageRecipes extends StatefulWidget {
  ManageRecipes({Key? key, required this.controller}) : super(key: key);
  HomeController controller;

  @override
  _ManageRecipesState createState() => _ManageRecipesState();
}

class _ManageRecipesState extends State<ManageRecipes> {
  String filter = "";
  List<Receita> receitas = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    List<Receita> filteredRecipes = widget.controller.receitas
        .where((receita) => receita.user!.contains(user.fullname!))
        .toList();

    return Scaffold(
      appBar: CustomAppBarWidget(controller: widget.controller),
      endDrawer: CustomDrawer(
        controller: widget.controller,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Ação do botão
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back, color: Colors.orange[700]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Gerenciar Receitas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final receita = filteredRecipes[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShowRecipe(
                        title: receita.titleReceita!,
                        ingredientes: [receita.ingredientes!],
                        modoPreparo: receita.modoPreparo!,
                        sugestaoChef: receita.sugestaoChef!,
                        src: receita.photo!,
                        controller: widget.controller,
                        receitaId: receita.objectId!,
                      ),
                    ),
                  ),
                  child: CardManageRecipe(
                    tituloReceita: receita.titleReceita!,
                    ingredientes: [receita.ingredientes!],
                    chef: receita.user!,
                    sugestaoChef: receita.sugestaoChef!.toString(),
                    colorStar: Colors.black,
                    controller: widget.controller,
                    receita: receita!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
