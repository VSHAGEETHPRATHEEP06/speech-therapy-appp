class Exercise {
  final String id;
  final String title;
  final String description;
  final String referenceAudio; // Path to reference audio file
  final String referenceVideo; // Path to reference video file

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.referenceAudio,
    required this.referenceVideo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'referenceAudio': referenceAudio,
      'referenceVideo': referenceVideo,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      referenceAudio: json['referenceAudio'],
      referenceVideo: json['referenceVideo'],
    );
  }
}
