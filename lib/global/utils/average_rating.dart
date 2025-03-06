import 'package:gtrack_nartec/models/IDENTIFY/GTIN/review_model.dart';

String averageRating(List<ReviewModel> reviews) {
  if (reviews.isEmpty) return '0';
  final totalRating = reviews.fold(0, (sum, review) => sum + review.rating!);
  final averageRating = totalRating / reviews.length;
  return averageRating.toStringAsFixed(1);
}
