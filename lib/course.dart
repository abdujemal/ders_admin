import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Course {
  final String title;
  final String ustaz;
  final String category;
  final String courseIds;
  final String pdfId;
  final String author;
  // final List<dynamic> preRequisit;
  final int noOfRecord;
  Course({
    required this.title,
    required this.ustaz,
    required this.category,
    required this.courseIds,
    required this.pdfId,
    required this.author,
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
    // List<dynamic>? preRequisit,
    int? noOfRecord,
  }) {
    return Course(
      title: title ?? this.title,
      ustaz: ustaz ?? this.ustaz,
      category: category ?? this.category,
      courseIds: courseIds ?? this.courseIds,
      pdfId: pdfId ?? this.pdfId,
      author: author ?? this.author,
      // preRequisit: preRequisit ?? this.preRequisit,
      noOfRecord: noOfRecord ?? this.noOfRecord,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'ustaz': ustaz,
      'category': category,
      'courseIds': courseIds,
      'pdfId': pdfId,
      'author': author,
      // 'preRequisit': preRequisit,
      'noOfRecord': noOfRecord,
    };
  }

  factory Course.fromMap(Map<dynamic, dynamic> map) {
    return Course(
      title: map['title'] as String,
      ustaz: map['ustaz'] as String,
      category: map['category'] as String,
      courseIds: map['courseIds'] as String,
      pdfId: map['pdfId'] as String,
      author: map['author'] as String,
      // preRequisit: List<dynamic>.from((map['preRequisit'] as List<dynamic>)),
      noOfRecord: map['noOfRecord'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Course(title: $title, ustaz: $ustaz, category: $category, courseIds: $courseIds, pdfId: $pdfId, author: $author, noOfRecord: $noOfRecord)';
  }

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.ustaz == ustaz &&
      other.category == category &&
      other.courseIds == courseIds &&
      other.pdfId == pdfId &&
      other.author == author &&
      // listEquals(other.preRequisit, preRequisit) &&
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
