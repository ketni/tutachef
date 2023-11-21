import 'package:flutter/material.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/views/categories/card_categorie.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/widgets/custom_textField.dart';
import 'ingrediente_datasource.dart';
import 'ingrediente_entity.dart';

class IngredientsCadastradosView extends StatefulWidget {
  const IngredientsCadastradosView({Key? key, required this.controller})
      : super(key: key);
  final HomeController controller;

  @override
  State<IngredientsCadastradosView> createState() =>
      _IngredientsCadastradosViewState();
}

class _IngredientsCadastradosViewState
    extends State<IngredientsCadastradosView> {
  final IngredienteDataSource _ingredienteDataSource = IngredienteDataSource();

  Future<List<Ingrediente>>? _loadData() async {
    return _ingredienteDataSource.getIngredientesFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(controller: widget.controller),
      endDrawer: CustomDrawer(
        controller: widget.controller,
      ),
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
              'Cadastrar Ingrediente',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingredientes cadastrados',
              style: TextStyle(color: Colors.grey),
            ),
            CustomTextField(
              hint: 'Pesquisar...',
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadData();
                  setState(() {});
                },
                child: FutureBuilder<List<Ingrediente>>(
                  future: _loadData(),
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
                          'Erro ao carregar ingredientes: ${snapshot.error}');
                    } else {
                      List<Ingrediente> ingredientes = snapshot.data ?? [];

                      // Ordenar a lista por ordem alfabética
                      ingredientes.sort(
                          (a, b) => a.ingrediente.compareTo(b.ingrediente));

                      return ListView.builder(
                        itemCount: ingredientes.length,
                        itemBuilder: (context, index) {
                          return CardCategorie(
                            categorie: ingredientes[index].ingrediente,
                            type: ingredientes[index].ingrediente,
                            function: () async {
                              await _ingredienteDataSource
                                  .deleteIngredientesFromApi(
                                      ingredientes[index].objectId);
                              setState(() {});
                            },
                            updateFunction: (categorieText) async {
                              await _ingredienteDataSource
                                  .updateIngredientesFromApi(
                                      ingredienteID:
                                          ingredientes[index].objectId,
                                      ingredienteTitle: categorieText);

                              setState(() {});
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
                textButton: 'Cadastrar Ingrediente',
                function: () {
                  _showOptionsDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    TextEditingController ingredienteText = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cadastrar Ingrediente'),
          content: CustomTextField(
            controller: ingredienteText,
            hint: 'Informe o ingrediente...',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _ingredienteDataSource
                    .createIngredientesFromApi(ingredienteText.text);
                AppCore().successDialog(
                  context,
                  'Ingrediente adicionado com sucesso!',
                );
              },
              child: const Text(
                'Adicionar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
