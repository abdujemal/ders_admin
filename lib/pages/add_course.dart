import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/audio_item.dart';
import '../widget/auto_complete.dart';
import '../constants.dart';
import '../course.dart';
import '../custom_input.dart';

class AddCourse extends ConsumerStatefulWidget {
  final Course? course;
  const AddCourse({this.course, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCourseState();
}

class _AddCourseState extends ConsumerState<AddCourse> {
  TextEditingController titleTc = TextEditingController();

  TextEditingController categoryTc = TextEditingController();

  // TextEditingController ustazTc = TextEditingController();
  String? selectedUstaz;

  TextEditingController courseLink = TextEditingController();

  TextEditingController pdfLink = TextEditingController();

  TextEditingController noOfRecords = TextEditingController();

  // TextEditingController prerequisitTc = TextEditingController();

  TextEditingController authorTc = TextEditingController();

  GlobalKey<FormState> courseKey = GlobalKey<FormState>();

  bool isLoading = false;

  List<String> ustazs = [];

  List<String> category = [];

  bool isValidating = false;

  bool alsoDate = false;

  String uploadDate = DateTime.now().toString();

  int? playingIndex;

  TextEditingController imageLink = TextEditingController();

  List<String> audioIds = [];

  List<String> urls = [];

  bool isCompleted = true;

  @override
  void initState() {
    super.initState();

    if (widget.course != null) {
      print("audioSizes ${widget.course!.audioSizes}");
      isCompleted = widget.course!.isCompleted == 1;
      titleTc.text = widget.course!.title;
      categoryTc.text = widget.course!.category;
      courseLink.text = widget.course!.courseIds
          .split(",")
          .map((e) {
            String encodedString = e
                .replaceAll("https://b2.ilmfelagi.com/file/ilm-Felagi2/", "")
                .replaceAll("https://b2.ilmfelagi.com/file/Ilm-Felagi/", "");

            print("encodedString: ${encodedString}");
            String decodedString = encodedString.contains("_")
                ? Uri.decodeFull(encodedString).replaceAll(" ", "_")
                : encodedString;
            return "$decodedString:-$e";
          })
          .toList()
          .join(",");
      pdfLink.text = widget.course!.pdfId;
      noOfRecords.text = widget.course!.noOfRecord.toString();
      authorTc.text = widget.course!.author;
      imageLink.text = widget.course!.image;
      // uploadDate = widget.course!.dateTime;
      audioIds = widget.course!.courseIds.split(",").map((e) {
        String encodedString = e
            .replaceAll("https://b2.ilmfelagi.com/file/ilm-Felagi2/", "")
            .replaceAll("https://b2.ilmfelagi.com/file/Ilm-Felagi/", "");
        String decodedString =
            Uri.decodeFull(encodedString).replaceAll(" ", "_");
        return "$decodedString:-$e";
      }).toList();
      urls = widget.course!.courseIds.split(",");
    }

    refresh();
  }

  refresh() {
    ustazs = [];
    category = [];
    FirebaseFirestore.instance.collection("Ustaz").get().then((ds) {
      if (ds.docs.isNotEmpty) {
        final data = ds.docs;
        ustazs.addAll(data.map((e) => e.data()['name']));
        if (widget.course != null) {
          selectedUstaz = ustazs.contains(widget.course!.ustaz)
              ? widget.course!.ustaz
              : ustazs.first;
        } else {
          selectedUstaz = ustazs.isNotEmpty ? ustazs.first : null;
        }
        setState(() {});
      }
    });

    FirebaseFirestore.instance.collection("Category").get().then((ds) {
      if (ds.docs.isNotEmpty) {
        final data = ds.docs;
        category.addAll(data.map((e) => e.data()['name']));
        setState(() {});
      }
    });
  }

  void onReorder(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items1 = audioIds.removeAt(oldindex);
      audioIds.insert(newindex, items1);
      final items2 = urls.removeAt(oldindex);
      urls.insert(newindex, items2);

      courseLink.text = audioIds.join(",");
    });
  }

