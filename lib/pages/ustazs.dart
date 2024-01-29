import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/constants.dart';
import 'package:ders_admin/pages/add_ustaz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Ustazs extends ConsumerStatefulWidget {
  const Ustazs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UstazsState();
}

class _UstazsState extends ConsumerState<Ustazs> {
  List<String> ustazList = [];

  int noOfCourses = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ustazs Page"),
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
        stream: FirebaseFirestore.instance.collection("Ustaz").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          ustazList = [];
          noOfCourses = 0;
          for (var d in snapshot.data!.docs) {
            ustazList.add(d.data()["name"]);
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
                  itemCount: ustazList.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUstaz(
                            ustazName: ustazList[index],
                          ),
                        ),
                      );
                    },
                    leading: const Icon(Icons.account_circle),
                    title: Text(ustazList[index]),
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
