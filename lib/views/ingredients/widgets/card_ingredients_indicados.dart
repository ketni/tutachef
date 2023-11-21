import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';
import 'package:tutachef_project/views/ingredients/ingrediente_entity.dart';
import 'package:tutachef_project/views/pages_view.dart';

import '../../../controllers/home_controller.dart';

class CardIngredienteIndicado extends StatelessWidget {
  CardIngredienteIndicado(
      {super.key,
      required this.categorie,
      required this.type,
      required this.ingredienteIndicado});
  String categorie;
  String type;
  Ingrediente ingredienteIndicado;

  @override
  Widget build(BuildContext context) {
    void _mostrarDialogDeConfirmacaoExclusao(
        BuildContext context, String categorie) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Excluir $categorie'),
            content: const Text('Tem certeza de que deseja excluir?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o AlertDialog
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AppCore()
                      .successDialog(context, '$type excluido com sucesso!');
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    }

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Card(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categorie,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              GestureDetector(
                onTap: () => _adicionarRejeitarIngredient(
                  ingrediente: ingredienteIndicado,
                  ingredienteTitle: categorie,
                  context,
                  type,
                  action: 'Alterar',
                ),
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adicionarRejeitarIngredient(BuildContext context, String type,
      {String? action,
      required String ingredienteTitle,
      required Ingrediente ingrediente}) {
    var controller = Provider.of<HomeController>(context, listen: false);

    TextEditingController ingredienteIndicado =
        TextEditingController(text: ingredienteTitle);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar $type'),
          content: CustomTextField(
            controller: ingredienteIndicado,
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  AppCore()
                      .successDialog(context, '$type rejeitado com sucesso');
                },
                child: const Text(
                  'Rejeitar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.updateIngredienteStatus(
                      ingrediente: ingrediente, ingredienteStatus: false);
                  AppCore()
                      .successDialog(context, '$type adicionado com sucesso');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PagesView(controller: controller)));
                },
                child: const Text(
                  'Adicionar',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
