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
        title: const Text('Product Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.skyBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: BlocConsumer<GtinCubit, GtinState>(
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

          return Column(
            children: [
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
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
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.skyBlue,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Details'),
                    Tab(text: 'Certification'),
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

                    // Certification Tab
                    _buildCertificationTab(),

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
        children: [
          // Product Hero Section
          _buildProductHeroSection(),

          const SizedBox(height: 24),

          // Quick Info Cards
          _buildQuickInfoCards(),

          const SizedBox(height: 24),

          // Product Description
          _buildProductDescription(),

          const SizedBox(height: 24),

          // Reviews Section
          _buildReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildProductHeroSection() {
    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Verified Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOB9XBRhgoFm4-tIWZDhS3GedlETu8JP20KA&s',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 16,
                right: 16,
                child: Chip(
                  label: Text(
                    'Verified',
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.green,
                  avatar: Icon(Icons.verified, color: Colors.white, size: 18),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Alkozay Cola',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.skyBlue.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.barcode,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.skyBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cola Regular 250Ml Can, Carbonated Drinks',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Origin: United Arab Emirates',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: AppColors.danger),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        _infoCard('Allergens', '${gtinCubit.allergens.length} items',
            Icons.warning_amber_rounded, Colors.orange),
        _infoCard('Ingredients', '${gtinCubit.ingredients.length} items',
            Icons.list_alt, AppColors.green),
        _infoCard('Nutrition', 'Per 100ml', Icons.restaurant, AppColors.danger),
        _infoCard('Storage', 'Keep cool', Icons.ac_unit, Colors.blue),
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

  Widget _buildProductDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Alkozay Cola is a refreshing carbonated drink with a classic cola taste. Perfect for any occasion, this 250ml can provides a convenient serving size for on-the-go refreshment.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Card(
      elevation: 2,
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
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      '4.2',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(3)',
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
            ElevatedButton(
              onPressed: () {
                AppNavigator.goToPage(
                  context: context,
                  screen: const DigitalLinkViewReviewsScreen(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View All Reviews'),
            ),
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
          iconColor: Colors.orange,
          child: buildAllergenInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Retailers',
          icon: Icons.store,
          iconColor: Colors.blue,
          child: buildRetailerInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Ingredients Information',
          icon: Icons.restaurant_menu,
          iconColor: AppColors.green,
          child: buildIngredientInformation(context),
        ),
        _InfoExpansionTile(
          title: 'Instructions',
          icon: Icons.info_outline,
          iconColor: Colors.purple,
          child: const Text('Usage instructions'),
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
          child: const Text('Promotional information'),
        ),
        _InfoExpansionTile(
          title: 'Recipe Info',
          icon: Icons.restaurant_menu,
          iconColor: Colors.amber,
          child: const Text('Recipe details'),
        ),
        _InfoExpansionTile(
          title: 'Electronic Leaflets',
          icon: Icons.description_outlined,
          iconColor: Colors.teal,
          child: const Text('Digital documentation'),
        ),
        _InfoExpansionTile(
          title: 'Images',
          icon: Icons.image_outlined,
          iconColor: Colors.indigo,
          child: const Text('Product images'),
        ),
        _InfoExpansionTile(
          title: 'Videos',
          icon: Icons.videocam_outlined,
          iconColor: Colors.deepOrange,
          child: const Text('Product videos'),
        ),
      ],
    );
  }

  Widget _buildCertificationTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Certification Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No certification data available',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Sustainability Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No sustainability data available',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIngredientInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gtinCubit.ingredients.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final ingredient = gtinCubit.ingredients[index];
            return Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Name: ${ingredient.productName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Ingredient Details Section
                  const Text(
                    'Ingredient Details:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ingredientDetailRow('Name', ingredient.ingredient),
                  _ingredientDetailRow(
                      'Quantity', '${ingredient.quantity}.${ingredient.unit}'),
                  _ingredientDetailRow('Lot Number', ingredient.lotNumber),
                  const SizedBox(height: 20),
                  // Dates Section
                  const Text(
                    'Dates:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Production Date: ${_formatDate(ingredient.productionDate)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.event_busy,
                          size: 16, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Text(
                        'Expiration Date: ${_formatDate(ingredient.expirationDate)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Additional Information Section
                  const Text(
                    'Additional Information:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.language, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Domain: ${ingredient.domainName}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.update, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Last Updated: ${_formatDate(ingredient.updatedAt)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        if (gtinCubit.hasMoreIngredients)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                gtinCubit.loadMoreData(widget.barcode);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Load More'),
            ),
          ),
      ],
    );
  }

  Widget _ingredientDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  Column buildAllergenInformation(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gtinCubit.allergens.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final allergen = gtinCubit.allergens[index];
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Name: ${allergen.productName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.skyBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Allergen Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.skyBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _allergenDetailRow("Name", allergen.allergenName),
                        _allergenDetailRow("Type", allergen.allergenType),
                        _allergenDetailRow("Severity", allergen.severity),
                        _allergenDetailRow("Source", allergen.allergenSource),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _allergenStatusRow(
                          "Contains Allergen",
                          allergen.containsAllergen,
                        ),
                        _allergenStatusRow(
                          "May Contains",
                          allergen.mayContain,
                        ),
                        _allergenStatusRow(
                          "Cross Contamination Risk",
                          allergen.crossContaminationRisk,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (gtinCubit.hasMoreAllergens)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<GtinCubit>()
                    .getDigitalLinkViewData(widget.barcode);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Load More'),
            ),
          ),
      ],
    );
  }

  Widget _allergenDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allergenStatusRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? AppColors.green : AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            value ? "Yes" : "No",
            style: TextStyle(
              color: value ? AppColors.green : AppColors.danger,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRetailerInformation(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gtinCubit.retailers.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final retailer = gtinCubit.retailers[index];
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Information Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.skyBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Store Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.skyBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _retailerDetailRow("Store Name", retailer.storeName),
                        _retailerDetailRow("Store ID", retailer.storeId),
                        _retailerDetailRow("Store GLN", retailer.storeGln),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Product Details Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Product Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _retailerDetailRow("Product SKU", retailer.productSku),
                        _retailerDetailRow("Barcode", retailer.barcode),
                        _retailerDetailRow("Domain", retailer.domainName),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Additional Information Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.pink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _retailerDetailRow(
                          "Created",
                          _formatDateTime(retailer.createdAt),
                        ),
                        _retailerDetailRow(
                          "Last Updated",
                          _formatDateTime(retailer.updatedAt),
                        ),
                        _retailerDetailRow(
                          "Brand Owner ID",
                          retailer.brandOwnerId,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (gtinCubit.hasMoreRetailers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                gtinCubit.loadMoreData(widget.barcode);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Load More'),
            ),
          ),
      ],
    );
  }

  Widget _retailerDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  Widget buildPackagingInformation(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gtinCubit.packagings.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final packaging = gtinCubit.packagings[index];
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: packaging.status == 'active'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Status: ${packaging.status}',
                      style: TextStyle(
                        color: packaging.status == 'active'
                            ? Colors.green
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Basic Information
                  _packagingDetailRow('Type', packaging.packagingType),
                  _packagingDetailRow('Material', packaging.material),
                  _packagingDetailRow('Weight', '${packaging.weight}'),
                  _packagingDetailRow('Color', packaging.color),
                  _packagingDetailRow('Labeling', packaging.labeling),

                  const SizedBox(height: 16),
                  // Environmental Information
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Environmental Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              packaging.recyclable
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: packaging.recyclable
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('Recyclable'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              packaging.biodegradable
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: packaging.biodegradable
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('Biodegradable'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Additional Information
                  Text(
                    'Last Updated: ${_formatDateTime(packaging.updatedAt)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (gtinCubit.hasMorePackagings)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                gtinCubit.loadMoreData(widget.barcode);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Load More'),
            ),
          ),
      ],
    );
  }

  Widget _packagingDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
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
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
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
