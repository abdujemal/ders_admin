import 'package:any_link_preview/any_link_preview.dart';
import 'package:ders_admin/auto_complete.dart';
import 'package:ders_admin/course.dart';
import 'package:ders_admin/custom_input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ders Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddCourse(),
    );
  }
}

class AddCourse extends ConsumerStatefulWidget {
  const AddCourse({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCourseState();
}

class _AddCourseState extends ConsumerState<AddCourse> {
  TextEditingController titleTc = TextEditingController();

  TextEditingController categoryTc = TextEditingController();

  TextEditingController ustazTc = TextEditingController();

  TextEditingController courseLink = TextEditingController();

  TextEditingController pdfLink = TextEditingController();

  TextEditingController noOfRecords = TextEditingController();

  TextEditingController prerequisitTc = TextEditingController();

  TextEditingController authorTc = TextEditingController();

  GlobalKey<FormState> courseKey = GlobalKey<FormState>();

  bool isLoading = false;

  List<String> ustazs = [];

  List<String> category = [];

  @override
  void initState() {
    super.initState();

    refresh();
  }

  refresh() {
    FirebaseDatabase.instance.ref().child("Ustaz").get().then((ds) {
      if (ds.exists) {
        final data = ds.value as Map;
        ustazs.addAll(data.values.map((e) => e['name']));
        setState(() {});
      }
    });

    FirebaseDatabase.instance.ref().child("Category").get().then((ds) {
      if (ds.exists) {
        final data = ds.value as Map;
        category.addAll(data.values.map((e) => e['name']));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Course"),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: courseKey,
          child: Column(
            children: [
              AnyLinkPreview(
                link: "https://t.me/MohamedAljawi/3305",
                showMultimedia: true,
                bodyMaxLines: 5,
                bodyTextOverflow: TextOverflow.ellipsis,
                titleStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                errorBody: 'Show my custom error body',
                errorTitle: 'Show my custom error title',
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Oops!'),
                ),
                errorImage: "https://google.com/",
                cache: const Duration(days: 7),
                backgroundColor: Colors.grey[300],
                borderRadius: 12,
                removeElevation: false,
                boxShadow: const[BoxShadow(blurRadius: 3, color: Colors.grey)],
                // onTap: () {}, // This disables tap event
              ),
              StreamBuilder(
                stream:
                    FirebaseDatabase.instance.ref().child("Courses").onValue,
                builder: (context, as) {
                  List<Course> courseLst = [];
                  if (as.hasData) {
                    final data =
                        as.data!.snapshot.value as Map<dynamic, dynamic>;
                    courseLst =
                        data.values.map((e) => Course.fromMap(e)).toList();
                  }
                  return TitleAutoComplete(
                    suggestions: courseLst,
                    ref: ref,
                    hint: "Title",
                    textInputType: TextInputType.text,
                    textEditingController: titleTc,
                    onSelected: (Course course) {
                      setState(() {
                        titleTc.text = course.title;
                        categoryTc.text = course.category;
                        pdfLink.text = course.pdfLink;
                        prerequisitTc.text = course.preRequisit.join(",");
                        authorTc.text = course.author;
                      });
                    },
                  );
                },
              ),
              CustomAutoComplete(
                suggestions: ustazs,
                ref: ref,
                hint: "Ustaz",
                textInputType: TextInputType.text,
                textEditingController: ustazTc,
              ),
              CustomAutoComplete(
                suggestions: category,
                ref: ref,
                hint: "Category",
                textInputType: TextInputType.text,
                textEditingController: categoryTc,
              ),
              CustomInput(
                controller: authorTc,
                hint: "Author",
                textInputType: TextInputType.text,
              ),
              CustomInput(
                controller: courseLink,
                hint: "Course Link ",
                textInputType: TextInputType.text,
              ),
              CustomInput(
                controller: pdfLink,
                hint: "Pdf Link ",
                textInputType: TextInputType.text,
              ),
              CustomInput(
                controller: prerequisitTc,
                hint: "Prerequisit",
                textInputType: TextInputType.text,
              ),
              CustomInput(
                controller: noOfRecords,
                hint: "Number of record ",
                textInputType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        if (courseKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("Courses")
                                .push()
                                .update(
                                  Course(
                                    title: titleTc.text,
                                    author: authorTc.text,
                                    ustaz: ustazTc.text,
                                    category: categoryTc.text,
                                    courseLink: courseLink.text,
                                    pdfLink: pdfLink.text,
                                    preRequisit: prerequisitTc.text.split(","),
                                    noOfRecord: int.parse(noOfRecords.text),
                                  ).toMap(),
                                );

                            await FirebaseDatabase.instance
                                .ref()
                                .child("Ustaz")
                                .child(ustazTc.text)
                                .update({'name': ustazTc.text});

                            await FirebaseDatabase.instance
                                .ref()
                                .child("Category")
                                .child(categoryTc.text)
                                .update({'name': categoryTc.text});

                            refresh();

                            setState(() {
                              isLoading = false;
                              titleTc.text = "";
                              ustazTc.text = "";
                              categoryTc.text = "";
                              courseLink.text = "";
                              pdfLink.text = "";
                              noOfRecords.text = "";
                              prerequisitTc.text = "";
                              authorTc.text = "";
                            });

                            Fluttertoast.showToast(msg: "Successfully Added");
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: e.toString(),
                              backgroundColor: Colors.red,
                            );

                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(10),
                        color: Colors.amber,
                        child: const Text("Save"),
                      ),
                    ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
