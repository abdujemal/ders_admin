import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/pages/add_category.dart';
import 'package:ders_admin/pages/add_ustaz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  List<String> categoryList = [];

  int noOfCourses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddUstaz(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Category").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          categoryList = [];
          noOfCourses = 0;
          for (var d in snapshot.data!.docs) {
            categoryList.add(d.data()["name"]);
            noOfCourses++;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("$noOfCourses Ustazs"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCateogry(
                            category: categoryList[index],
                          ),
                        ),
                      );
                    },
                    leading: const Icon(Icons.category),
                    title: Text(categoryList[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
