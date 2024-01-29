import 'package:ders_admin/course.dart';
import 'package:ders_admin/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAutoComplete extends StatelessWidget {
  final List<String> suggestions;
  final WidgetRef ref;
  final String hint;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  const CustomAutoComplete({
    super.key,
    required this.suggestions,
    required this.ref,
    required this.hint,
    required this.textInputType,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete(
      textEditingController: textEditingController,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        } else {
          List<String> matches = <String>[];
          matches.addAll(suggestions);

          matches.retainWhere((s) {
            return s
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
          print(matches);
          return matches;
        }
      },
      onSelected: (String selection) {
        print(selection);
        // ref.read(stateProvider.notifier).update((state) => selection);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return CustomInput(
          hint: hint,
          controller: textEditingController,
          focusNode: focusNode,
          textInputType: textInputType,
        );
      },
      displayStringForOption: (o) => o,
      optionsViewBuilder: (BuildContext context,
          void Function(String) onSelected, Iterable<String> options) {
        print(options.length);
        return Material(
          child: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: options.map((opt) {
                  return InkWell(
                    onTap: () {
                      onSelected(opt);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 60),
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            opt,
                            style: GoogleFonts.notoSansEthiopic(
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TitleAutoComplete extends StatelessWidget {
  final List<Course> suggestions;
  final WidgetRef ref;
  final String hint;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final Function(Course course) onSelected;
  const TitleAutoComplete({
    super.key,
    required this.onSelected,
    required this.suggestions,
    required this.ref,
    required this.hint,
    required this.textInputType,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Course>(
      textEditingController: textEditingController,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Course>.empty();
        } else {
          List<Course> matches = <Course>[];
          matches.addAll(suggestions);

          matches.retainWhere((s) {
            return s.title
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
          print(matches);
          return matches;
        }
      },
      onSelected: onSelected,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return CustomInput(
          hint: hint,
          controller: textEditingController,
          focusNode: focusNode,
          textInputType: textInputType,
        );
      },
      displayStringForOption: (o) => o.title,
      optionsViewBuilder: (BuildContext context,
          void Function(Course) onSelected, Iterable<Course> options) {
        print(options.length);
        return Material(
          child: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: options.map((opt) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    child: InkWell(
                      onTap: () {
                        onSelected(opt);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 60),
                        child: Card(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "${opt.title} by ${opt.ustaz}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSansEthiopic(
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
