// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/views/recipe/recipe_entity.dart';
import 'package:tutachef_project/views/recipe/update_recipe_view.dart';

import '../../core/app_core.dart';

class CardManageRecipe extends StatelessWidget {
  const CardManageRecipe(
      {Key? key,
      required this.colorStar,
      required this.tituloReceita,
      required this.ingredientes,
      required this.chef,
      required this.sugestaoChef,
      required this.receita,
      required this.controller})
      : super(key: key);
  final Color? colorStar;
  final String tituloReceita;
  final List<String> ingredientes;
  final String chef;
  final String sugestaoChef;
  final HomeController controller;
  final Receita receita;

  @override
  Widget build(BuildContext context) {
    double widScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: SizedBox(
        height: 120,
        width: widScreen * 0.9,
        child: Card(
          color: Colors.orange[50],
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.orange, width: 1.3)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tituloReceita,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Ingredientes:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              [ingredientes].toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Sugestão do Chef: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            sugestaoChef.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Chef:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(chef),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _alterarCategoria(
                          context, 'Receita', controller,
                          receita: receita, action: 'Alterar Receita'),
                      child: const Icon(
                        Icons.edit_document,
                        size: 30,
                        color: Colors.orange,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _mostrarDialogDeConfirmacaoExclusao(
                          context, 'Receita',
                          receitaId: receita.objectId!),
                      child: const Icon(Icons.delete_forever_outlined,
                          color: Colors.red, size: 30),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogDeConfirmacaoExclusao(
      BuildContext context, String categorie,
      {required String receitaId}) {
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
                controller.deleteRecipe(receitaId);
                AppCore()
                    .successDialog(context, 'Receita excluida com sucesso!');
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _alterarCategoria(
      BuildContext context, String type, HomeController controller,
      {String? action, required Receita receita}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alterar Receita'),
          content: UpdateRecipeView(
            receita: receita,
          ),
        );
      },
    );
  }
}
