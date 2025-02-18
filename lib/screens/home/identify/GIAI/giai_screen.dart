import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/asset_capture_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/asset_verification_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/generate_tags_screen.dart';

class GIAIScreen extends StatefulWidget {
  const GIAIScreen({super.key});

  @override
  State<GIAIScreen> createState() => _GIAIScreenState();
}

class _GIAIScreenState extends State<GIAIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('GIAI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search assets...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.visibility, 'Asset\nCapture', () {
                  AppNavigator.goToPage(
                      context: context, screen: AssetCaptureScreen());
                }),
                _buildActionButton(Icons.upload, 'Generate\nGIAI Tag', () {
                  AppNavigator.goToPage(
                      context: context, screen: GenerateTagsScreen());
                }),
                _buildActionButton(Icons.refresh, 'Asset\nVerification', () {
                  AppNavigator.goToPage(
                      context: context, screen: AssetVerificationScreen());
                }),
              ],
            ),

            const SizedBox(height: 24),

            // Asset cards
            Expanded(
              child: ListView(
                children: [
                  _buildAssetCard(
                    'AT-2024-001',
                    'Dell Laptop XPS 15',
                    'Regular maintenance',
                    'Created: 3/15/2024, 10:30:00 AM',
                    'Last Maintenance: 2/15/2024, 5:00:00 AM',
                    true,
                  ),
                  const SizedBox(height: 16),
                  _buildAssetCard(
                    'AT-2024-002',
                    'Office Desk',
                    'Need inspection',
                    'Created: 3/14/2024, 9:15:00 AM',
                    'Last Maintenance: 1/20/2024, 5:00:00 AM',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(String id, String name, String status, String created,
      String lastMaintenance, bool isCompleted) {
    return Card(
      color: AppColors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  created,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 10,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              id,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                Text(status,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lastMaintenance,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // TODO: Implement delete functionality
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
