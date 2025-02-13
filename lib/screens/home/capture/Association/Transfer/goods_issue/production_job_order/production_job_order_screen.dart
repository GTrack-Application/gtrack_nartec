import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class ProductionJobOrderScreen extends StatefulWidget {
  const ProductionJobOrderScreen({super.key});

  @override
  State<ProductionJobOrderScreen> createState() =>
      _ProductionJobOrderScreenState();
}

class _ProductionJobOrderScreenState extends State<ProductionJobOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Production Job Order"),
        backgroundColor: AppColors.pink,
      ),
    );
  }
}
