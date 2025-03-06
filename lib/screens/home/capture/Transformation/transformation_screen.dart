import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Transformation/event_station_screen.dart';

class TransformationScreen extends StatefulWidget {
  const TransformationScreen({super.key});

  @override
  State<TransformationScreen> createState() => _TransformationScreenState();
}

class _TransformationScreenState extends State<TransformationScreen> {
  final List<Map> data = [
    {
      "text": "Manufacturing",
      "icon": AppIcons.transManufacturing,
      "onPressed": () {},
    },
    {
      "text": "Processing",
      "icon": AppIcons.transProcessing,
      "onPressed": () {},
    },

    {
      "text": "Repackaging",
      "icon": AppIcons.transRepackaging,
      "onPressed": () {},
    },

    {
      "text": "Refurbishing",
      "icon": AppIcons.transRefining,
      "onPressed": () {},
    },

    {
      "text": "Reprocessing",
      "icon": AppIcons.transReprocessing,
      "onPressed": () {},
    },

    {
      "text": "Repurposing",
      "icon": AppIcons.transRepurposing,
      "onPressed": () {},
    },

    {
      "text": "Converting",
      "icon": AppIcons.transConverting,
      "onPressed": () {},
    },

    {
      "text": "Refining",
      "icon": AppIcons.transRefining,
      "onPressed": () {},
    },

    {
      "text": "Modifying",
      "icon": AppIcons.transModifying,
      "onPressed": () {},
    },
    // {
    //   "text": "Customizing",
    //   "icon": AppIcons.transCustomizing,
    // },
    {
      "text": "Event Station",
      "icon": AppIcons.eventStation,
      "onPressed": () {},
    },
  ];

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.6,
    crossAxisSpacing: 20,
    mainAxisSpacing: 50,
  );

  @override
  void initState() {
    super.initState();
    data[9]['onPressed'] = () {
      AppNavigator.goToPage(context: context, screen: EventStationScreen());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRANSFORMATION'),
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
                  onPressed: data[index]['onPressed'] as void Function(),
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
