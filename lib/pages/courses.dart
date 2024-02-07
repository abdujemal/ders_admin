import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/course.dart';
import 'package:ders_admin/database_helper.dart';
import 'package:ders_admin/faq.dart';
import 'package:ders_admin/pages/add_course.dart';
import 'package:ders_admin/pages/categories.dart';
import 'package:ders_admin/pages/ustazs.dart';
import 'package:ders_admin/widget/course_item.dart';
import 'package:ders_admin/widget/filter_ui.dart';
import 'package:ders_admin/widget/update_all_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Courses extends ConsumerStatefulWidget {
  const Courses({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoursesState();
}

class _CoursesState extends ConsumerState<Courses> {
  int noOfCourses = 0;
  List<Course> courseList = [];

  DocumentSnapshot? lastCourse;

  ScrollController scrollController = ScrollController();

  bool showFloatingBtn = false;

  double maxExt = 6;

  bool loadingMore = false;

  bool isLoading = false;

  List<String> ustazList = [];

  List<String> categoryList = [];

  String? selectedCategory;
  String? selectedUstaz;

  bool isUploading = false;

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();

    getCourses(true);
    getNoOfCourses();
    getUstazsAndCategories();

    scrollController.addListener(_scrollListener);
  }

  getUstazsAndCategories() async {
    final ustazQs = await FirebaseFirestore.instance.collection("Ustaz").get();
    final categoryQs =
        await FirebaseFirestore.instance.collection("Category").get();

    List<String> lst1 = [];

    for (var d in ustazQs.docs) {
      lst1.add(d.data()["name"]);
    }
    ustazList.addAll(lst1);

    List<String> lst2 = [];

    for (var d in categoryQs.docs) {
      lst2.add(d.data()["name"]);
    }
    categoryList.addAll(lst2);
  }

  getNoOfCourses({String? ustaz, String? category}) async {
    final aq = await FirebaseFirestore.instance
        .collection("Courses")
        .where('ustaz', isEqualTo: ustaz)
        .where('category', isEqualTo: category)
        .orderBy('dateTime', descending: true)
        .count()
        .get();

    noOfCourses = aq.count;
    setState(() {});
  }

  Future<void> getCourses(bool isNew, {String? ustaz, String? category}) async {
    QuerySnapshot qs;
    if (isNew) {
      isLoading = true;
      setState(() {});
    }
    if (isNew) {
      courseList = [];
      qs = await FirebaseFirestore.instance
          .collection("Courses")
          .where('ustaz', isEqualTo: ustaz)
          .where('category', isEqualTo: category)
          .orderBy('dateTime', descending: true)
          .limit(20)
          .get();
    } else {
      qs = await FirebaseFirestore.instance
          .collection("Courses")
          .where('ustaz', isEqualTo: ustaz)
          .where('category', isEqualTo: category)
          .orderBy('dateTime', descending: true)
          .startAfterDocument(lastCourse!)
          .limit(20)
          .get();
    }
    if (qs.docs.isNotEmpty) {
      lastCourse = qs.docs[qs.docs.length - 1];
    }

    if (qs.docs.isNotEmpty) {
      for (var d in qs.docs) {
        if (d.data() != null) {
          courseList.add(Course.fromMap(d.data() as Map, d.id));
        }
      }
    }
    if (isNew) {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> _scrollListener() async {
    if (scrollController.offset > 400) {
      bool rebuild = false;
      if (showFloatingBtn == false) {
        rebuild = true;
      }
      showFloatingBtn = true;

      if (rebuild) {
        setState(() {});
      }
    } else {
      bool rebuild = false;
      if (showFloatingBtn == true) {
        rebuild = true;
      }
      showFloatingBtn = false;

      if (rebuild) {
        setState(() {});
      }
    }
    maxExt = scrollController.position.maxScrollExtent / 100;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadingMore = true;
      setState(() {});
      await getCourses(
        false,
        ustaz: selectedUstaz,
        category: selectedCategory,
      );
      loadingMore = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Courses"),
          actions: [
            isUploading
                ? const CircularProgressIndicator()
                : IconButton(
                    onPressed: () async {
                      isUploading = true;
                      setState(() {});
                      Directory directory = (await getDownloadsDirectory())!;
                      String path = '${directory.path}$dbPath';

                      final res = await FirebaseFirestore.instance
                          .collection("Courses")
                          .get();

                      List<String> uniqueNames = [];
                      for (var d in res.docs) {
                        if (!uniqueNames.contains(d.data()["title"])) {
                          uniqueNames.add(d.data()["title"]);
                          await DatabaseHelper()
                              .insertContent(d.data()["title"]);
                        }
                        await DatabaseHelper()
                            .insertCourse(Course.fromMap(d.data(), d.id));
                      }

                      final res1 = await FirebaseFirestore.instance
                          .collection("Ustaz")
                          .get();

                      for (var d in res1.docs) {
                        await DatabaseHelper().insertUstaz(d.data()["name"]);
                      }

                      final res2 = await FirebaseFirestore.instance
                          .collection("Category")
                          .get();

                      for (var d in res2.docs) {
                        await DatabaseHelper().insertCategory(d.data()["name"]);
                      }

                      final res3 = await FirebaseFirestore.instance
                          .collection(DatabaseConst.faq)
                          .get();

                      for (var d in res3.docs) {
                        await DatabaseHelper().insertFaq(Faq.fromMap(d.data()));
                      }

                      print("path: ${directory.path}");
                      print(
                          "file size ${formatFileSize(File(path).lengthSync())}");
                      // await uploadFileToB2();
                      isUploading = false;
                      setState(() {});
                    },
                    icon: const Icon(Icons.upload),
                  ),
            IconButton(
              onPressed: () async {
                Fluttertoast.showToast(
                    msg: "loading", toastLength: Toast.LENGTH_LONG);

                List<Course> courses = [];

                final res = await FirebaseFirestore.instance
                    .collection("Courses")
                    .where('audioSizes', isNull: true)
                    .orderBy('dateTime', descending: true)
                    .get();

                for (var doc in res.docs) {
                  courses.add(Course.fromMap(doc.data(), doc.id));
                }

                print("num of courses ${courses.length}");
                Fluttertoast.showToast(
                  msg: "loaded",
                );

                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateAllCourses(
                      courses,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.mic_none),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Ustazs(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Categories(),
                  ),
                );
              },
              icon: const Icon(Icons.category),
            ),
            IconButton(
              onPressed: () {
                if (ustazList.isNotEmpty && categoryList.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => FilterUi(
                      action: (ustaz, category) async {
                        selectedCategory = category;
                        selectedUstaz = ustaz;
                        setState(() {});
                        print("ustaz: $ustaz, category: $category");
                        await getCourses(
                          true,
                          ustaz: ustaz,
                          category: category,
                        );
                        await getNoOfCourses(
                          ustaz: selectedUstaz,
                          category: selectedCategory,
                        );
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      ustazs: ustazList,
                      categories: categoryList,
                      selectedUstaz: selectedUstaz,
                      selectedCategory: selectedCategory,
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: "Wait");
                }
              },
              icon: Icon(
                Icons.filter_alt_sharp,
                color: selectedCategory != null || selectedUstaz != null
                    ? Colors.amber
                    : null,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCourse(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("$noOfCourses Courses"),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNoOfCourses(
                    ustaz: selectedUstaz,
                    category: selectedCategory,
                  );
                  getCourses(
                    true,
                    ustaz: selectedUstaz,
                    category: selectedCategory,
                  );
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Stack(
                        children: [
                          ListView.builder(
                            controller: scrollController,
                            itemCount: courseList.length + 1,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index != courseList.length) {
                                return CourseItem(
                                  courseList[index],
                                );
                              } else {
                                return loadingMore
                                    ? const Center(
                                        child: SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 60,
                                      );
                              }
                            },
                          ),
                          AnimatedPositioned(
                            right: 5,
                            bottom: showFloatingBtn ? 5 : -57,
                            duration: const Duration(milliseconds: 500),
                            child: Opacity(
                              opacity: /*showFloatingBtn ?*/ 1.0 /*: 0.0*/,
                              child: FloatingActionButton(
                                onPressed: () => scrollController
                                    .animateTo(
                                      0.0, // Scroll to the top
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    )
                                    .then((value) => setState(() {})),
                                child: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ));
  }
}
