import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/providers/app_config_provider.dart';

typedef MyValidator = String? Function(String?);

class CustomTextFormField extends StatefulWidget {
  String label;
  MyValidator validator;
  TextInputType keyboardType;
  TextEditingController controller;
  bool obscureText;
  String? initialValue;
  ValueChanged<String>? onChanged;
  CustomTextFormField(
      {required this.label,
      required this.validator,
      this.keyboardType = TextInputType.text,
      required this.controller,
      this.obscureText = false,
      this.initialValue,
      this.onChanged});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(
            labelStyle: provider.isDark()
                ? Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.whiteColor)
                : Theme.of(context).textTheme.titleMedium,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primaryColor)),
            labelText: widget.label),
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: widget.obscureText,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        style: provider.isDark()
            ? Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.whiteColor)
            : Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
