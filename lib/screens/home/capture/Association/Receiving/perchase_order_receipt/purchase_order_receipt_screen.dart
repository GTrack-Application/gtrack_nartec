// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Receiving/purchase_order_receipt/purchase_order_receipt_controller.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_receipt_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/perchase_order_receipt/create_purchase_order_receipt.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/perchase_order_receipt/purchase_order_detail_screen.dart';

class PurchaseOrderReceiptScreen extends StatefulWidget {
  const PurchaseOrderReceiptScreen({super.key});

  @override
  State<PurchaseOrderReceiptScreen> createState() =>
      _PurchaseOrderReceiptScreenState();
}

class _PurchaseOrderReceiptScreenState
    extends State<PurchaseOrderReceiptScreen> {
  List<PurchaseOrderReceiptModel> purchaseOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPurchaseOrders();
  }

  TextEditingController searchController = TextEditingController();

  Future<void> fetchPurchaseOrders() async {
    try {
      final orders =
          await PurchaseOrderReceiptController.getPurchaseOrderReceipt();
      setState(() {
        purchaseOrders = orders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          "Purchase Order Receipt",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.pink,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  AppNavigator.goToPage(
                      context: context,
                      screen: const CreatePurchaseOrderReceiptScreen());
                },
                child: const Text('Create Purchase Order'),
              ),
            ),
            // search textfeild with searching the purchase order number
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    purchaseOrders = purchaseOrders
                        .where((element) =>
                            element.purchaseOrderNumber?.contains(value) ??
                            false)
                        .toList();

                    if (value.isEmpty) {
                      fetchPurchaseOrders();
                    }
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search Purchase Order Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? ListView.builder(
                      itemCount: 5,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) => _buildShimmerCard(),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchPurchaseOrders,
                      color: AppColors.pink,
                      child: purchaseOrders.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 60,
                                    color: AppColors.pink.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Purchase Orders Found',
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: purchaseOrders.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) => _buildOrderCard(
                                purchaseOrders[index],
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PurchaseOrderDetailsScreen(),
                                  ),
                                ),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: AppColors.grey.withOpacity(0.3),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    PurchaseOrderReceiptModel order,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.deliveryDate ?? '',
                        style: TextStyle(
                          color: AppColors.pink,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status ?? '')
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status?.toUpperCase() ?? '',
                        style: TextStyle(
                          color: _getStatusColor(order.status ?? ''),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'PO #${order.purchaseOrderNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  label: "Delivery",
                  value: order.deliveryDate ?? '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 10,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.skyBlue;
      case 'complete':
        return AppColors.green;
      case 'cancel':
        return Colors.red;
      default:
        return AppColors.pink;
    }
  }
}
