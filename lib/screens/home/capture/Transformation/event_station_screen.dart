import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class EventStationScreen extends StatelessWidget {
  const EventStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Station'),
        backgroundColor: AppColors.pink,
      ),
      body: Column(
        children: [
          Text('Event Station'),
        ],
      ),
    );
  }
}
