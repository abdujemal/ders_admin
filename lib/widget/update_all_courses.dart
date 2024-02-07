import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ders_admin/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';

class UpdateAllCourses extends ConsumerStatefulWidget {
  final List<Course> courses;
  const UpdateAllCourses(this.courses, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateAllCoursesState();
}

class _UpdateAllCoursesState extends ConsumerState<UpdateAllCourses> {
  String currentCourse = "Starting";

  int i = 0;
  List<String> wrongurls = [];
  int totalDuration = 0;
  List<int> sizes = [];
  bool jumpIt = false;
  bool stopLoop = false;

  @override
  void initState() {
    super.initState();

    updateAllCourses();
  }

  Future<int?> getAudioFileSize(String audioUrl) async {
    final request = await HttpClient().headUrl(Uri.parse(audioUrl));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      final contentLength = response.contentLength;
      return contentLength;
    }
    throw Exception('Failed to get audio file size');
  }

  // Future<int> getMusicDurationFromUrl(String url) async {
  //   final dio = Dio();
  //   final response = await dio.head(url);

  //   final headers = response.headers;
  //   final contentLength = headers.value('content-length');

  //   final durationInSeconds = int.parse(contentLength!) /
  //       44100; // Assuming the music file has a sample rate of 44100

  //   final duration = Duration(seconds: durationInSeconds.round());

  //   print('Music duration: ${duration.toString()}');
  //   return duration.inSeconds;
  // }

  Future<void> updateAllCourses() async {
    stopLoop = false;
    print(widget.courses.length);
    wrongurls = [];
    for (Course cm in widget.courses) {
      if (stopLoop) {
        break;
      }
      if (cm.totalDuration > 0) {
        if (cm.audioSizes.toString() != "null" ||
            cm.audioSizes?.split(",").length ==
                cm.courseIds.split(",").length) {
          continue;
        }
      }
      currentCourse = "${cm.noOfRecord} ${cm.ustaz}${cm.title}";
      setState(() {});

      i = 0;
      totalDuration = 0;
      sizes = [];
      print("prev Durtaion: $totalDuration");
      for (String audioId in cm.courseIds.split(",")) {
        i++;
        if (jumpIt) {
          break;
        }
        if (cm.totalDuration == 0) {
          AudioPlayer player = AudioPlayer();
          while (true) {
            if (stopLoop) {
              break;
            }
            try {
              final duration = await player.setUrl(audioId);

              if (duration != null) {
                print("duration ${duration.toString()}");
                totalDuration = totalDuration + duration.inSeconds;

                print("index $i");
                print(audioId);

                setState(() {});
                break;
              } else {
                wrongurls.add("${cm.title} by ${cm.ustaz} $i");
                setState(() {});
              }
            } catch (e) {
              if (mounted) {
                Fluttertoast.showToast(msg: e.toString());
                print(audioId);
              }
            }
          }
        }
        if (cm.audioSizes == null) {
          while (true) {
            if (stopLoop) {
              break;
            }
            try {
              final size = await getAudioFileSize(audioId);

              if (size != null) {
                print("Size: $size");
                sizes.add(size);
                setState(() {});
                break;
              } else {
                print("Again");
                Fluttertoast.showToast(msg: "Again");
              }
            } catch (e) {
              Fluttertoast.showToast(msg: e.toString());
              print(e.toString());
            }
          }
        }
      }
      if (jumpIt) {
        jumpIt = false;
      } else {
        if (stopLoop) {
          break;
        }
        print(
            "len(sizes): ${sizes.length}  len(audios)${cm.courseIds.split(",").length}");
        await FirebaseFirestore.instance
            .collection("Courses")
            .doc(cm.courseId)
            .update(
              cm
                  .copyWith(
                    totalDuration: cm.totalDuration == 0 ? totalDuration : null,
                    audioSizes: sizes.length == cm.courseIds.split(",").length
                        ? sizes.join(",")
                        : cm.audioSizes,
                  )
                  .toOriginalMap(),
            );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopLoop = true;
  }

  // Future<void> getAudioFileSize(String audioUrl) async {}

  // Future<void> getDuration(String audioId, String msgIfErr) async {

  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  jumpIt = true;
                },
                child: const Text("Jump It"),
              ),
              ListTile(
                title: Text(currentCourse),
                subtitle: Text("Audio $i"),
                trailing: const Text("Updateing ..."),
              ),
              ListTile(
                title: Text("Wrong audios ${wrongurls.length}"),
                trailing: IconButton(
                  onPressed: () {
                    wrongurls = [];
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
              // SizedBox(
              //   height: 150,
              //   width: MediaQuery.of(context).size.width - 30,
              //   child: ListView.builder(
              //     itemCount: wrongurls.length,
              //     itemBuilder: (context, index) => Text(wrongurls[index]),
              //   ),
              // )
              // ...List.generate(
              //     wrongurls.length, (index) => Text(wrongurls[index]))
            ],
          ),
        ),
      ),
    );
  }
}
