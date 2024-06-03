import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';

class GoodsReceiptScreen extends StatefulWidget {
  const GoodsReceiptScreen({super.key});

  @override
  State<GoodsReceiptScreen> createState() => _GoodsReceiptScreenState();
}

class _GoodsReceiptScreenState extends State<GoodsReceiptScreen> {
  final List<Map> data = [
    {
      "text": "Raw Materials",
      "icon": AppIcons.rawMaterials,
      "onTap": () {},
    },
    {
      "text": "Production (Job Order)",
      "icon": AppIcons.productionJobOrder,
      "onTap": () {},
    },
    {
      "text": "Stock Returns",
      "icon": AppIcons.stockReturns,
      "onTap": () {},
    },
    {
      "text": "Finish Goods",
      "icon": AppIcons.finishGoods,
      "onTap": () {},
    },
    {
      "text": "Damages",
      "icon": AppIcons.damages,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    // data[0]["onTap"] = () => AppNavigator.goToPage(
    //     context: context, screen: RawMaterialsToWIPScreen1());
  }

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.6,
    crossAxisSpacing: 20,
    mainAxisSpacing: 50,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goods Receipt'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: gridDelegate,
              itemBuilder: (context, index) {
                return CardIconButton(
                  icon: data[index]["icon"] as String,
                  onPressed: data[index]["onTap"],
                  text: data[index]['text'] as String,
                );
              },
              itemCount: data.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            ),
          ],
        ),
      ),
    );
  }
}
