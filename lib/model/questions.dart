class Question {
  final String id;
  final String question;
  final List<QuestionOption> options;
  final String answer;
  final String suggest;
  final List<String> images;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    required this.suggest,
    required this.images,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => QuestionOption.fromJson(e))
          .toList(),
      answer: json['answer'] ?? '',
      suggest: json['suggest'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "options": options.map((e) => e.toJson()).toList(),
      "answer": answer,
      "suggest": suggest,
      "images": images,
    };
  }
}

class QuestionOption {
  final String key;
  final String text;

  QuestionOption({
    required this.key,
    required this.text,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      key: json['key'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "text": text,
    };
  }
}
