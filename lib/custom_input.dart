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

  const CustomInput({
    Key? key,
    this.noOfText,
    this.onChanged,
    this.readOnly = false,
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
            validator: (value) {
              if (value!.isEmpty) {
                return "This Feild is required";
              }
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
              enabledBorder: UnderlineInputBorder(
                borderSide: hint == null
                    ? BorderSide.none
                    : BorderSide(
                        color: Colors.grey,
                      ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: hint == null
                    ? BorderSide.none
                    : BorderSide(
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
