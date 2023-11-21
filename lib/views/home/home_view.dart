import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/views/favorites/widgets/card_recipe.dart';
import 'package:tutachef_project/views/recipe/show_recipe.dart';
import '../profile/user.dart';
import '../recipe/recipe_entity.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
    required this.controller,
    required this.user,
  }) : super(key: key);

  final HomeController controller;
  final User user;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String filter = "";
  Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadData() async {
    Future.delayed(const Duration(seconds: 3));
    await widget.controller.fetchReceitasFromApi(widget.user.favoritos ?? []);
    widget.controller.loadFavorites(widget.user.favoritos ?? []);
  }

  Future<void> onRefresh() {
    return _loadData().then((_) {
      if (mounted) {
        if (widget.user.sessionToken != null) {
          widget.controller.getCurrentUser(
              sessionToken: widget.user.sessionToken!, context: context);
        }
        setState(() {});
      }
      _refreshCompleter.complete();
      _refreshCompleter = Completer<void>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return onRefresh();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Seja bem-vindo!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 60,
                child: CustomTextField(
                  hint: 'Pesquisar...',
                  function: (text) {
                    setState(() {
                      filter = text;
                    });
                  },
                ),
              ),
              const Icon(
                Icons.search,
                size: 30,
                color: Colors.orange,
              )
            ],
          ),
          const Text(
            'Últimas Receitas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Use FutureBuilder para aguardar a conclusão do carregamento de dados
          FutureBuilder(
            future: _loadData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Pressione para recarregar');
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    List<Receita> filteredRecipes = widget.controller.receitas
                        .where((receita) => receita.titleReceita!
                            .toLowerCase()
                            .contains(filter.toLowerCase()))
                        .toList();

                    return Expanded(
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
                              sugestaoChef: receita.sugestaoChef!.toString(),
                              colorStar: widget.user.favoritos != null
                                  ? widget.user.favoritos!
                                          .contains(receita.objectId)
                                      ? Colors.amber
                                      : Colors.black
                                  : Colors.black,
                              function: () {
                                widget.user.favoritos != null
                                    ? {
                                        !widget.user.favoritos!
                                                .contains(receita.objectId)
                                            ? {
                                                widget.controller
                                                    .adicionarFavoritos(
                                                  userId: widget.user.userId!,
                                                  receitaId: receita.objectId,
                                                ),
                                                onRefresh(),
                                                onRefresh()
                                              }
                                            : widget.controller
                                                .removerFavoritos(
                                                userId: widget.user.userId!,
                                                receitaId: receita.objectId,
                                              ),
                                        onRefresh(),
                                        onRefresh()
                                      }
                                    : null;
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}
