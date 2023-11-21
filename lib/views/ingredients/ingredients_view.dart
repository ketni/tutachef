import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_appbar.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';
import 'package:tutachef_project/views/ingredients/widgets/card_add_ingredients.dart';

import '../../core/widgets/custom_drawer.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView({super.key, required this.controller});
  final HomeController controller;

  @override
  State<IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<HomeController>(context, listen: false);

    void _showAlertDialog(BuildContext context) {
      TextEditingController ingredienteText = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Indicar Ingrediente',
              textAlign: TextAlign.center,
            ),
            content: CustomTextField(
              controller: ingredienteText,
              hint: 'Digite aqui seu ingrediente',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange[600])),
                  onPressed: () {
                    Navigator.pop(context);
                    controller.addIngrediente(
                        ingredienteTitle: ingredienteText.text);
                    AppCore().successDialog(
                        context, 'Ingrediente indicado com sucesso');
                  },
                  child: const Text(
                    'Indicar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    double wi = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: wi,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Observer(
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Adicionar Ingredientes',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Adicione abaixo os ingredientes da sua receita com quantidade e unidade de medida. Caso não encontre o ingrediente, pode sugerir pra nós!',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CardAddIngredients(
                      controller: widget.controller,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Ingredientes Adicionados',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Ingredientes Adicionados',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Ingrediente')),
                              DataColumn(label: Text('Quantidade')),
                              DataColumn(label: Text('Medida')),
                            ],
                            rows: List<DataRow>.generate(
                              widget.controller.ingredientMap.length,
                              (index) {
                                var entry = widget
                                    .controller.ingredientMap.entries
                                    .elementAt(index);
                                return DataRow(
                                  onLongPress: () {
                                    widget.controller.ingredientMap
                                        .remove(entry.key);
                                  },
                                  cells: [
                                    DataCell(Text(entry.key)),
                                    DataCell(Text(
                                        entry.value['quantidade'].toString())),
                                    DataCell(
                                        Text(entry.value['unidadeMedida'])),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const Text(
                          'Para remover, pressione e segure até que ele desapareça da lista',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Não encontrou o ingrediente? '),
                        TextButton(
                          onPressed: () {
                            _showAlertDialog(context);
                          },
                          child: const Text(
                            'Clique aqui para adicionar',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
