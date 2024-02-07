// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ders_admin/pages/add_course.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../course.dart';

class CourseItem extends ConsumerStatefulWidget {
  final Course courseModel;
  const CourseItem(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends ConsumerState<CourseItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddCourse(
              course: widget.courseModel,
            ),
          ),
        );
      },
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.courseModel.image,
                              ),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 80,
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.music_note_rounded,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                Text(
                                  "${widget.courseModel.courseIds.split(",").length}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 23,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.courseModel.title,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                widget.courseModel.audioSizes != null
                                    ? widget.courseModel.courseIds
                                                .split(",")
                                                .length ==
                                            widget.courseModel.audioSizes!
                                                .split(",")
                                                .length
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.error,
                                            color: Colors.yellow,
                                          )
                                    : const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // if (widget.courseModel.isFav == 1) {
                        //   if (widget.courseModel.isStarted == 1) {
                        //     await ref
                        //         .read(mainNotifierProvider.notifier)
                        //         .saveCourse(widget.courseModel, 0, context);
                        //   } else {
                        //     ref
                        //         .read(favNotifierProvider.notifier)
                        //         .deleteCourse(widget.courseModel.id, context);
                        //   }
                        // } else {
                        //   await ref
                        //       .read(mainNotifierProvider.notifier)
                        //       .saveCourse(widget.courseModel, 1, context);
                        // }
                      },
                      child: const Icon(
                        Icons.bookmark_border_outlined,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => CourseDetail(
                    //       cm: widget.courseModel,
                    //     ),
                    //   ),
                    // );
                  },
                  onLongPress: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FilteredCourses(
                    //       "ustaz",
                    //       widget.courseModel.ustaz,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 2,
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(15),
                        ),
                        color: primaryColor),
                    child: Text(
                      widget.courseModel.ustaz,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              if (widget.courseModel.category != "")
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => CourseDetail(
                      //       cm: widget.courseModel,
                      //     ),
                      //   ),
                      // );
                    },
                    onLongPress: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => FilteredCourses(
                      //       "category",
                      //       widget.courseModel.category,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 5,
                      ),
                      // height: 20,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomRight: Radius.circular(15),
                        ),
                        color: primaryColor,
                      ),
                      child: Text(
                        widget.courseModel.category,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              if (widget.courseModel.isCompleted == 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 5,
                    ),
                    // height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.amber,
                    ),
                    child: const Text(
                      "አላለቀም",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
