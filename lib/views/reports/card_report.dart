import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/views/pages_view.dart';
import 'package:tutachef_project/views/reports/report_entity.dart';

import '../../controllers/home_controller.dart';

class CardReport extends StatelessWidget {
  CardReport({super.key, required this.report, required this.receitaTitle});
  Report report;
  String receitaTitle;

  @override
  Widget build(BuildContext context) {
    DateTime data = DateTime.parse(report.createdAt);

    String dataFormatada = DateFormat("dd MMM yyyy").format(data);
    return GestureDetector(
      onTap: () {
        _showOptionsDialog(context,
            receitatitle: report.receitaId, report: report);
      },
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Receita:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(receitaTitle),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Usuário:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(report.emailUser),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(dataFormatada),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.announcement_rounded,
                  color: Colors.red,
                  size: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context,
      {required String receitatitle, required Report report}) {
    var controller = Provider.of<HomeController>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(report.receitaId),
          content: Text(report.report),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed: () {
                  controller.deleteRecipe(report.receitaId);
                  controller.deleteReport(reportId: report.objectId);
                  Navigator.of(context).pop();
                  AppCore().successDialog(
                      context, 'Validação realizada com sucesso!');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PagesView(controller: controller)));
                },
                child: const Text(
                  'Validar',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteReport(reportId: report.objectId);
                  Navigator.of(context).pop();
                  AppCore()
                      .successDialog(context, 'Denúncia recusada com sucesso!');
                },
                child: const Text(
                  'Recusar',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ]),
          ],
        );
      },
    );
  }
}
