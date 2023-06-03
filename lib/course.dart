import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Course {
  final String title;
  final String ustaz;
  final String category;
  final String courseLink;
  final String pdfLink;
  final String author;
  final List<dynamic> preRequisit;
  final int noOfRecord;
  
  Course({
    required this.author, 
    required this.title,
    required this.ustaz,
    required this.category,
    required this.courseLink,
    required this.pdfLink,
    required this.preRequisit,
    required this.noOfRecord,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'ustaz': ustaz,
      'category': category,
      'courseLink': courseLink,
      'pdfLink': pdfLink,
      'author': author,
      'preRequisit': preRequisit,
      'noOfRecord': noOfRecord,
    };
  }

  factory Course.fromMap(Map<dynamic, dynamic> map) {
    return Course(
      title: map['title'] as String,
      ustaz: map['ustaz'] as String,
      category: map['category'] as String,
      courseLink: map['courseLink'] as String,
      pdfLink: map['pdfLink'] as String,
      author: map['author'] as String,
      preRequisit: List<dynamic>.from(map['preRequisit'] as List<dynamic>),
      noOfRecord: map['noOfRecord'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source) as Map<String, dynamic>);
}
