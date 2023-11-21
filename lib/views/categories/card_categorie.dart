import 'package:flutter/material.dart';
import 'package:tutachef_project/core/app_core.dart';

import '../../core/widgets/custom_textField.dart';

class CardCategorie extends StatelessWidget {
  CardCategorie({
    super.key,
    required this.categorie,
    required this.type,
    this.ingrediente,
    this.function,
    this.updateFunction,
  });
  String categorie;
  String type;
  bool? ingrediente;
  Function? function;
  Function? updateFunction;

  @override
  Widget build(BuildContext context) {
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
                onTap: () => _alterarCategoria(context, type,
                    action: 'Alterar', ingredient: true),
                child: const Icon(
                  Icons.edit_document,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () => _mostrarDialogDeConfirmacaoExclusao(
                    context, categorie, ingrediente),
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _mostrarDialogDeConfirmacaoExclusao(
    BuildContext context,
    String categorie,
    bool? ingredient,
  ) async {
    ingredient == true ? type = '$type alterado' : type = '$type alterada';

    await showDialog(
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
              onPressed: () async {
                Navigator.of(context).pop();
                await _delayedAction(() {
                  function!();
                  AppCore().successDialog(
                    context,
                    'Exclusão feita com sucesso!',
                  );
                });
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _alterarCategoria(
    BuildContext context,
    String type, {
    String? action,
    bool? ingredient,
  }) async {
    TextEditingController categorie = TextEditingController(text: type);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar'),
          content: CustomTextField(
            controller: categorie,
            hint: 'Informe a $type...',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _delayedAction(() {
                  updateFunction!(categorie.text);
                  AppCore().successDialog(context, '$type com sucesso');
                });
              },
              child: Text(
                action ?? 'Adicionar',
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _delayedAction(Function action) async {
    await Future.delayed(const Duration(seconds: 2));
    action();
  }
}
