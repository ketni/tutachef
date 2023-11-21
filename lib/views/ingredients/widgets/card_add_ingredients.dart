import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/views/medidas/medida_entity.dart';
import 'package:tutachef_project/views/medidas/medidas_datasource.dart';

import '../../../core/app_core.dart';
import '../ingrediente_datasource.dart';
import '../ingrediente_entity.dart';

class CardAddIngredients extends StatefulWidget {
  const CardAddIngredients({Key? key, required this.controller})
      : super(key: key);
  final HomeController controller;

  @override
  State<CardAddIngredients> createState() => _CardAddIngredientsState();
}

class _CardAddIngredientsState extends State<CardAddIngredients> {
  final IngredienteDataSource _ingredienteDataSource = IngredienteDataSource();
  final MedidaDataSource _medidaDataSource = MedidaDataSource();

  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _medidasController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  String? selectedMedida;
  String? selectedIngredient;

  late Future<List<Ingrediente>> _ingredientsFuture;
  late Future<List<Medida>> _medidasFuture;

  late List<String> suggestionsIngredients;

  @override
  void initState() {
    super.initState();
    _ingredientsFuture = _ingredienteDataSource.getIngredientesFromApi();
    _medidasFuture = _medidaDataSource.getMedidasFromApi();
  }

  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SizedBox(
        height: 320,
        width: wi,
        child: Card(
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // FutureBuilder para carregar sugestões de ingredientes
                  FutureBuilder<List<Ingrediente>>(
                    future: _ingredientsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhum ingrediente encontrado.');
                      } else {
                        suggestionsIngredients = snapshot.data!
                            .map((ingrediente) => ingrediente.ingrediente)
                            .toList();
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 60,
                          width: 240,
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _ingredientsController,
                              decoration: const InputDecoration(
                                label: Text('Selecione um ingrediente'),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return suggestionsIngredients.where(
                                  (ingredient) => ingredient
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              _ingredientsController.text = suggestion;
                            },
                          ),
                        );
                      }
                    },
                  ),
                  // FutureBuilder para carregar sugestões de medidas
                  FutureBuilder<List<Medida>>(
                    future: _medidasFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Erro ao carregar medidas');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhuma medida disponível');
                      } else {
                        List<Medida> suggestionsMedidas = snapshot.data!;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(
                              width: 1,
                              color: Colors.black,
                            )),
                          ),
                          height: 60,
                          width: 240,
                          child: Center(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              isDense: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              underline: const DropdownButtonHideUnderline(
                                child: SizedBox(),
                              ),
                              value: selectedMedida,
                              items: suggestionsMedidas
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.medida,
                                      child: Text(e.medida),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMedida = newValue;
                                  _medidasController.text = newValue!;
                                });
                              },
                              hint: const Text('Unidade de Medida'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Quantidade',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        width: wi * 0.25,
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _quantidadeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onEditingComplete: () {
                              _adicionarIngrediente();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _adicionarIngrediente();
                      },
                      child: Container(
                        height: 50,
                        width: 140,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: AppCore.defaultOrangeGradient,
                        ),
                        child: const Center(
                          child: Text(
                            'Adicionar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adicionarIngrediente() {
    String ingrediente = _ingredientsController.text.trim();
    String medida = _medidasController.text.trim();
    String quantidade = _quantidadeController.text.trim();

    widget.controller.addIngredientMap(
      quantidade: quantidade,
      medida: medida,
      ingrediente: ingrediente,
    );

    _ingredientsController.clear();
    _medidasController.clear();
    _quantidadeController.clear();
    selectedMedida = 'Selecione uma medida';
    selectedIngredient = 'Selecione um ingrediente';

    setState(() {});
  }
}
