import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      this.hint,
      this.obscure,
      this.function,
      this.maxLines,
      this.controller,
      this.formater,
      this.validator,
      this.errorStyle,
      this.errorText,
      this.focusedBorder});
  String? hint;
  bool? obscure;
  Function(String)? function;
  int? maxLines;
  TextEditingController? controller;
  List<TextInputFormatter>? formater;
  String? Function(String?)? validator;
  String? errorText;
  TextStyle? errorStyle;
  InputBorder? focusedBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), // Borda arredondada
        color: Colors.white, // Cor de fundo
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ], // Sombra
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        onChanged: function,
        inputFormatters: formater,
        obscureText: obscure ?? false,
        validator: validator,
        decoration: InputDecoration(
          errorText: errorText,
          errorStyle: errorStyle,
          focusedBorder: focusedBorder,
          hintStyle: const TextStyle(color: Colors.grey),
          hintText: hint ?? '',
          border: InputBorder.none, // Remova a borda padrão
          contentPadding: const EdgeInsets.all(12.0), // Espaçamento interno
        ),
      ),
    );
  }
}
