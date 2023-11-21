import 'package:flutter/material.dart';
import 'package:tutachef_project/core/app_core.dart';

import '../../core/widgets/custom_textField.dart';

class CardMedidas extends StatelessWidget {
  CardMedidas(
      {super.key,
      required this.medida,
      required this.type,
      this.ingrediente,
      this.function,
      this.updateFunction});
  String medida;
  String type;
  bool? ingrediente;
  Function? function;
  Function? updateFunction;

  @override
  Widget build(BuildContext context) {
    void _mostrarDialogDeConfirmacaoExclusao(
        BuildContext context, String medida, bool? ingredient) {
      bool? ingredient;
      ingredient == true ? type = '$type alterado' : type = '$type alterada';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Excluir $medida'),
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
                  function!();
                  AppCore()
                      .successDialog(context, '$type excluida com sucesso!');
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
                medida,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              GestureDetector(
                onTap: () => _alterarMedida(context, type,
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
                    context, medida, ingrediente),
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

  void _alterarMedida(
    BuildContext context,
    String type, {
    String? action,
    bool? ingredient,
  }) {
    TextEditingController medida = TextEditingController(text: type);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ingredient == true ? type = '$type alterado' : type = '$type alterada';
        return AlertDialog(
          title: const Text('Alterar Medida'),
          content: CustomTextField(
            controller: medida,
            hint: 'Informe a $type...',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                updateFunction!(medida.text);
                AppCore().successDialog(context, '$type com sucesso');
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
}
