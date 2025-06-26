// ignore_for_file: deprecated_member_use, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/utils/average_rating.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/card/gtin_card.dart';
import 'package:gtrack_nartec/global/widgets/pdf/pdf_viewer.dart';
import 'package:gtrack_nartec/global/widgets/video/video_player_widget.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/digital_link_view_reviews_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/allergen_tab.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/image_info_tab.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/nutrition_facts_tab.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/packaging_info_tab.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/recipe_info_tab.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/leaflet_info_tab.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/widget/review_info_tab.dart';

class DigitalLinkViewDataScreen extends StatefulWidget {
  const DigitalLinkViewDataScreen(
      {super.key, required this.barcode, required this.gtin});
  final String barcode;
  final GTIN_Model gtin;

  @override
  State<DigitalLinkViewDataScreen> createState() =>
      _DigitalLinkViewDataScreenState();
}

class _DigitalLinkViewDataScreenState extends State<DigitalLinkViewDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GtinCubit gtinCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    gtinCubit = GtinCubit.get(context);
    // Updated to call with page 1 and limit 100 by default
    gtinCubit.getDigitalLinkViewData(widget.barcode);
    gtinCubit.getReviews(widget.barcode);
    gtinCubit.getRetailersInformation(widget.barcode);
    gtinCubit.getNutritionFacts(widget.barcode);
    gtinCubit.getAllergenInformation(widget.barcode);
    gtinCubit.getPackagingInformation(widget.barcode);
    gtinCubit.getPromotionalOffers(widget.barcode);
    gtinCubit.getRecipes(widget.barcode);
    gtinCubit.getImages(widget.barcode);
    gtinCubit.getLeafletInformation(widget.barcode);
    gtinCubit.getVideoInformation(widget.barcode);
    gtinCubit.getReviewsInformation(widget.barcode);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: BlocBuilder<GtinCubit, GtinState>(
        bloc: gtinCubit,
        builder: (context, state) {
          return Column(
            children: [
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.skyBlue,
                  unselectedLabelColor: AppColors.grey,
                  indicatorColor: AppColors.skyBlue,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Details'),
                    Tab(text: 'Sustainability'),
                  ],
                ),
              ),

              // Tab Bar View Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Overview Tab
                    _buildOverviewTab(),

                    // Details Tab
                    _buildDetailsTab(),

                    // Sustainability Tab
                    _buildSustainabilityTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Product Hero Section
          GtinProductCard(product: widget.gtin),

          // Quick Info Cards
          _buildQuickInfoCards(),

          // Reviews Section
          _buildReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _infoCard(
          'Allergens',
          '${gtinCubit.allergens.length} items',
          Icons.warning_amber_rounded,
          AppColors.gold,
        ),
        _infoCard(
          'Ingredients',
          '${gtinCubit.ingredients.length} items',
          Icons.list_alt,
          AppColors.green,
        ),
        _infoCard(
          'Images',
          '${gtinCubit.images.length}',
          Icons.image,
          AppColors.danger,
        ),
        _infoCard(
          'Videos',
          '${gtinCubit.videos.length}',
          Icons.video_collection,
          AppColors.skyBlue,
        ),
      ],
    );
  }

  Widget _infoCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      averageRating(gtinCubit.reviews),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${gtinCubit.reviews.length})',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButtonWidget(
                text: "View All Reviews",
                backgroundColor: AppColors.skyBlue,
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: DigitalLinkViewReviewsScreen(gtin: widget.gtin),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoExpansionTile(
          title: 'Allergen Information',
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.gold,
          child: buildAllergenInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Nutrition Facts',
          icon: Icons.restaurant_menu,
          iconColor: Colors.orange,
          child: buildNutritionFactsInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Has Retailers',
          icon: Icons.store,
          iconColor: AppColors.skyBlue,
          child: buildRetailerInformation(context),
        ),
        // _InfoExpansionTile(
        //   title: 'Ingredients Information',
        //   icon: Icons.list_alt,
        //   iconColor: AppColors.green,
        //   child: buildIngredientInformation(context),
        // ),
        _InfoExpansionTile(
          title: 'Instructions',
          icon: Icons.info_outline,
          iconColor: Colors.purple,
          child: buildInstructionInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Packaging',
          icon: Icons.inventory_2_outlined,
          iconColor: Colors.brown,
          child: buildPackagingInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Promotion',
          icon: Icons.local_offer_outlined,
          iconColor: AppColors.danger,
          child: buildPromotionalInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Recipe Info',
          icon: Icons.restaurant_menu,
          iconColor: AppColors.gold,
          child: buildRecipeInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Electronic Leaflets',
          icon: Icons.description_outlined,
          iconColor: Colors.teal,
          child: buildLeafletInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Images',
          icon: Icons.image_outlined,
          iconColor: Colors.indigo,
          child: buildImageInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Videos',
          icon: Icons.videocam_outlined,
          iconColor: Colors.deepOrange,
          child: buildVideoInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Reviews',
          icon: Icons.star_outline,
          iconColor: AppColors.gold,
          child: buildReviewsInformation(context),
        ),
      ],
    );
  }

  Widget buildReviewsInformation(BuildContext context) {
    return BlocBuilder<GtinCubit, GtinState>(
      bloc: gtinCubit,
      builder: (context, state) {
        if (gtinCubit.reviews.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No reviews available',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: gtinCubit.reviews
              .map((review) => ReviewCard(review: review))
              .toList(),
        );
      },
    );
  }

  Widget _buildSustainabilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.eco,
                    color: AppColors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sustainability Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Environmental Impact Section
              const Text(
                'Environmental Impact:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint('100% Recyclable Packaging'),
              _buildBulletPoint('Reduced Carbon Footprint Initiative'),
              _buildBulletPoint('Sustainable Sourcing Practices'),
              const SizedBox(height: 24),

              // Recycling Information Section
              const Text(
                'Recycling Information:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint('Please recycle aluminum can'),
              _buildBulletPoint('Check local recycling guidelines'),
              const SizedBox(height: 24),

              // Sustainability Goals Section
              const Text(
                'Sustainability Goals:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint('30% reduction in water usage by 2025'),
              _buildBulletPoint('100% renewable energy in production by 2026'),
              _buildBulletPoint('Zero waste to landfill by 2027'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNutritionFactsInformation(BuildContext context) {
    return BlocBuilder<GtinCubit, GtinState>(
      bloc: gtinCubit,
      builder: (context, state) {
        if (state is GtinNutritionFactsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return NutritionFactsTab(nutritionFacts: gtinCubit.nutritionFacts);
      },
    );
  }

  // Widget buildIngredientInformation(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: gtinCubit.ingredients.length,
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         itemBuilder: (context, index) {
  //           final ingredient = gtinCubit.ingredients[index];
  //           return Container(
  //             padding: const EdgeInsets.all(16),
  //             margin: const EdgeInsets.symmetric(vertical: 8),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(12),
  //               color: AppColors.white,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: AppColors.grey.withValues(alpha: 0.1),
  //                   spreadRadius: 1,
  //                   blurRadius: 4,
  //                   offset: const Offset(0, 2),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Product Name: ${ingredient.productName}',
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 // Ingredient Details Section
  //                 const Text(
  //                   'Ingredient Details:',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 _ingredientDetailRow('Name', ingredient.ingredient),
  //                 _ingredientDetailRow(
  //                     'Quantity', '${ingredient.quantity}.${ingredient.unit}'),
  //                 _ingredientDetailRow('Lot Number', ingredient.lotNumber),
  //                 const SizedBox(height: 20),
  //                 // Dates Section
  //                 const Text(
  //                   'Dates:',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.calendar_today,
  //                         size: 16, color: Colors.blue),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       'Production Date: ${_formatDate(ingredient.productionDate)}',
  //                       style: const TextStyle(color: Colors.black87),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.event_busy,
  //                         size: 16, color: AppColors.danger),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       'Expiration Date: ${_formatDate(ingredient.expirationDate)}',
  //                       style: const TextStyle(color: Colors.black87),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //                 // Additional Information Section
  //                 const Text(
  //                   'Additional Information:',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.language, size: 16, color: Colors.grey),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       'Domain: ${ingredient.domainName}',
  //                       style: const TextStyle(color: Colors.black87),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.update, size: 16, color: Colors.grey),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       'Last Updated: ${_formatDate(ingredient.updatedAt)}',
  //                       style: const TextStyle(
  //                         color: Colors.black87,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _ingredientDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 100,
  //           child: Text(
  //             label,
  //             style: const TextStyle(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: const TextStyle(color: Colors.black87),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // String _formatDate(DateTime date) {
  //   return "${date.month}/${date.day}/${date.year}";
  // }

  Widget buildAllergenInformation(BuildContext context) {
    return AllergenTab(allergens: gtinCubit.allergens);
  }

  Widget buildRetailerInformation(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gtinCubit.retailers.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final retailer = gtinCubit.retailers[index];

            // display images
            return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "${AppUrls.upcHub}/${retailer.logo.toString().replaceAll("public", "")}",
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.contain,
                ));
          },
        ),
      ],
    );
  }

  Widget buildPackagingInformation(BuildContext context) {
    return BlocBuilder<GtinCubit, GtinState>(
      bloc: gtinCubit,
      builder: (context, state) {
        if (state is GetPackagingInformationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return PackagingInfoTab(packagingInfo: gtinCubit.packagings);
      },
    );
  }

  Widget buildPromotionalInformation(BuildContext context) {
    return GridView.builder(
      itemCount: gtinCubit.promotions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final promotion = gtinCubit.promotions[index];
        final logoUrl =
            "${AppUrls.upcHub}/${promotion.logo.toString().replaceAll("public", "")}";
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CachedNetworkImage(
            imageUrl: logoUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget buildRecipeInformation(BuildContext context) {
    return BlocBuilder<GtinCubit, GtinState>(
      bloc: gtinCubit,
      builder: (context, state) {
        if (state is GetRecipeInformationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RecipeInfoTab(recipeInfo: gtinCubit.recipes);
      },
    );
  }

  Widget buildLeafletInformation(BuildContext context) {
    return LeafletInfoTab(leafletInfo: gtinCubit.leaflets);
  }

  Widget buildImageInformation(BuildContext context) {
    return ImageInfoTab(imageInfo: gtinCubit.images);
  }

  Widget buildInstructionInformation(BuildContext context) {
    return BlocBuilder<GtinCubit, GtinState>(
      builder: (context, state) {
        if (state is GtinDigitalLinkViewDataLoadedState) {
          if (state.instructions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No instructions available',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.instructions.length,
            itemBuilder: (context, index) {
              final instruction = state.instructions[index];
              return Card(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            instruction.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Additional Information Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Additional Information:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Created:',
                            formatDate(instruction.createdAt),
                          ),
                          _buildInfoRow(
                            Icons.update,
                            'Last Updated:',
                            formatDate(instruction.updatedAt),
                          ),
                          _buildInfoRow(
                            Icons.business,
                            'Brand Owner ID:',
                            instruction.brandOwnerId,
                          ),
                        ],
                      ),
                    ),

                    // PDF Document Section
                    if (instruction.pdfDoc.isNotEmpty) ...[
                      PdfViewer(
                        path: "${AppUrls.upcHub}/${instruction.pdfDoc}"
                            .replaceAll("\\", "/"),
                      )
                    ],
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVideoInformation(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gtinCubit.videos.length,
      itemBuilder: (context, index) {
        final video = gtinCubit.videos[index];
        return Card(
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
                ),
                child: VideoPlayerWidget(
                  url:
                      "${AppUrls.upcHub}/${video.videos.toString().replaceAll("public", "")}",
                ),
              ),

              // Video Information
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Created:',
                      formatDate(DateTime.parse(video.createdAt ?? "")),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.update,
                      'Last Updated:',
                      formatDate(
                        DateTime.parse(video.updatedAt ?? ""),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.business,
                      'Brand Owner ID:',
                      video.brandOwnerId ?? "",
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.domain,
                      'Domain:',
                      video.domainName ?? "",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${_getMonth(date.month)} ${date.year}";
  }

  String _getMonth(int month) {
    const months = [
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
    return months[month - 1];
  }
}

class _InfoExpansionTile extends StatelessWidget {
  const _InfoExpansionTile({
    required this.title,
    required this.child,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final Widget child;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        backgroundColor: AppColors.white,
        collapsedBackgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon, color: iconColor, size: 20),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [child],
      ),
    );
  }
}
