/// A single skincare ingredient recommendation derived from the user's
/// most recent skin-analysis results. Purely a data holder; generation
/// logic lives in the personalized-recommendations screen.
class RecommendationItem {
  final String ingredient;
  final String targets;
  final int matchScore;

  /// One of: `Morning`, `Evening`, `Morning & Evening`, `Weekly`.
  final String routine;
  final List<String> benefits;

  /// Optional human-readable reason shown in the "Why?" bottom sheet.
  final String? reason;

  const RecommendationItem({
    required this.ingredient,
    required this.targets,
    required this.matchScore,
    required this.routine,
    required this.benefits,
    this.reason,
  });

  bool get isMorning =>
      routine == 'Morning' || routine == 'Morning & Evening';
  bool get isEvening =>
      routine == 'Evening' || routine == 'Morning & Evening';
  bool get isWeekly => routine == 'Weekly';
}
