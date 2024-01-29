import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCateogry extends ConsumerStatefulWidget {
  final String? category;
  const AddCateogry({
    super.key,
    this.category,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCateogryState();
}

class _AddCateogryState extends ConsumerState<AddCateogry> {
  TextEditingController categoryTc = TextEditingController();

  int count = 0;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      categoryTc.text = widget.category!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
        actions: [
          widget.category != null
              ? loading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        if (count > 0) {
                          loading = true;
                          setState(() {});
                          await FirebaseFirestore.instance
                              .collection("Category")
                              .doc(widget.category)
                              .delete();

                          // final courses = await FirebaseFirestore.instance
                          //     .collection("Courses")
                          //     .where("ustaz", isEqualTo: widget.category)
                          //     .get();

                          // for (var doc in courses.docs) {
                          //   await FirebaseFirestore.instance
                          //       .collection("Courses")
                          //       .doc(doc.id)
                          //       .delete();
                          // }
                          loading = false;
                          setState(() {});
                          if (mounted) {
                            Navigator.pop(context);
                          }
                          return;
                        }
                        count++;
                        Fluttertoast.showToast(msg: "Touch it again");
                      },
                      icon: const Icon(Icons.delete),
                    )
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomInput(
              controller: categoryTc,
              hint: "Ustaz Name",
              textInputType: TextInputType.text,
            ),
            loading
                ? const CircularProgressIndicator(
                    color: primaryColor,
                  )
                : InkWell(
                    onTap: () async {
                      loading = true;
                      setState(() {});
                      if (widget.category != null) {
                        await FirebaseFirestore.instance
                            .collection("Category")
                            .doc(widget.category)
                            .delete();

                        final courses = await FirebaseFirestore.instance
                            .collection("Courses")
                            .where("category", isEqualTo: widget.category)
                            .get();

                        for (var doc in courses.docs) {
                          await FirebaseFirestore.instance
                              .collection("Courses")
                              .doc(doc.id)
                              .update({"category": categoryTc.text});
                        }
                      }

                      await FirebaseFirestore.instance
                          .collection("Category")
                          .doc(categoryTc.text)
                          .set(
                        {
                          'name': categoryTc.text,
                        },
                        SetOptions(
                          merge: true,
                        ),
                      );

                      loading = false;
                      setState(() {});
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(10),
                      color: Colors.amber,
                      child: const Text("Save"),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
