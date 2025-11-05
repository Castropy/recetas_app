import 'package:flutter/material.dart';
import 'package:recetas_app/screens/widgets/shared/text_form_fields.dart';
class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          MyTextFormFields(),
        ],
        
      ),
    );
  }
} 