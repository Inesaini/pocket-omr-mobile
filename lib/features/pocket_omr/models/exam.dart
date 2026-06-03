class StudentResult {
  final String firstName;
  final String lastName;
  final String studentId;
  final int score;
  final int maxScore;
  final double confidence;

  /// True when the grader was unsure of one or more answers (human review).
  final bool needsReview;

  /// 1-based question numbers flagged as uncertain.
  final List<int> flaggedQuestions;

  const StudentResult({
    required this.firstName,
    required this.lastName,
    required this.studentId,
    required this.score,
    required this.maxScore,
    required this.confidence,
    this.needsReview = false,
    this.flaggedQuestions = const [],
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();
  double get scoreRatio => maxScore == 0 ? 0 : score / maxScore;

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    return StudentResult(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      studentId: json['studentId'] ?? '',
      score: json['score'] ?? 0,
      maxScore: json['maxScore'] ?? 0,
      confidence: (json['confidence'] ?? 0).toDouble(),
      needsReview: json['needsReview'] ?? false,
      flaggedQuestions: (json['flaggedQuestions'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
    );
  }
}

class Exam {
  final String id;
  final String title;
  final int totalStudents;
  final int correctedCount;
  final double avgConfidence;
  final List<StudentResult> students;

  /// Sheets that failed segmentation on the most recent upload (empty otherwise).
  final List<FailedSheet> failedSheets;

  const Exam({
    required this.id,
    required this.title,
    required this.totalStudents,
    required this.correctedCount,
    required this.avgConfidence,
    this.students = const [],
    this.failedSheets = const [],
  });

  int get remaining => totalStudents - correctedCount;

  /// Students that have actually been graded (have a max score).
  List<StudentResult> get gradedStudents =>
      students.where((s) => s.maxScore > 0).toList();

  int get totalPoints =>
      gradedStudents.fold(0, (sum, s) => sum + s.score);
  int get totalMaxPoints =>
      gradedStudents.fold(0, (sum, s) => sum + s.maxScore);

  /// Average grade across graded students, as a 0..100 percentage.
  double get avgGradePercent =>
      totalMaxPoints == 0 ? 0 : totalPoints / totalMaxPoints * 100;

  /// Number of students the model flagged for review.
  int get reviewCount => students.where((s) => s.needsReview).length;

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      correctedCount: json['correctedCount'] ?? 0,
      avgConfidence: (json['avgConfidence'] ?? 0).toDouble(),
      students: (json['students'] as List<dynamic>?)
              ?.map((s) => StudentResult.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      failedSheets: (json['failedSheets'] as List<dynamic>?)
              ?.map((s) => FailedSheet.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// A scanned sheet the backend couldn't segment on the last upload (it was
/// neither stored nor graded, so it can be re-scanned and re-uploaded).
class FailedSheet {
  final String filename;
  final String reason;

  const FailedSheet({required this.filename, required this.reason});

  factory FailedSheet.fromJson(Map<String, dynamic> json) {
    return FailedSheet(
      filename: json['filename']?.toString() ?? '',
      reason: json['reason']?.toString() ?? 'could not be read',
    );
  }
}

class HistoryExam {
  final String id;
  final String title;
  final int pages;
  final DateTime date;
  final double avgScore;
  final double avgConfidence;
  final int pendingPages;
  final int totalPages;

  const HistoryExam({
    required this.id,
    required this.title,
    required this.pages,
    required this.date,
    required this.avgScore,
    required this.avgConfidence,
    required this.pendingPages,
    required this.totalPages,
  });

  /// Photos that have been processed (graded) so far.
  int get processedPages =>
      (totalPages - pendingPages).clamp(0, totalPages);

  /// Fraction of photos processed, 0..1.
  double get processedRatio =>
      totalPages == 0 ? 0 : processedPages / totalPages;

  factory HistoryExam.fromJson(Map<String, dynamic> json) {
    return HistoryExam(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      pages: json['pages'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      avgScore: (json['avgScore'] ?? 0).toDouble(),
      avgConfidence: (json['avgConfidence'] ?? 0).toDouble(),
      pendingPages: json['pendingPages'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
