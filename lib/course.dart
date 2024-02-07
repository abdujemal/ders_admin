// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: annotate_overrides, overridden_fields

import 'dart:convert';

class Course {
  final String courseId;
  final String author;
  final int? id;
  final String category;
  final String courseIds;
  final String? audioSizes;
  final int noOfRecord;
  final String pdfId;
  final String title;
  final String ustaz;
  final String lastViewed;
  final int isFav;
  final int isStarted;
  final int isFinished;
  final int pausedAtAudioNum;
  final int pausedAtAudioSec;
  final int isScheduleOn;
  final double pdfPage;
  final double pdfNum;
  final String scheduleTime;
  final String scheduleDates;
  final String image;
  final int totalDuration;
  final int isCompleted;
  final int isBeginner;
  final String dateTime;

  const Course({
    required this.courseId,
    required this.author,
    this.id,
    required this.category,
    required this.courseIds,
    required this.audioSizes,
    required this.noOfRecord,
    required this.pdfId,
    required this.title,
    required this.ustaz,
    this.lastViewed = "",
    this.isFav = 0,
    this.isStarted = 0,
    this.isFinished = 0,
    this.pausedAtAudioNum = 0,
    this.pausedAtAudioSec = 0,
    this.scheduleDates = "",
    this.scheduleTime = "",
    this.isScheduleOn = 0,
    this.pdfPage = 0,
    this.pdfNum = 1,
    this.isBeginner = 0,
    required this.dateTime,
    required this.image,
    required this.totalDuration,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      "audioSizes": audioSizes,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
      'image': image,
      'lastViewed': lastViewed,
      'isFav': isFav,
      'isStarted': isStarted,
      'isFinished': isFinished,
      'pausedAtAudioNum': pausedAtAudioNum,
      'pausedAtAudioSec': pausedAtAudioSec,
      "scheduleDates": scheduleDates,
      "scheduleTime": scheduleTime,
      'isScheduleOn': isScheduleOn,
      'pdfPage': pdfPage,
      'pdfNum': pdfNum,
      'totalDuration': totalDuration,
      "isCompleted": isCompleted,
      'dateTime': dateTime,
      'isBeginner': isBeginner,
    };
  }

  Map<String, dynamic> toOriginalMap() {
    return {
      'courseId': courseId,
      'author': author,
      'category': category,
      'courseIds': courseIds,
      'audioSizes': audioSizes,
      'noOfRecord': noOfRecord,
      'pdfId': pdfId,
      'title': title,
      'ustaz': ustaz,
      'image': image,
      'totalDuration': totalDuration,
      "isCompleted": isCompleted,
      'dateTime': dateTime,
    };
  }

  factory Course.fromMap(Map map, String id, {Course? copyFrom}) {
    return Course(
      courseId: id,
      id: map['id'] ?? (copyFrom?.id),
      author: map['author'] as String,
      category: map['category'] as String,
      courseIds: map['courseIds'] as String,
      audioSizes: map['audioSizes'],
      noOfRecord: map['noOfRecord'] as int,
      pdfId: map['pdfId'] as String,
      title: map['title'] as String,
      ustaz: map['ustaz'] as String,
      lastViewed:
          map['lastViewed'] ?? (copyFrom != null ? copyFrom.lastViewed : ""),
      isFav: map['isFav'] ?? (copyFrom != null ? copyFrom.isFav : 0),
      isStarted:
          map['isStarted'] ?? (copyFrom != null ? copyFrom.isStarted : 0),
      isFinished:
          map['isFinished'] ?? (copyFrom != null ? copyFrom.isFinished : 0),
      pausedAtAudioNum: map['pausedAtAudioNum'] ??
          (copyFrom != null ? copyFrom.pausedAtAudioNum : 0),
      pausedAtAudioSec: map['pausedAtAudioSec'] ??
          (copyFrom != null ? copyFrom.pausedAtAudioSec : 0),
      scheduleDates: map['scheduleDates'] ??
          (copyFrom != null ? copyFrom.scheduleDates : ""),
      scheduleTime: map['scheduleTime'] ??
          (copyFrom != null ? copyFrom.scheduleTime : ""),
      isScheduleOn:
          map['isScheduleOn'] ?? (copyFrom != null ? copyFrom.isScheduleOn : 0),
      pdfPage: map['pdfPage'] ?? (copyFrom != null ? copyFrom.pdfPage : 0.0),
      pdfNum: map['pdfNum'] ?? (copyFrom != null ? copyFrom.pdfNum : 1),
      image: map['image'],
      isBeginner: map['isBeginner'] == null
          ? 0
          : map['isBeginner']
              ? 1
              : 0,
      totalDuration: map["totalDuration"] ?? 0,
      isCompleted: map['isCompleted'] ?? 1,
      dateTime: map['dateTime'] as String,
    );
  }

  Course copyWith(
      {String? courseId,
      String? author,
      int? id,
      String? category,
      String? courseIds,
      int? noOfRecord,
      String? pdfId,
      String? title,
      String? ustaz,
      String? lastViewed,
      int? isFav,
      int? isStarted,
      int? isFinished,
      int? pausedAtAudioNum,
      int? pausedAtAudioSec,
      int? isScheduleOn,
      String? scheduleDates,
      String? scheduleTime,
      double? pdfPage,
      double? pdfNum,
      String? image,
      String? audioSizes,
      int? isCompleted,
      String? dateTime,
      int? totalDuration}) {
    return Course(
      courseId: courseId ?? this.courseId,
      author: author ?? this.author,
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      courseIds: courseIds ?? this.courseIds,
      audioSizes: audioSizes ?? this.audioSizes,
      noOfRecord: noOfRecord ?? this.noOfRecord,
      pdfId: pdfId ?? this.pdfId,
      title: title ?? this.title,
      ustaz: ustaz ?? this.ustaz,
      lastViewed: lastViewed ?? this.lastViewed,
      isFav: isFav ?? this.isFav,
      isStarted: isStarted ?? this.isStarted,
      isFinished: isFinished ?? this.isFinished,
      pausedAtAudioNum: pausedAtAudioNum ?? this.pausedAtAudioNum,
      pausedAtAudioSec: pausedAtAudioSec ?? this.pausedAtAudioSec,
      scheduleDates: scheduleDates ?? this.scheduleDates,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      isScheduleOn: isScheduleOn ?? this.isScheduleOn,
      pdfPage: pdfPage ?? this.pdfPage,
      pdfNum: pdfNum ?? this.pdfNum,
      image: image ?? this.image,
      totalDuration: totalDuration ?? this.totalDuration,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  String toJsonString() => json.encode(toMap());

  Course fromJsonString(String jsn, String id) =>
      Course.fromMap(json.decode(jsn), id);
}
