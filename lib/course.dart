import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Course {
  final String title;
  final String ustaz;
  final String category;
  final String courseIds;
  final String? courseId;
  final String pdfId;
  final String author;
  // final List<dynamic> preRequisit;
  final int noOfRecord;
  final int totalDuration;
  final String image;
  final String dateTime;
  final String? id;
  Course({
    this.id,
    required this.title,
    required this.ustaz,
    required this.category,
    required this.courseIds,
    required this.pdfId,
    required this.author,
    required this.image,
    required this.dateTime,
    required this.totalDuration,
    required this.courseId,
    // required this.preRequisit,
    required this.noOfRecord,
  });

  Course copyWith({
    String? title,
    String? ustaz,
    String? category,
    String? courseIds,
    String? pdfId,
    String? author,
    String? image,
    String? dateTime,
    int? noOfRecord,
    int? totalDuration,
    String? courseId,
    String? id,
  }) {
    return Course(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      ustaz: ustaz ?? this.ustaz,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      courseIds: courseIds ?? this.courseIds,
      pdfId: pdfId ?? this.pdfId,
      author: author ?? this.author,
      image: image ?? this.image,
      noOfRecord: noOfRecord ?? this.noOfRecord,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'ustaz': ustaz,
      'courseId': courseId,
      'category': category,
      'courseIds': courseIds,
      'pdfId': pdfId,
      'author': author,
      'image': image,
      'noOfRecord': noOfRecord,
      'dateTime': dateTime,
      'totalDuration': totalDuration,
    };
  }

  factory Course.fromMap(DocumentSnapshot documentSnapshot) {
    final map = documentSnapshot.data() as Map;
    return Course(
        id: documentSnapshot.id,
        courseId: map['courseId'],
        title: map['title'] as String,
        ustaz: map['ustaz'] as String,
        category: map['category'] as String,
        courseIds: map['courseIds'] as String,
        pdfId: map['pdfId'] as String,
        author: map['author'] as String,
        image: map['image'] as String,
        noOfRecord: map['noOfRecord'] as int,
        dateTime: map['dateTime'] as String,
        totalDuration: map['totalDuration'] ?? 0,
        );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Course(title: $title, ustaz: $ustaz, category: $category, courseIds: $courseIds, pdfId: $pdfId, author: $author, noOfRecord: $noOfRecord)';
  }

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.ustaz == ustaz &&
        other.category == category &&
        other.courseIds == courseIds &&
        other.pdfId == pdfId &&
        other.author == author &&
        other.noOfRecord == noOfRecord;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        ustaz.hashCode ^
        category.hashCode ^
        courseIds.hashCode ^
        pdfId.hashCode ^
        author.hashCode ^
        // preRequisit.hashCode ^
        noOfRecord.hashCode;
  }
}
