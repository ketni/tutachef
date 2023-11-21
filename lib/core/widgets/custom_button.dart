import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.textButton,
      required this.function,
      this.styleText});
  String textButton;
  Function() function;
  TextStyle? styleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,

      margin: const EdgeInsets.all(10.0), // Margem para espaçamento
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          disabledBackgroundColor: Colors.grey,
          backgroundColor: Colors.white,

          padding: const EdgeInsets.all(12.0), // Espaçamento interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Borda arredondada
          ),
        ),
        onPressed: function,

        child: Text(
          textButton,
          style:
              styleText ?? TextStyle(color: Colors.orange[800], fontSize: 18),
        ), // Texto do botão
      ),
    );
  }
}
