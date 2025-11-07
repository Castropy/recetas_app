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
        hintText: 'Buscar Recetas',
        prefixIcon: Icon(Icons.search, color: Colors.grey,),
        
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

class MyTextFormFields2 extends StatelessWidget {
  const MyTextFormFields2({super.key});

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
        hintText: 'Buscar Recetas',
        prefixIcon: Icon(Icons.search, color: Colors.grey,),
        
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