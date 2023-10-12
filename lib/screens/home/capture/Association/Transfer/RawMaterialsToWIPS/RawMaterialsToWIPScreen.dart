import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class RawMaterialsToWIPScreen extends StatefulWidget {
  const RawMaterialsToWIPScreen({super.key});

  @override
  State<RawMaterialsToWIPScreen> createState() =>
      _RawMaterialsToWIPScreenState();
}

class _RawMaterialsToWIPScreenState extends State<RawMaterialsToWIPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Raw Materials to WIP'),
      ),
      body: const Center(
        child: Text(
          'Raw Materials to WIP',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
