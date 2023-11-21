import 'package:flutter/material.dart';
import 'package:tutachef_project/views/ingredients/widgets/card_ingredients_indicados.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/widgets/custom_textField.dart';
import 'ingrediente_datasource.dart';
import 'ingrediente_entity.dart';

class IngredientsIndicadosView extends StatefulWidget {
  const IngredientsIndicadosView({Key? key, required this.controller})
      : super(key: key);
  final HomeController controller;

  @override
  State<IngredientsIndicadosView> createState() =>
      _IngredientsIndicadosViewState();
}

class _IngredientsIndicadosViewState extends State<IngredientsIndicadosView> {
  final IngredienteDataSource ingredienteDataSource = IngredienteDataSource();

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Ingredientes Indicados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Ingredientes indicados',
                  style: TextStyle(color: Colors.grey),
                ),
                CustomTextField(
                  hint: 'Pesquisar...',
                ),
                FutureBuilder<List<Ingrediente>>(
                  future: ingredienteDataSource.getIngredientesFromApi(),
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
                        shrinkWrap: true,
                        itemCount: ingredientes.length,
                        itemBuilder: (context, index) {
                          Ingrediente ingrediente = ingredientes[index];

                          // Verifica se o atributo 'pendente' é true antes de exibir o ingrediente
                          if (ingrediente.pendente) {
                            return CardIngredienteIndicado(
                              ingredienteIndicado: ingrediente,
                              categorie: ingrediente.ingrediente,
                              type: ingrediente.ingrediente,
                            );
                          } else {
                            // Se 'pendente' for false, retorna um widget vazio (ou null) para não exibir o ingrediente
                            return Container(); // ou return null;
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
