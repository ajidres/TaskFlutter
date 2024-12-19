import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget(
      {super.key,
      required this.textController,
      this.validator,
      required this.label,
      required this.hint,
        required this.textInputType,
      this.maxLine=1,
      this.minLine=1,
      this.maxLength=0,
      this.enable=true});

  final TextEditingController textController;
  final String? Function(String?)? validator;
  final String label;
  final String hint;
  final int maxLine;
  final int minLine;
  final int maxLength;
  final bool enable;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        keyboardType: textInputType,
        enabled: enable,
        validator: validator,
        maxLength: 250,
        maxLines: 6,
        minLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffd32f2f)),
            ),
            labelText: label,
            hintText: hint,
            helperText: ' ',
            counterText: '',

            hintStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            errorStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            )));
  }
}
