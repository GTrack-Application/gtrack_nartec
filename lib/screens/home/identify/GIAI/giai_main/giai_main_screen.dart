import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/giai_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/vairfied_asset/varified_asset_screen.dart';

class GIAIMainScreen extends StatefulWidget {
  const GIAIMainScreen({super.key});

  @override
  State<GIAIMainScreen> createState() => _GIAIMainScreenState();
}

class _GIAIMainScreenState extends State<GIAIMainScreen> {
  final List<Map> data = [
    {
      "text": "Verified Assets",
      "icon": AppIcons.varifiedIcon,
      "desctiption": "Global Trade\nItem Number",
      "onTap": () {},
    },
    {
      "text": "Un-Verified Assets",
      "icon": AppIcons.unvarifiedIcon,
      "desctiption": "Global Location\nNumber",
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    data[0]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const VerifiedAssetScreen());
    data[1]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const GIAIScreen());
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
        title: const Text('GIAI'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: gridDelegate,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                itemBuilder: (context, index) {
                  return CardIconButton(
                    icon: data[index]["icon"] as String,
                    onPressed: data[index]["onTap"],
                    text: data[index]['text'] as String,
                  );
                },
                itemCount: data.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
