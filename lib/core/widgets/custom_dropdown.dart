import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({super.key});

  @override
  Widget build(BuildContext context) {
    double widScreen = MediaQuery.of(context).size.width;
    return Container(
      width: widScreen * 0.8,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: const Border.fromBorderSide(
              BorderSide(color: Colors.orange, width: 2))),
      child: Center(
        child: DropdownButton(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          elevation: 0,
          underline: const DropdownButtonHideUnderline(child: SizedBox()),
          isDense: true,
          isExpanded: true,
          items: const [],
          onChanged: null,
          style: const TextStyle(fontSize: 18),
          hint: const Text('Opções de filtro:'),
        ),
      ),
    );
  }
}
