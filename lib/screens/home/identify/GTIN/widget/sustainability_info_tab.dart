import 'package:flutter/material.dart';

class SustainabilityInfoTab extends StatelessWidget {
  const SustainabilityInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sustainability Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),

          // Environmental Impact Section
          Text(
            'Environmental Impact:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint('100% Recyclable Packaging'),
          _buildBulletPoint('Reduced Carbon Footprint Initiative'),
          _buildBulletPoint('Sustainable Sourcing Practices'),
          const SizedBox(height: 20),

          // Recycling Information Section
          Text(
            'Recycling Information:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint('Please recycle aluminum can'),
          _buildBulletPoint('Check local recycling guidelines'),
          const SizedBox(height: 20),

          // Sustainability Goals Section
          Text(
            'Sustainability Goals:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint('30% reduction in water usage by 2025'),
          _buildBulletPoint('100% renewable energy in production by 2026'),
          _buildBulletPoint('Zero waste to landfill by 2027'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
