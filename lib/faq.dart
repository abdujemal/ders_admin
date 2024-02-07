// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Faq {
  final String question;
  final String answer;
  Faq({
    required this.question,
    required this.answer,
  });

  Faq copyWith({
    String? question,
    String? answer,
  }) {
    return Faq(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'answer': answer,
    };
  }

  factory Faq.fromMap(Map<String, dynamic> map) {
    return Faq(
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Faq.fromJson(String source) =>
      Faq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Faq(question: $question, answer: $answer)';

  @override
  bool operator ==(covariant Faq other) {
    if (identical(this, other)) return true;

    return other.question == question && other.answer == answer;
  }

  @override
  int get hashCode => question.hashCode ^ answer.hashCode;
}
