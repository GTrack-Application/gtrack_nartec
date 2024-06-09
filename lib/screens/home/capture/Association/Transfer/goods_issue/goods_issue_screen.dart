import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Transfer/goods_issue/raw_materials/rm_to_wip/BinToBinAXAPTA/BinToBinAxaptaScreen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Transfer/goods_issue/raw_materials/wip_fg/BinToBinAXAPTA/BinToBinAxaptaScreen.dart';

class GoodsIssueScreen extends StatefulWidget {
  const GoodsIssueScreen({super.key});

  @override
  State<GoodsIssueScreen> createState() => _GoodsIssueScreenState();
}

class _GoodsIssueScreenState extends State<GoodsIssueScreen> {
  final List<Map> data = [
    {
      "text": "Production (Job Order)",
      "icon": AppIcons.productionJobOrder,
      "onTap": () {},
    },
    {
      "text": "Raw Materials",
      "icon": AppIcons.rawMaterials,
      "onTap": () {},
    },
    {
      "text": "Finish Goods",
      "icon": AppIcons.finishGoods,
      "onTap": () {},
    },
    {
      "text": "FG Sample",
      "icon": AppIcons.fgSample,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    // data[0]["onTap"] = () => AppNavigator.goToPage(
    //     context: context, screen: RawMaterialsToWIPScreen1());
    data[1]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const RMtoWIPBinToBinAxaptaScreen());
    data[2]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const WIPtoFGBinToBinAxaptaScreen());
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
        title: const Text('Goods Issue'),
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
