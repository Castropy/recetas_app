import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  // Mueve la definición del borde estático para optimización
  static final _outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Colors.transparent, // El borde es invisible
    ),
  );

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final inputDecoration = InputDecoration(

      enabledBorder: _outlinedBorder,
      focusedBorder: _outlinedBorder,
      filled: true,
      fillColor: Colors.grey.shade200, // Color de fondo más claro (opcional)
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
    );

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      decoration: inputDecoration,
      keyboardType: keyboardType,
      
      // Excelente práctica para cerrar el teclado
      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }
}