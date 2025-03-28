import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/packaging/packaging_by_many_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/packaging/packaging_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/palletization_containerization/palletization_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/palletization_containerization/sscc_container_screen.dart';

class AggregationScreen extends StatefulWidget {
  const AggregationScreen({super.key});

  @override
  State<AggregationScreen> createState() => _AggregationScreenState();
}

class _AggregationScreenState extends State<AggregationScreen> {
  /// Grid delegate for consistent layout across the screen
  final SliverGridDelegateWithFixedCrossAxisCount _gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.6,
    crossAxisSpacing: 20,
    mainAxisSpacing: 50,
  );

  /// List of aggregation options with their properties
  late final List<AggregationOption> _aggregationOptions;

  @override
  void initState() {
    super.initState();
    _initializeAggregationOptions();
  }

  /// Initialize the list of aggregation options and their handlers
  void _initializeAggregationOptions() {
    _aggregationOptions = [
      AggregationOption(
        title: "Packaging By Carton",
        icon: AppIcons.aggPackaging,
        onTap: () => _navigateToPackagingByCartonScreen(),
      ),
      AggregationOption(
        title: "Packaging By Pack",
        icon: AppIcons.aggPacking,
        onTap: () => _navigateToPackagingScreen(
          packagingType: "packing_by_pack",
          title: "Packaging By Pack",
        ),
      ),
      AggregationOption(
        title: "Combining",
        icon: AppIcons.aggCombining,
        onTap: () {}, // Placeholder for future implementation
      ),
      AggregationOption(
        title: "Pack By Assembly",
        icon: AppIcons.aggAssembling,
        onTap: () => _navigateToPackagingScreen(
          packagingType: "assembling",
          title: "Pack By Assembly",
        ),
      ),
      AggregationOption(
        title: "Grouping",
        icon: AppIcons.aggGrouping,
        onTap: () => _navigateToPackagingByCartonScreen(
          type: "grouping",
          description: "Grouping",
          floatingActionButtonText: "Perform Aggregation By Grouping",
        ),
      ),
      AggregationOption(
        title: "Packaging By Bundle",
        icon: AppIcons.aggBundling,
        onTap: () => _navigateToPackagingScreen(
          packagingType: "packing_by_bundle",
          title: "Packaging By Bundle",
        ),
      ),
      AggregationOption(
        title: "Pack By Batches",
        icon: AppIcons.aggBatching,
        onTap: () => _navigateToPackagingByCartonScreen(
          type: "batching",
          description: "Pack By Batches",
          floatingActionButtonText: "Perform Aggregation By Batches",
        ),
      ),
      AggregationOption(
        title: "Consolidating",
        icon: AppIcons.aggConsolidating,
        onTap: () {}, // Placeholder for future implementation
      ),
      AggregationOption(
        title: "Pack By Pallets",
        icon: AppIcons.aggCompiling,
        onTap: () => _navigateToPalletizationScreen(),
      ),
      AggregationOption(
        title: "Pack By SSCC Container",
        icon: AppIcons.aggContainerization,
        onTap: () => _navigateToSSCCContainerScreen(),
      ),
    ];
  }

  /// Navigate to PackagingByCartonScreen with default parameters
  void _navigateToPackagingByCartonScreen({
    String type = "box_carton",
    String description = "Packaging By Carton",
    String floatingActionButtonText = "Perform Packaging By Carton",
  }) {
    AppNavigator.goToPage(
      context: context,
      screen: PackagingByCartonScreen(
        type: type,
        description: description,
        floatingActionButtonText: floatingActionButtonText,
      ),
    );
  }

  /// Navigate to PackagingScreen with specified parameters
  void _navigateToPackagingScreen({
    required String packagingType,
    required String title,
  }) {
    AppNavigator.goToPage(
      context: context,
      screen: PackagingScreen(
        packagingType: packagingType,
        title: title,
      ),
    );
  }

  /// Navigate to PalletizationScreen
  void _navigateToPalletizationScreen() {
    AppNavigator.goToPage(
      context: context,
      screen: const PalletizationScreen(),
    );
  }

  /// Navigate to SSCCContainerScreen
  void _navigateToSSCCContainerScreen() {
    AppNavigator.goToPage(
      context: context,
      screen: const SSCCContainerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGGREGATION'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: _gridDelegate,
            itemCount: _aggregationOptions.length,
            itemBuilder: _buildAggregationOptionItem,
          ),
        ),
      ),
    );
  }

  /// Build individual grid item for each aggregation option
  Widget _buildAggregationOptionItem(BuildContext context, int index) {
    final option = _aggregationOptions[index];
    return CardIconButton(
      icon: option.icon,
      onPressed: option.onTap,
      text: option.title,
    );
  }
}

/// Model class to represent an aggregation option
class AggregationOption {
  final String title;
  final String icon;
  final VoidCallback onTap;

  AggregationOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
