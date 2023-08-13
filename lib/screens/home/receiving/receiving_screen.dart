import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/receiving/SupplierReceipt/shipment_dispatching_screen.dart';
import 'package:gtrack_mobile_app/screens/home/widgets/card_icon_button.dart';

class ReceivingScreen extends StatefulWidget {
  const ReceivingScreen({Key? key}) : super(key: key);

  @override
  State<ReceivingScreen> createState() => _ReceivingScreenState();
}

class _ReceivingScreenState extends State<ReceivingScreen> {
  List<Map> buttons = [
    {
      "text": "Raw Materials",
      "image": AppIcons.receiving,
      "onPressed": () {},
    },
    {
      "text": "Finished Goods Receipts",
      "image": AppIcons.delivery,
      "onPressed": () {},
    },
    {
      "text": "Sales Returns",
      "image": AppIcons.aggregation,
      "onPressed": () {},
    },
    {
      "text": "Supplier Receipts",
      "image": AppIcons.transformation,
      "onPressed": () {},
    },
    {
      "text": "Production Assembly",
      "image": AppIcons.salesTransaction,
      "onPressed": () {},
    },
    {
      "text": "Sock Transfer",
      "image": AppIcons.sockTransfer,
      "onPressed": () {},
    },
  ];

  supplierReceipt() {
    AppNavigator.goToPage(
      context: context,
      screen: const ShipmentDispatchingScreen(),
    );
  }

  @override
  void initState() {
    buttons[3]['onPressed'] = supplierReceipt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receiving")),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 20,
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
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:gtrack_mobile_app/constants/app_icons.dart';
// import 'package:gtrack_mobile_app/constants/app_images.dart';
// import 'package:gtrack_mobile_app/global/widgets/buttons/image_button.dart';

// class ReceivingScreen extends StatelessWidget {
//   const ReceivingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.asset(AppImages.receiptPageBG),
//             AppBar(title: const Text('WPS PRO')),
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 children: [
//                   CustomImageButtonRow(
//                     buttonOne: ImageButton(
//                       icon: AppIcons.foreignPO,
//                       text: 'Raw Materials',
//                     ),
//                     buttonTwo: ImageButton(
//                       icon: AppIcons.salesOrder,
//                       text: 'Finished Goods Receipts',
//                     ),
//                   ),
//                   // SizedBox(height: 10),
//                   CustomImageButtonRow(
//                     buttonOne: ImageButton(
//                       icon: AppIcons.directSalesReturn,
//                       text: 'Direct Sales Return',
//                     ),
//                     buttonTwo: ImageButton(
//                       icon: AppIcons.stockTransfer,
//                       text: 'Stock Transfer',
//                     ),
//                   ),
//                   // SizedBox(height: 10),
//                   CustomImageButtonRow(
//                     buttonOne: ImageButton(
//                       icon: AppIcons.directInvoice,
//                       text: 'Direct Invoice',
//                     ),
//                     buttonTwo: ImageButton(
//                       icon: AppIcons.fgGoodsReceipt,
//                       text: 'FG Goods Receipts',
//                     ),
//                   ),
//                   // SizedBox(height: 10),
//                   CustomImageButtonRow(
//                     buttonOne: ImageButton(
//                       icon: AppIcons.salesReturnInvoice,
//                       text: 'Sales Return Invoice',
//                     ),
//                     buttonTwo: ImageButton(
//                       icon: AppIcons.goodsIssuedProduction,
//                       text: 'Goods Issued (Production)',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// class CustomImageButtonRow extends StatelessWidget {
//   const CustomImageButtonRow({
//     super.key,
//     required this.buttonOne,
//     required this.buttonTwo,
//   });

//   final ImageButton buttonOne;
//   final ImageButton buttonTwo;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         buttonOne,
//         buttonTwo,
//       ],
//     );
//   }
// }
