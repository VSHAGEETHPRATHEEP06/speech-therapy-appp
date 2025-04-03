class Progress {
  final String userId;
  final String exerciseId;
  final DateTime date;
  final double score;

  Progress({
    required this.userId,
    required this.exerciseId,
    required this.date,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'exerciseId': exerciseId,
      'date': date.toIso8601String(),
      'score': score,
    };
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      userId: json['userId'],
      exerciseId: json['exerciseId'],
      date: DateTime.parse(json['date']),
      score: json['score'],
    );
  }
}
