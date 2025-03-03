import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Digital Links view product info'),
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
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: const [
                      _InfoExpansionTile(
                        title: 'Allergen Information',
                        children: ['Allergen details'],
                      ),
                      _InfoExpansionTile(
                        title: 'Has Retailers',
                        children: ['Retailer information'],
                      ),
                      _InfoExpansionTile(
                        title: 'Ingredients Information',
                        children: ['List of ingredients'],
                      ),
                      _InfoExpansionTile(
                        title: 'Instructions',
                        children: ['Usage instructions'],
                      ),
                      _InfoExpansionTile(
                        title: 'Packaging',
                        children: ['Packaging details'],
                      ),
                      _InfoExpansionTile(
                        title: 'Promotion',
                        children: ['Promotional information'],
                      ),
                      _InfoExpansionTile(
                        title: 'Recipe Info',
                        children: ['Recipe details'],
                      ),
                      _InfoExpansionTile(
                        title: 'Electronic Leaflets',
                        children: ['Digital documentation'],
                      ),
                      _InfoExpansionTile(
                        title: 'Images',
                        children: ['Product images'],
                      ),
                      _InfoExpansionTile(
                        title: 'Videos',
                        children: ['Product videos'],
                      ),
                    ],
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
}

class _InfoExpansionTile extends StatelessWidget {
  const _InfoExpansionTile({
    required this.title,
    required this.children,
  });

  final String title;
  final List<String> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: children
            .map((child) => ListTile(
                  title: Text(child),
                ))
            .toList(),
      ),
    );
  }
}
