import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/production_job_order.dart';
import 'package:intl/intl.dart';

class JobOrderCard extends StatelessWidget {
  final ProductionJobOrder order;
  final String status;
  final VoidCallback onTap;

  const JobOrderCard({
    super.key,
    required this.order,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status color
    final isCompleted = status.toLowerCase() != "pending";
    final statusColor = isCompleted ? AppColors.green : AppColors.skyBlue;
    final statusBgColor = isCompleted
        ? AppColors.green.withAlpha(30)
        : AppColors.skyBlue.withAlpha(30);

    // Format dates
    final orderDate = _tryFormatDate(order.jobOrderMaster?.orderDate);
    final deliveryDate = _tryFormatDate(order.jobOrderMaster?.deliveryDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and status row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      orderDate,
                      style: TextStyle(
                        color: AppColors.pink,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
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
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isCompleted ? "COMPLETED" : "PENDING",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Job order number
              Text(
                order.jobOrderMaster?.jobOrderNumber ?? "N/A",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Item and cost row
              Row(
                children: [
                  _buildInfoItem(
                    icon: Icons.inventory_2_outlined,
                    label: "Items",
                    value: order.quantity ?? "N/A",
                  ),
                  const SizedBox(width: 28),
                  _buildInfoItem(
                    icon: Icons.money_outlined,
                    label: "Cost",
                    value: "${order.jobOrderMaster?.totalCost ?? "N/A"} SAR",
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Delivery date
              _buildInfoItem(
                icon: Icons.event_outlined,
                label: "Delivery",
                value: deliveryDate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _tryFormatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "N/A";
    }
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(dateString));
    } catch (e) {
      return "N/A";
    }
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
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
