import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterUi extends ConsumerStatefulWidget {
  final List<String> ustazs;
  final List<String> categories;
  final String? selectedCategory;
  final String? selectedUstaz;
  final Future<void> Function(String? ustaz, String? category) action;
  const FilterUi({
    required this.ustazs,
    required this.categories,
    required this.action,
    this.selectedCategory,
    this.selectedUstaz,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterUiState();
}

class _FilterUiState extends ConsumerState<FilterUi> {
  String? category;
  String? ustaz;
  List<String> ustazs = [];
  List<String> categories = [];

  @override
  void initState() {
    super.initState();

    category = widget.selectedCategory;
    ustaz = widget.selectedUstaz;

    ustazs = ["", ...widget.ustazs];
    categories = ["", ...widget.categories];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).cardColor,
      child: SizedBox(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Filter",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton(
                  value: category,
                  items: categories
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (String? v) {
                    category = v == "" ? null : v;
                    setState(() {});
                  },
                ),
                const Text(
                  "Ustaz",
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton(
                  value: ustaz,
                  items: ustazs
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (String? v) {
                    ustaz = v == "" ? null : v;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.action(null, null);
                      },
                      child: const Text("Clear"),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.action(ustaz, category);
                      },
                      child: const Text("Apply"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
