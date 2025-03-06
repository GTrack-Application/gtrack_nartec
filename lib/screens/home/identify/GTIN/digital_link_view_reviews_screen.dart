import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';

class DigitalLinkViewReviewsScreen extends StatefulWidget {
  final GTIN_Model gtin;

  const DigitalLinkViewReviewsScreen({
    super.key,
    required this.gtin,
  });

  @override
  State<DigitalLinkViewReviewsScreen> createState() =>
      _DigitalLinkViewReviewsScreenState();
}

class _DigitalLinkViewReviewsScreenState
    extends State<DigitalLinkViewReviewsScreen> {
  double _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  late GtinCubit _gtinCubit;

  @override
  void initState() {
    super.initState();
    _gtinCubit = GtinCubit.get(context);
    _gtinCubit.getReviews(widget.gtin.barcode ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_selectedRating == 0) {
      AppSnackbars.warning(context, 'Please select a rating');
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      AppSnackbars.warning(context, 'Please add a comment');
      return;
    }

    _gtinCubit.submitReview(
      barcode: widget.gtin.barcode ?? '',
      rating: _selectedRating.toInt(),
      comment: _commentController.text,
      productDescription: widget.gtin.productnameenglish ?? '',
      brandName: widget.gtin.brandName ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write your Rating & Review'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: BlocListener<GtinCubit, GtinState>(
        listener: (context, state) {
          if (state is GtinReviewSubmittedState) {
            // Show success message
            AppSnackbars.success(context, 'Review submitted successfully!');
            // Clear form
            _selectedRating = 0;
            _commentController.clear();
          } else if (state is GtinReviewErrorState) {
            // Show error message
            AppSnackbars.danger(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GtinCubit, GtinState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rating Stars
                  const Text(
                    'Rate this product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Star Rating using flutter_rating_bar
                  RatingBar.builder(
                    initialRating: _selectedRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 40,
                    unratedColor: AppColors.grey.withAlpha(50),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: AppColors.skyBlue,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _selectedRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Comments Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Write your Comments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: TextField(
                      controller: _commentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Write your Comments',
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  BlocBuilder<GtinCubit, GtinState>(
                    builder: (context, state) {
                      final isLoading = state is GtinReviewSubmittingState;

                      return PrimaryButtonWidget(
                        text: 'Submit',
                        onPressed: _submitReview,
                        backgroungColor: _selectedRating > 0
                            ? AppColors.skyBlue
                            : AppColors.grey.withAlpha(50),
                        isLoading: isLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Customer Reviews Section
                  BlocBuilder<GtinCubit, GtinState>(
                    builder: (context, state) {
                      final reviews = _gtinCubit.reviews;
                      if (reviews.isEmpty) {
                        return const Center(
                          child:
                              Text('No reviews yet. Be the first to review!'),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Reviews (${reviews.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...reviews
                              .map((review) => Column(
                                    children: [
                                      _ReviewItem(
                                        name: review.productId ?? 'Anonymous',
                                        rating: review.rating ?? 0,
                                        comment:
                                            review.comments ?? 'No comment',
                                        date: review.createdAt != null
                                            ? _formatDate(DateTime.parse(
                                                review.createdAt!))
                                            : 'Recent',
                                        isBuyer: true,
                                      ),
                                      const Divider(),
                                    ],
                                  ))
                              .toList(),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String date;
  final bool isBuyer;

  const _ReviewItem({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
    required this.isBuyer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RatingBarIndicator(
                  rating: rating.toDouble(),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 16,
                  unratedColor: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Text(comment),
                const SizedBox(height: 8),
                if (isBuyer)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Verified Buyer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
