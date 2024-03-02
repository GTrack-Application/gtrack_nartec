import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Receiving/receiving_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<Map> buttons = [
    {
      "text": "Receiving",
      "image": AppIcons.receiving,
      "onPressed": () {},
    },
    {
      "text": "Shipping",
      "image": AppIcons.shipping,
      "onPressed": () {},
    },
    {
      "text": "Aggregation",
      "image": AppIcons.aggregation,
      "onPressed": () {},
    },
    {
      "text": "Transformation",
      "image": AppIcons.transformation,
      "onPressed": () {},
    },
    {
      "text": "Sales Transaction",
      "image": AppIcons.salesTransaction,
      "onPressed": () {},
    },
    {
      "text": "Delivery",
      "image": AppIcons.delivery,
      "onPressed": () {},
    },
    {
      "text": "Barcode Utility",
      "image": AppIcons.barcodeUtility,
      "onPressed": () {},
    },
    {
      "text": "RFID Utility",
      "image": AppIcons.rfidUtility,
      "onPressed": () {},
    },
  ];

  // scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // assign the receivingOnClick function to the receiving button
    buttons[0]['onPressed'] = receivingOnClick;
  }

  receivingOnClick() {
    AppNavigator.goToPage(
      context: context,
      screen: const ReceivingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('GTIN Tracker'),
          automaticallyImplyLeading: false,
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return CardIconButton(
              text: buttons[index]['text'],
              icon: buttons[index]['image'],
              onPressed: buttons[index]['onPressed'],
            );
          },
          itemCount: buttons.length,
        ),
      ),
    );
  }
}
