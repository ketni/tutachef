import 'package:flutter/material.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';

import '../../core/widgets/custom_appbar.dart';

class SendReportView extends StatelessWidget {
  SendReportView(
      {super.key,
      required this.title,
      required this.controller,
      required this.receitaId,
      required this.userEmail});
  String title;
  final HomeController controller;
  final String receitaId;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    TextEditingController reportController = TextEditingController();

    return Scaffold(
      appBar: CustomAppBarWidget(controller: controller),
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Denunciar a receita: \n $title',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0),
                child: Text(
                  'Por favor, compartilhe conosco os motivos que o levaram a denunciar esta receita. Sua opinião é importante para melhorarmos a qualidade de nossas receitas e garantir a segurança de nossa comunidade culinária. Obrigado pela sua colaboração!',
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CustomTextField(
                  maxLines: 7,
                  controller: reportController,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                  height: 40,
                  width: 160,
                  child: ElevatedButton(
                      onPressed: () {
                        controller.addReport(
                            report: reportController.text,
                            receitaId: receitaId,
                            userEmail: userEmail);
                        AppCore().successDialog(
                            context, 'Denúncia enviada com sucesso!');
                        reportController.clear();
                      },
                      child: const Text('Enviar')))
            ],
          ),
        ),
      ),
    );
  }
}
