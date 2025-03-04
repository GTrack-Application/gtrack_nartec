import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/digital_link_view_reviews_screen.dart';

class DigitalLinkViewDataScreen extends StatefulWidget {
  const DigitalLinkViewDataScreen({super.key, required this.barcode});
  final String barcode;

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
    _tabController = TabController(length: 4, vsync: this);
    gtinCubit = GtinCubit.get(context);
    gtinCubit.getDigitalLinkViewData(widget.barcode);
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
        title: const Text('Digital Links View Product Info'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image and Info Card
            Card(
              color: AppColors.white,
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Verified Badge
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOB9XBRhgoFm4-tIWZDhS3GedlETu8JP20KA&s',
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Chip(
                          label: Text(
                            'Verified',
                            style: TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: Colors.green,
                          avatar: Icon(Icons.verified, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alkozay Cola',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Cola Regular 250Ml Can,\nCarbonated Drinks',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'GTIN: ${widget.barcode}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Product Reviews Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              AppNavigator.goToPage(
                                context: context,
                                screen: const DigitalLinkViewReviewsScreen(),
                              );
                            },
                            icon: const Icon(Icons.star),
                            label: const Text('Product Reviews (3)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.skyBlue,
                tabs: const [
                  Tab(text: 'Product Information'),
                  Tab(text: 'Recall Information'),
                  Tab(text: 'Certification'),
                  Tab(text: 'Sustainability'),
                ],
              ),
            ),

            // Tab Bar View Content
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  400, // Adjust height as needed
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Product Information Tab
                  BlocConsumer<GtinCubit, GtinState>(
                    bloc: gtinCubit,
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is GtinDigitalLinkViewDataLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          _InfoExpansionTile(
                            title: 'Allergen Information',
                            child: buildAllergenInformation(context),
                          ),
                          _InfoExpansionTile(
                            title: 'Has Retailers',
                            child: Text('Retailer information'),
                          ),
                          _InfoExpansionTile(
                            title: 'Ingredients Information',
                            child: Text('List of ingredients'),
                          ),
                          _InfoExpansionTile(
                            title: 'Instructions',
                            child: Text('Usage instructions'),
                          ),
                          _InfoExpansionTile(
                            title: 'Packaging',
                            child: Text('Packaging details'),
                          ),
                          _InfoExpansionTile(
                            title: 'Promotion',
                            child: Text('Promotional information'),
                          ),
                          _InfoExpansionTile(
                            title: 'Recipe Info',
                            child: Text('Recipe details'),
                          ),
                          _InfoExpansionTile(
                            title: 'Electronic Leaflets',
                            child: Text('Digital documentation'),
                          ),
                          _InfoExpansionTile(
                            title: 'Images',
                            child: Text('Product images'),
                          ),
                          _InfoExpansionTile(
                            title: 'Videos',
                            child: Text('Product videos'),
                          ),
                        ],
                      );
                    },
                  ),

                  // Recall Information Tab
                  const Center(
                    child: Text('Recall Information Content'),
                  ),

                  // Certification Tab
                  const Center(
                    child: Text('Certification Content'),
                  ),

                  // Sustainability Tab
                  const Center(
                    child: Text('Sustainability Content'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildAllergenInformation(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: gtinCubit.allergens.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final allergen = gtinCubit.allergens[index];
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey),
              ),
              child: Column(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Name: ${allergen.productName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Allergen Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.skyBlue,
                    ),
                  ),
                  Text("Name: ${allergen.allergenName}"),
                  Text("Type: ${allergen.allergenType}"),
                  Text("Severity: ${allergen.severity}"),
                  Text("Source: ${allergen.allergenSource}"),
                  const SizedBox(height: 8),
                  Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.skyBlue,
                    ),
                  ),
                  Text(
                    "Contains Allergen: ${allergen.containsAllergen ? "Yes" : "No"}",
                  ),
                  Text(
                    "May Contains: ${allergen.mayContain ? "Yes" : "No"}",
                  ),
                  Text(
                    "Cross Contamination Risk: ${allergen.crossContaminationRisk ? "Yes" : "No"}",
                  ),
                ],
              ),
            );
          },
        ),
        if (gtinCubit.hasMoreAllergens)
          ElevatedButton(
            onPressed: () {
              context.read<GtinCubit>().loadMoreAllergens(widget.barcode);
            },
            child: const Text('Load More'),
          ),
      ],
    );
  }
}

class _InfoExpansionTile extends StatelessWidget {
  const _InfoExpansionTile({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        backgroundColor: AppColors.white,
        collapsedBackgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [child],
      ),
    );
  }
}
