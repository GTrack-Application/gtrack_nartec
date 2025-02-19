import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class PackagingScreen extends StatelessWidget {
  const PackagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packaging'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 8.0,
              children: [
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Show nice dialog
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('Packaing Box'),
                          backgroundColor: AppColors.background,
                          children: [
                            // create a wrap widget of 3 columns and 5 elements total
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  buildPackingBox(
                                      title: "Pallet",
                                      icon: AppIcons.transferPallet),
                                  buildPackingBox(
                                      title: "Box/Carton",
                                      icon: AppIcons.aggCompiling),
                                  buildPackingBox(
                                      title: "Bundle",
                                      icon: AppIcons.aggCompiling),
                                  buildPackingBox(
                                      title: "Pack",
                                      icon: AppIcons.aggCompiling),
                                  buildPackingBox(
                                      title: "Piece",
                                      icon: AppIcons.aggCompiling),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    child: Row(
                      spacing: 4,
                      children: [
                        const Icon(
                          Icons.print,
                          color: AppColors.white,
                        ),
                        const Text(
                          "Packaing Box",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              color: Colors.grey,
            ))
          ],
        ),
      ),
    );
  }

  Widget buildPackingBox({required String title, required String icon}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.background),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        spacing: 4.0,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.background,
            child: Image.asset(icon, height: 60, width: 60),
          ),
          FittedBox(
            child: Text(
              title,
              style: TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
