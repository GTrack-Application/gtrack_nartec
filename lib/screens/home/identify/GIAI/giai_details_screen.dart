// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GIAI/giai_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GIAIDetailsScreen extends StatefulWidget {
  const GIAIDetailsScreen({super.key, required this.giai});

  final GIAIModel giai;

  @override
  State<GIAIDetailsScreen> createState() => _GIAIDetailsScreenState();
}

class _GIAIDetailsScreenState extends State<GIAIDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('GIAI Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.giai.tagNumber ?? '',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.giai.assetDescription ?? '',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    // qr code
                    PrettyQr(
                      data: widget.giai.tagNumber ?? '',
                      size: 70,
                    ),
                  ],
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 10),

            const Text(
              'Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Asset ID Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // avatar
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.rectangle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.skyBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.giai.assetDescription ?? '',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.giai.majorCategory ?? '',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '1 Pcs',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$120.00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Details List
            _buildDetailRow('Created at', widget.giai.createdAt ?? 'N/A'),
            _buildDetailRow(
                'Delivery Services', widget.giai.serialNumber ?? 'N/A'),
            _buildDetailRow('Payment Method', 'Bank Transfer'),
            _buildDetailRow(
                'Status',
                widget.giai.tagNumber != "null" ||
                        widget.giai.tagNumber != null ||
                        widget.giai.tagNumber!.isNotEmpty
                    ? 'Processed'
                    : 'Pending'),
            _buildDetailRow('Customer Name', widget.giai.modelOfAsset ?? 'N/A'),
            // _buildDetailRow('Email', widget.giai.email ?? 'N/A'),
            // _buildDetailRow('Phone', widget.giai.mobi ?? 'N/A'),
            const SizedBox(height: 20),

            // Timeline Section (if needed)
            const Text(
              'Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stepper(
              type: StepperType.vertical,
              currentStep: 0, // Assuming first step is active
              controlsBuilder: (context, controls) {
                return const SizedBox.shrink(); // Removes the default controls
              },
              steps: [
                Step(
                  title: const Text(
                    'Order Processed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'The order is being prepared (products are being packed)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  isActive: true,
                  state: StepState.complete,
                ),
                Step(
                  title: const Text(
                    'Payment Confirmed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Payment has been successfully processed and verified.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  isActive: false,
                  state: StepState.disabled,
                ),
                Step(
                  title: const Text(
                    'Order Placed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Order has been successfully placed by the customer',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  isActive: false,
                  state: StepState.disabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
