// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInput extends StatelessWidget {
  final int? noOfText;

  final Function(String? v)? onChanged;

  final bool readOnly;

  final TextEditingController controller;

  final int? noOfLine;

  final FocusNode? focusNode;

  final String hint;

  final TextInputType textInputType;

  final String? Function(String? v)? validator;

  const CustomInput({
    Key? key,
    this.noOfText,
    this.onChanged,
    this.readOnly = false,
    this.validator,
    required this.controller,
    this.noOfLine,
    required this.hint,
    required this.textInputType,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: validator ??
                (value) {
                  if (value!.isEmpty) {
                    return "This Feild is required";
                  }
                  return null;
                },
            style: GoogleFonts.notoSansEthiopic(),
            maxLength: noOfText,
            onChanged: onChanged,
            readOnly: readOnly,
            controller: controller,
            maxLines: noOfLine,
            keyboardType: textInputType,
            focusNode: focusNode,
            minLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
