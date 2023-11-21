import 'package:flutter/material.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/views/categories/card_categorie.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/widgets/custom_textField.dart';
import 'categoria_entity.dart';
import 'categorie_datasource.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key, required this.controller});
  final HomeController controller;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

CategorieDataSource _categorieDataSource = CategorieDataSource();

class _CategoriesViewState extends State<CategoriesView> {
  Future<List<Categorie>>? _loadData() async {
    return _categorieDataSource.getCategoriasFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(controller: widget.controller),
      endDrawer: CustomDrawer(controller: widget.controller),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back, color: Colors.orange[700]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Cadastrar Categorias',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categoria cadastradas',
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadData();
                  setState(() {});
                },
                child: FutureBuilder<List<Categorie>>(
                  future: _categorieDataSource.getCategoriasFromApi(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          children: [
                            const Text('Carregando'),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          'Erro ao carregar categorias: ${snapshot.error}');
                    } else {
                      List<Categorie> categorias = snapshot.data ?? [];

                      categorias
                          .sort((a, b) => a.categorie.compareTo(b.categorie));

                      return ListView.builder(
                        itemCount: categorias.length,
                        itemBuilder: (context, index) {
                          return CardCategorie(
                            categorie: categorias[index].categorie,
                            type: categorias[index].categorie,
                            function: () async {
                              await _categorieDataSource
                                  .deleteCategoriasFromApi(
                                      categorias[index].objectId);
                              // Aguarde antes de atualizar o estado
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                // Atualize o estado após o atraso
                                categorias = List.from(snapshot.data!);
                              });
                            },
                            updateFunction: (categorieText) async {
                              await _categorieDataSource
                                  .updateCategoriasFromApi(
                                      categorieID: categorias[index].objectId,
                                      categorieTitle: categorieText);
                              // Aguarde antes de atualizar o estado
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                // Atualize o estado após o atraso
                                categorias = List.from(snapshot.data!);
                              });
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: CustomButton(
                textButton: 'Cadastrar Categoria',
                function: () {
                  _cadastrarCategoria(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cadastrarCategoria(BuildContext context) {
    TextEditingController categorieTitle = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cadastrar Categoria'),
          content: CustomTextField(
            controller: categorieTitle,
            hint: 'Informe a categoria...',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (categorieTitle.text.isNotEmpty ||
                    categorieTitle.text.length < 3) {
                  _categorieDataSource
                      .createCategoriasFromApi(categorieTitle.text);
                  AppCore().successDialog(
                      context, 'Categoria cadastrada com sucesso');
                  setState(() {});
                } else {
                  // Exibe um pop-up de erro se o campo estiver vazio
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Erro'),
                        content: const Text(
                            'O campo de categoria não pode estar vazio.'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Cadastrar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
