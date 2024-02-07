import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUstaz extends ConsumerStatefulWidget {
  final String? ustazName;
  const AddUstaz({
    super.key,
    this.ustazName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddUstazState();
}

class _AddUstazState extends ConsumerState<AddUstaz> {
  TextEditingController ustazTc = TextEditingController();

  int count = 0;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.ustazName != null) {
      ustazTc.text = widget.ustazName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Ustaz"),
        actions: [
          widget.ustazName != null
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
                              .collection("Ustaz")
                              .doc(widget.ustazName)
                              .delete();

                          final courses = await FirebaseFirestore.instance
                              .collection("Courses")
                              .where("ustaz", isEqualTo: widget.ustazName)
                              .get();

                          for (var doc in courses.docs) {
                            await FirebaseFirestore.instance
                                .collection("Courses")
                                .doc(doc.id)
                                .delete();
                          }
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
              controller: ustazTc,
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
                      if (widget.ustazName != null) {
                        await FirebaseFirestore.instance
                            .collection("Ustaz")
                            .doc(widget.ustazName)
                            .delete();

                        final courses = await FirebaseFirestore.instance
                            .collection("Courses")
                            .where("ustaz", isEqualTo: widget.ustazName)
                            .get();

                        for (var doc in courses.docs) {
                          await FirebaseFirestore.instance
                              .collection("Courses")
                              .doc(doc.id)
                              .update({"ustaz": ustazTc.text});
                        }
                      }

                      await FirebaseFirestore.instance
                          .collection("Ustaz")
                          .doc(ustazTc.text)
                          .set(
                        {
                          'name': ustazTc.text,
                        },
                        SetOptions(
                          merge: true,
                        ),
                      );

                      loading = false;
                      setState(() {});
                      if (mounted) {
                        Navigator.pop(context);
                      }
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
