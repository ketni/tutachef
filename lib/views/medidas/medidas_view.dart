import 'package:flutter/material.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/views/medidas/card_medida.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../../core/widgets/custom_textField.dart';
import 'medida_entity.dart';
import 'medidas_datasource.dart';

class MedidasView extends StatefulWidget {
  const MedidasView({Key? key, required this.controller}) : super(key: key);
  final HomeController controller;

  @override
  State<MedidasView> createState() => _MedidasViewState();
}

class _MedidasViewState extends State<MedidasView> {
  final MedidaDataSource _medidaDataSource = MedidaDataSource();

  Future<List<Medida>>? _loadData() async {
    return _medidaDataSource.getMedidasFromApi();
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
              'Cadastrar Medidas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Medidas cadastradas',
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadData();
                  setState(() {});
                },
                child: FutureBuilder<List<Medida>>(
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
                          'Erro ao carregar categorias: ${snapshot.error}');
                    } else {
                      List<Medida> medidas = snapshot.data ?? [];

                      // Ordenar a lista por ordem alfabética
                      medidas.sort((a, b) => a.medida.compareTo(b.medida));

                      return ListView.builder(
                        itemCount: medidas.length,
                        itemBuilder: (context, index) {
                          return CardMedidas(
                            medida: medidas[index].medida,
                            type: medidas[index].medida,
                            function: () async {
                              await _medidaDataSource.deleteMedidasFromApi(
                                  medidas[index].objectId);
                              setState(() {});
                            },
                            updateFunction: (medidaText) async {
                              await _medidaDataSource.updateMedidasFromApi(
                                  medidaID: medidas[index].objectId,
                                  medidaTitle: medidaText);

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
                textButton: 'Cadastrar Medida',
                function: () {
                  _cadastrarMedida(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _cadastrarMedida(BuildContext context) {
    TextEditingController medidaTitle = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cadastrar Medida'),
          content: CustomTextField(
            controller: medidaTitle,
            hint: 'Informe a medida...',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (medidaTitle.text.isNotEmpty ||
                    medidaTitle.text.length < 3) {
                  _medidaDataSource.createMedidasFromApi(medidaTitle.text);
                  AppCore()
                      .successDialog(context, 'Medida cadastrada com sucesso');
                  setState(() {});
                } else {
                  // Exibe um pop-up de erro se o campo estiver vazio
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Erro'),
                        content: const Text(
                            'O campo de medida não pode estar vazio.'),
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
