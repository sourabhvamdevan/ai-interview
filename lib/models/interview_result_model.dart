class InterviewResult {
  final int score;
  final String feedback;
  final List<String> strengths;
  final List<String> weaknesses;

  InterviewResult({
    required this.score,
    required this.feedback,
    required this.strengths,
    required this.weaknesses,
  });

  factory InterviewResult.fromJson(Map<String, dynamic> json) {
    return InterviewResult(
      score: json['score'],
      feedback: json['feedback'],
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
    );
  }
}
