import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class GtinJourneyScreen extends StatefulWidget {
  const GtinJourneyScreen({super.key});

  @override
  State<GtinJourneyScreen> createState() => _GtinJourneyScreenState();
}

class _GtinJourneyScreenState extends State<GtinJourneyScreen> {
  int activeStep = 0;

  final List<Map<String, String>> steps = [
    {
      'title': 'Production',
      'subtitle': 'Manufacturing process',
    },
    {
      'title': 'Packaging',
      'subtitle': 'Product packaging',
    },
    {
      'title': 'Transport',
      'subtitle': 'Shipping & delivery',
    },
    {
      'title': 'Use',
      'subtitle': 'Product usage',
    },
    {
      'title': 'End of Life',
      'subtitle': 'Product disposal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTIN Journey'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            EasyStepper(
              activeStep: activeStep,
              stepShape: StepShape.circle,
              stepBorderRadius: 15,
              borderThickness: 2,
              padding: const EdgeInsets.all(20),
              stepRadius: 28,
              finishedStepBorderColor: AppColors.pink,
              finishedStepTextColor: AppColors.pink,
              finishedStepBackgroundColor: AppColors.pink,
              activeStepIconColor: AppColors.white,
              showLoadingAnimation: false,
              steps: steps.map((step) {
                return EasyStep(
                  customStep: CircleAvatar(
                    radius: 28,
                    backgroundColor: activeStep >= steps.indexOf(step)
                        ? AppColors.pink
                        : AppColors.grey,
                    child: Icon(
                      steps.indexOf(step) <= activeStep
                          ? Icons.check
                          : Icons.circle_outlined,
                      color: AppColors.white,
                    ),
                  ),
                  title: step['title']!,
                  enabled: true,
                  topTitle: false,
                );
              }).toList(),
              onStepReached: (index) => setState(() => activeStep = index),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: activeStep == 0
                        ? null
                        : () => setState(() => activeStep--),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: activeStep == steps.length - 1
                        ? null
                        : () => setState(() => activeStep++),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Next'),
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
