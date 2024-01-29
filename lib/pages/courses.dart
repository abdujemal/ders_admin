import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/course.dart';
import 'package:ders_admin/pages/add_category.dart';
import 'package:ders_admin/pages/add_course.dart';
import 'package:ders_admin/pages/categories.dart';
import 'package:ders_admin/pages/ustazs.dart';
import 'package:ders_admin/widget/course_item.dart';
import 'package:ders_admin/widget/update_all_courses.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Courses extends ConsumerStatefulWidget {
  const Courses({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoursesState();
}

class _CoursesState extends ConsumerState<Courses> {
  int noOfCourses = 0;
  List<Course> courseList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        actions: [
          IconButton(
            onPressed: () {
              if (courseList.isNotEmpty) {
                Fluttertoast.showToast(msg: "there you go");

                showDialog(
                  context: context,
                  builder: (context) => UpdateAllCourses(
                    courseList,
                  ),
                );
              } else {
                Fluttertoast.showToast(msg: "Wait...");
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Courses")
            .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          courseList = [];
          noOfCourses = 0;
          for (var d in snapshot.data!.docs) {
            courseList.add(Course.fromMap(d));
            noOfCourses++;
          }

          return ListView.builder(
              itemCount: courseList.length + 1,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index > 0) {
                  return CourseItem(
                    courseList[index - 1],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("$noOfCourses Courses"),
                  );
                }
              });
        },
      ),
    );
  }
}
