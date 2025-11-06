import 'package:flutter/material.dart';

class IconButtonVender extends StatelessWidget {
  const IconButtonVender({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      iconSize: 40,
      color: Colors.blue,
      onPressed: (){
        // Acción al presionar el botón
      }, 
    );
  }
}