  bool deleteNow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course != null ? "Edit Course" : "Add Course"),
        actions: [
          IconButton(
            onPressed: () async {
              if (deleteNow) {
                await FirebaseFirestore.instance
                    .collection("Courses")
                    .doc("${widget.course!.courseId}")
                    .delete();
                Fluttertoast.showToast(msg: "Deleted successfully");
                if (mounted) {
                  Navigator.pop(context);
                }
              } else {
                deleteNow = true;
                Fluttertoast.showToast(msg: "Press it again.");
                Future.delayed(const Duration(seconds: 5)).then((value) {
                  deleteNow = false;
                });
              }
            },
            icon: const Icon(Icons.delete),
          ),
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
              CheckboxListTile(
                  value: alsoDate,
                  title: const Text("Also Date"),
                  onChanged: (v) {
                    setState(() {
                      alsoDate = v!;
                    });
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Courses")
                    .snapshots(),
                builder: (context, as) {
                  List<Course> courseLst = [];
                  if (as.hasData) {
                    final data = as.data!.docs;
                    courseLst = data
                        .map((e) => Course.fromMap(e.data(), e.id))
                        .toList();
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
                        pdfLink.text = course.pdfId;
                        authorTc.text = course.author;
                        imageLink.text = course.image;
                        if (alsoDate) {
                          print("works");
                          uploadDate = course.dateTime;
                        }
                      });
                    },
                  );
                },
              ),
              // CustomAutoComplete(
              //   suggestions: ustazs,
              //   ref: ref,
              //   hint: "Ustaz",
              //   textInputType: TextInputType.text,
              //   textEditingController: ustazTc,
              // ),
              DropdownButton(
                value: selectedUstaz,
                items: ustazs
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (String? v) {
                  selectedUstaz = v;
                  setState(() {});
                },
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
                validator: (v) {
                  if (v!.isEmpty) {
                    return "This Feild is required";
                  }
                  if (v.contains(" ")) {
                    return "Please validate the audio Ids!";
                  }
                  return null;
                },
                controller: courseLink,
                hint: "Audio Ids",
                noOfLine: 10,
                textInputType: TextInputType.text,
                onChanged: (v) {
                  audioIds = v!
                      .trim()
                      .replaceAll('\n', ",")
                      .split(",")
                      .where((e) => e.isNotEmpty && e != "Islamic Durus:")
                      .toList();

                  courseLink.text = audioIds.join(",");

                  urls = List.generate(audioIds.length, (index) => "$index");
                },
              ),
              // inputtags(),
              CustomInput(
                controller: pdfLink,
                hint: "Pdf Id",
                textInputType: TextInputType.text,
              ),
              CustomInput(
                controller: imageLink,
                hint: "Image Id",
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
              CheckboxListTile(
                  title: const Text("Is Completed"),
                  value: isCompleted,
                  onChanged: (v) {
                    setState(() {
                      isCompleted = v!;
                    });
                  }),
              InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Ink(
                  padding: const EdgeInsets.all(10),
                  color: Colors.amber,
                  child: const Text("Validate Audios"),
                ),
              ),

              if (courseLink.text.isNotEmpty)
                SizedBox(
                  height: 400,
                  child: ReorderableListView(
                    onReorder: onReorder,
                    children: [
                      for (int i = 0; i < audioIds.length; i++)
                        AudioItem(
                          key: ValueKey(audioIds[i]),
                          id: audioIds[i],
                          title: "${titleTc.text.trim()} ${i + 1}",
                          isThisAudioPlaying: i == playingIndex,
                          onLoaded: (String url) {
                            urls[i] = url;
                            print("loaded");
                          },
                          onPlayTab: () {
                            playingIndex = i;
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        List<String> pureIds =
                            audioIds.map((e) => e.split(":-").last).toList();

                        if (courseKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            if (widget.course != null) {
                              String now = DateTime.now().toString();
                              final data = widget.course!
                                  .copyWith(
                                    isCompleted: isCompleted ? 1 : 0,
                                    title: titleTc.text.trim(),
                                    author: authorTc.text,
                                    ustaz: selectedUstaz!,
                                    category: categoryTc.text,
                                    courseIds: pureIds.join(","),
                                    dateTime: alsoDate ? uploadDate : now,
                                    pdfId: pdfLink.text.trim().split(":-").last,
                                    image: imageLink.text,
                                    noOfRecord: int.parse(noOfRecords.text),
                                  )
                                  .toOriginalMap();
                              await FirebaseFirestore.instance
                                  .collection("Courses")
                                  .doc(widget.course!.courseId)
                                  .update(data);
                              final dio = Dio();
                              // final body = jsonEncode(data);
                              dio.options = BaseOptions(
                                followRedirects:
                                    true, // Automatically follow redirects
                                maxRedirects:
                                    5, // Set the maximum number of redirects to follow
                              );
                              dio.options = BaseOptions(
                                followRedirects:
                                    true, // Allow automatic redirect handling
                                maxRedirects:
                                    5, // Limit the number of redirects to avoid infinite loops
                                validateStatus: (status) {
                                  // Automatically accept all 2xx and 3xx status codes
                                  return status! < 500;
                                },
                              );

                              final qs = await dio.post(
                                "$serverUrl/courses/add?userName=admins&password=1234asdf",
                                data: data,
                              );
                            } else {
                              await FirebaseFirestore.instance
                                  .collection("Courses")
                                  .doc("$selectedUstaz${titleTc.text.trim()}")
                                  .set(
                                    Course(
                                      courseId:
                                          "$selectedUstaz${titleTc.text.trim()}",
                                      title: titleTc.text.trim(),
                                      author: authorTc.text,
                                      ustaz: selectedUstaz!,
                                      category: categoryTc.text,
                                      courseIds: pureIds.join(","),
                                      pdfId:
                                          pdfLink.text.trim().split(":-").last,
                                      image: imageLink.text,
                                      noOfRecord: int.parse(noOfRecords.text),
                                      dateTime: uploadDate,
                                      totalDuration: 0,
                                      audioSizes: null,
                                      isCompleted: isCompleted ? 1 : 0,
                                    ).toOriginalMap(),
                                    SetOptions(
                                      merge: true,
                                    ),
                                  );
                            }

                            await FirebaseFirestore.instance
                                .collection("Ustaz")
                                .doc(selectedUstaz!)
                                .set(
                              {
                                'name': selectedUstaz,
                              },
                              SetOptions(
                                merge: true,
                              ),
                            );

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

                            if (widget.course != null) {
                              Fluttertoast.showToast(
                                  msg: "Successfully Updated");
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              // refresh();

                              // setState(() {
                              //   isLoading = false;
                              //   titleTc.text.trim() = "";
                              //   categoryTc.text = "";
                              //   courseLink.text = "";
                              //   pdfLink.text = "";
                              //   noOfRecords.text = "";
                              //   authorTc.text = "";
                              //   imageLink.text = "";
                              //   audioIds = [];
                              // });
                              Fluttertoast.showToast(msg: "Successfully Added");
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            }
                          } catch (e) {
                            print(e.toString());
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
