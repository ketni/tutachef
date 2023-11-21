import 'package:flutter/material.dart';
import 'package:tutachef_project/views/favorites/widgets/card_recipe.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';
import '../profile/user.dart';
import '../recipe/recipe_entity.dart';
import '../recipe/show_recipe.dart';

class FavoritesView extends StatefulWidget {
  FavoritesView(
      {Key? key,
      required this.controller,
      this.viaDrawer = false,
      required this.user})
      : super(key: key);
  final HomeController controller;
  bool viaDrawer;
  User user;

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadData() async {
    await widget.controller.fetchReceitasFromApi(widget.user.favoritos ?? []);
    widget.controller.loadFavorites(widget.user.favoritos ?? []);
  }

  @override
  Widget build(BuildContext context) {
    List<Receita> filteredRecipes = widget.controller.receitas
        .where((receita) => widget.user.favoritos!.contains(receita.objectId))
        .toList();
    return Scaffold(
      appBar: !widget.viaDrawer
          ? null
          : CustomAppBarWidget(controller: widget.controller),
      endDrawer: !widget.viaDrawer
          ? null
          : CustomDrawer(controller: widget.controller),
      backgroundColor: widget.viaDrawer ? null : Colors.white,
      floatingActionButton: !widget.viaDrawer
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.orange[700]),
            ),
      floatingActionButtonLocation: !widget.viaDrawer
          ? null
          : FloatingActionButtonLocation.miniStartFloat,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Receitas Favoritas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Use FutureBuilder para aguardar a conclusão do carregamento de dados
            FutureBuilder(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // ou um indicador de carregamento
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  // Continue com o restante da UI

                  return filteredRecipes.isEmpty
                      ? const Center(
                          child: Text(
                            'Você ainda não tem receitas favoritas cadastradas!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final receita = filteredRecipes[index];
                              return GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShowRecipe(
                                      controller: widget.controller,
                                      title: receita.titleReceita!,
                                      ingredientes: [receita.ingredientes!],
                                      modoPreparo: receita.modoPreparo!,
                                      sugestaoChef: receita.sugestaoChef!,
                                      src: receita.photo!,
                                      receitaId: receita.objectId!,
                                    ),
                                  ),
                                ),
                                child: CardRecipe(
                                  tituloReceita: receita.titleReceita!,
                                  ingredientes: [receita.ingredientes!],
                                  chef: receita.user ?? 'Glauco',
                                  sugestaoChef:
                                      receita.sugestaoChef!.toString(),
                                  colorStar: receita.colorStar,
                                  function: () {
                                    widget.controller.favoriteReceita(
                                      context: context,
                                      user: widget.user.userId!,
                                      receitaId: receita.objectId!,
                                      userFavoritos:
                                          widget.user.favoritos ?? [],
                                    );

                                    widget.controller.loadFavorites(
                                        widget.user.favoritos ?? []);
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
