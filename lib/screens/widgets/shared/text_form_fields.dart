import 'package:flutter/material.dart';

class MyTextFormFields extends StatelessWidget {
  const MyTextFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    
    final outlinedborder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );

    final inputDecoration = InputDecoration(
        enabledBorder: outlinedborder,
        focusedBorder: outlinedborder,
        filled: true,
        hintText: 'Escribe aqui',
        
    );

    return TextFormField(
      
      onTapOutside: (event){
        focusNode.unfocus();
      },
      
      focusNode: focusNode,
      decoration:  inputDecoration,  
    );
    
  }
}