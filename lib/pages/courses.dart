import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/course.dart';
import 'package:ders_admin/pages/add_course.dart';
import 'package:ders_admin/widget/course_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Courses extends ConsumerStatefulWidget {
  const Courses({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoursesState();
}

class _CoursesState extends ConsumerState<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        actions: [
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
          )
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
          List<Course> courseList = [];
          for (var d in snapshot.data!.docs) {
            courseList.add(Course.fromMap(d));
          }
          return ListView.builder(
            itemCount: courseList.length,
            itemBuilder: (context, index) => CourseItem(
              courseList[index],
            ),
          );
        },
      ),
    );
  }
}
