import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/views/reports/report_datasource.dart';
import 'package:tutachef_project/views/reports/report_entity.dart';

import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';
import '../profile/user.dart';
import 'card_report.dart';

class ReportsView extends StatelessWidget {
  ReportsView({Key? key, required this.controller}) : super(key: key);
  final HomeController controller;
  final ReportDataSource _reportDataSource = ReportDataSource();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      appBar: CustomAppBarWidget(controller: controller),
      endDrawer: CustomDrawer(controller: controller),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back, color: Colors.orange[700]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      body: SingleChildScrollView(
        child: FutureBuilder<List<Report>>(
          future: _reportDataSource.getReportsFromApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Enquanto os dados estão sendo carregados
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Se ocorrer um erro durante o carregamento dos dados
              return const Center(child: Text('Erro ao carregar os dados.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Se não houver dados ou se a lista de relatórios estiver vazia
              return const Center(child: Text('Nenhuma denúncia encontrada.'));
            } else {
              // Se os dados foram carregados com sucesso
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Denúncias Recebidas',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // Aqui você deve usar o snapshot.data[index] para obter o relatório específico
                        Report report = snapshot.data![index];
                        return CardReport(
                          report: report,
                          receitaTitle: controller.receitas
                              .firstWhere((element) =>
                                  element.objectId == report.receitaId)
                              .titleReceita!,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
