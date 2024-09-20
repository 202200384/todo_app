import 'package:flutter/material.dart';
import 'package:todo_app_project/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  String label;
  TextEditingController controller;
  TextInputType keyBoardType;
  bool obscureText;
  String? Function (String?) validator;
  CustomTextFormField({required this.label,required this.controller,this.keyBoardType =
  TextInputType.text,this.obscureText = false,required this.validator});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color:

          AppColors.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.primaryColor)
          ),
          focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: AppColors.primaryColor),
        ),
          errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: AppColors.redColor),
      ),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.redColor),
    ),
          errorMaxLines: 2
    ),
        style: TextStyle(
          color: Colors.black,fontSize:18
        ),
        controller: controller,
        keyboardType: keyBoardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
