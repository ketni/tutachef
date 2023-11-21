import 'package:flutter/material.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/custom_drawer.dart';

class SuggestionView extends StatelessWidget {
  const SuggestionView({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    TextEditingController suggestionController = TextEditingController();
    return Scaffold(
      appBar: CustomAppBarWidget(
        controller: controller,
      ),
      endDrawer: CustomDrawer(
        controller: controller,
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Envie sua sugestão',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Sua opinião é muito importante\n para a melhoria continua do nosso app',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Descreva sua sugestão abaixo!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CustomTextField(
                  controller: suggestionController,
                  maxLines: 7,
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
                        suggestionController.clear();
                        _suggestionSuccess(context);
                      },
                      child: const Text('Enviar')))
            ],
          ),
        ),
      ),
    );
  }

  void _suggestionSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Sugestão enviada com sucesso.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
