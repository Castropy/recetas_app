import 'package:flutter/material.dart';
import 'package:recetas_app/screens/widgets/shared/icon_button_vender.dart';
import 'package:recetas_app/screens/widgets/shared/text_form_fields.dart';
class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.4),
            child: MyTextFormFields(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButtonVender(),
          ),
        ],
      ),
    );
  }
} 