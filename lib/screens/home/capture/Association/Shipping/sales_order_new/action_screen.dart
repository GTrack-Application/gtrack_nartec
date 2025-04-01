// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/action_screens/picklist_details_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/capture_images/picklist_details_screen_1.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/delivery_invoice/picklist_details_screen2.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/signature/picklist_details_screen3.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.mapModel,
    required this.subSalesOrder,
  });

  final String customerId;
  final String salesOrderId;
  final List<MapModel> mapModel;
  final List<SubSalesOrderModel> subSalesOrder;

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Actions'),
        elevation: 0,
        backgroundColor: AppColors.pink,
        automaticallyImplyLeading: false,
        // back button manually created
        leading: IconButton(
          onPressed: () {
            // a confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(
                  'Confirmation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                content: const Text(
                  'Are you sure you want go back and leave the delivery in progress?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'What would you like to do?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                title: 'Start Unloading',
                subtitle: 'Begin the delivery process',
                icon: Icons.local_shipping,
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: PicklistDetailsScreen(
                      customerId: widget.customerId,
                      salesOrderId: widget.salesOrderId,
                      mapModel: widget.mapModel,
                      subSalesOrder: widget.subSalesOrder,
                    ),
                  );
                },
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Capture Images',
                subtitle: 'Take photos of the delivery',
                icon: Icons.camera_alt,
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: PicklistDetailsScreen1(
                      customerId: widget.customerId,
                      salesOrderId: widget.salesOrderId,
                      mapModel: widget.mapModel,
                      subSalesOrder: widget.subSalesOrder,
                    ),
                  );
                },
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Capture Signature',
                subtitle: 'Get customer confirmation',
                icon: Icons.draw,
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: PicklistDetailsScreen3(
                      customerId: widget.customerId,
                      salesOrderId: widget.salesOrderId,
                      mapModel: widget.mapModel,
                      subSalesOrder: widget.subSalesOrder,
                    ),
                  );
                },
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Print Delivery Invoice',
                subtitle: 'Generate delivery documentation',
                icon: Icons.receipt_long,
                onPressed: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: PicklistDetailsScreen2(
                      customerId: widget.customerId,
                      salesOrderId: widget.salesOrderId,
                      mapModel: widget.mapModel,
                      subSalesOrder: widget.subSalesOrder,
                    ),
                  );
                },
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
