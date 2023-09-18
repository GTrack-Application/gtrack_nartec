import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/controllers/share/product_information/product_information_controller.dart';
import 'package:gtrack_mobile_app/controllers/share/product_information/safety_informaiton_controller.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/share/product_information/product_contents_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/promotional_offer_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/safety_information_model.dart';

// Some global variables
List<SafetyInfromationModel> safetyInformation = [];
List<PromotionalOfferModel> promotionalOffer = [];
List<ProductContentsModel> productContents = [];

class DigitalLinkScreen extends StatefulWidget {
  final String gtin;
  final String codeType;
  const DigitalLinkScreen({
    Key? key,
    required this.gtin,
    required this.codeType,
  }) : super(key: key);

  @override
  State<DigitalLinkScreen> createState() => _DigitalLinkScreenState();
}

class _DigitalLinkScreenState extends State<DigitalLinkScreen> {
  final List data = [
    "Safety Information",
    "Promotional Offers",
    "Product Contents",
    "Product Location Of Origin",
    "Product Recall",
    "Recipe",
    "Packaging Composition",
    "Electronic Leaflets",
  ];

  final List<Widget> screens = [];
  String? gtin;

  // Default Radio Button Selected Item When App Starts.
  int selectedIndex = 0;
  @override
  void initState() {
    if (widget.codeType == "1D") {
      gtin = widget.gtin;
    } else {
      gtin = widget.gtin.substring(1, 14);
    }
    screens.insert(0, SafetyInformation(gtin: gtin ?? ""));
    screens.insert(1, PromotionalOffers(gtin: gtin ?? ""));
    screens.insert(2, ProductContents(gtin: gtin ?? ""));
    // screens.insert(3, ProductLocationOfOrigin(gtin: widget.gtin));
    // screens.insert(4, ProductRecall(gtin: widget.gtin));
    // screens.insert(5, Recipe(gtin: widget.gtin));
    // screens.insert(6, PackagingComposition(gtin: widget.gtin));
    // screens.insert(7, ElectronicLeaflets(gtin: widget.gtin));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Create list of radio list based on above data variable but we will be able to select only one at a time.
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? AppColors.green
                          : AppColors.green.withOpacity(0.2),
                      border: Border.all(width: 1, color: AppColors.green),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      data[index],
                      style: TextStyle(
                        color: (selectedIndex == index)
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          const Divider(thickness: 2, color: AppColors.green),
          Text(
            data[selectedIndex],
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 2,
            child: screens[selectedIndex],
          ),
        ],
      ),
    );
  }
}

class SafetyInformation extends StatefulWidget {
  final String gtin;
  const SafetyInformation({Key? key, required this.gtin}) : super(key: key);

  @override
  State<SafetyInformation> createState() => _SafetyInformationState();
}

class _SafetyInformationState extends State<SafetyInformation> {
  @override
  void initState() {
    setState(() {
      SafetyInfromationController.getSafeInfromation(widget.gtin).then((value) {
        safetyInformation = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text("Id")),
        DataColumn(label: Text("Safety Details Information")),
        DataColumn(label: Text("Link Type")),
        DataColumn(label: Text("Language")),
        DataColumn(label: Text("Target URL")),
        DataColumn(label: Text("GTIN")),
        DataColumn(label: Text("Logo")),
        DataColumn(label: Text("Company Name")),
        DataColumn(label: Text("Process")),
      ],
      source: SafetyInformationSource(),
      arrowHeadColor: AppColors.green,
      showCheckboxColumn: false,
      rowsPerPage: 5,
    );
  }
}

class SafetyInformationSource extends DataTableSource {
  List<SafetyInfromationModel> data = safetyInformation;

  @override
  DataRow getRow(int index) {
    final rowData = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rowData.iD.toString())),
        DataCell(Text(rowData.safetyDetailedInformation.toString())),
        DataCell(Text(rowData.linkType.toString())),
        DataCell(Text(rowData.lang.toString())),
        DataCell(Text(rowData.targetURL.toString())),
        DataCell(Text(rowData.gTIN.toString())),
        DataCell(Text(rowData.logo.toString())),
        DataCell(Text(rowData.companyName.toString())),
        DataCell(Text(rowData.process.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class PromotionalOffers extends StatefulWidget {
  final String gtin;
  const PromotionalOffers({Key? key, required this.gtin}) : super(key: key);

  @override
  State<PromotionalOffers> createState() => _PromotionalOffersState();
}

class _PromotionalOffersState extends State<PromotionalOffers> {
  @override
  void initState() {
    setState(() {
      ProductInformationController.getPromotionalOffer(widget.gtin)
          .then((value) {
        promotionalOffer = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text("Id")),
        DataColumn(label: Text("Promotional Offers")),
        DataColumn(label: Text("Link Type")),
        DataColumn(label: Text("Language")),
        DataColumn(label: Text("Target URL")),
        DataColumn(label: Text("GTIN")),
        DataColumn(label: Text("Expiry Date")),
        DataColumn(label: Text("Price")),
        DataColumn(label: Text("Banner")),
      ],
      source: PromotionalOfferSource(),
      arrowHeadColor: AppColors.green,
      showCheckboxColumn: false,
      rowsPerPage: 5,
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Promotional Offers"),
    //     backgroundColor: AppColors.green,
    //   ),
    //   body: FutureBuilder(
    //     future: ProductInformationController.getPromotionalOffer(widget.gtin),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: LoadingWidget(),
    //         );
    //       } else if (snapshot.hasError) {
    //         return const Center(
    //           child: Text("Something went wrong"),
    //         );
    //       } else if (!snapshot.hasData) {
    //         return const Center(
    //           child: Text("No data available"),
    //         );
    //       } else {
    //         return Column(
    //           children: [
    //             Expanded(
    //               child: PaginatedDataTable(
    //                 columns: const [
    //                   DataColumn(label: Text("Id")),
    //                   DataColumn(label: Text("Promotional Offers")),
    //                   DataColumn(label: Text("Link Type")),
    //                   DataColumn(label: Text("Language")),
    //                   DataColumn(label: Text("Target URL")),
    //                   DataColumn(label: Text("GTIN")),
    //                   DataColumn(label: Text("Expiry Date")),
    //                   DataColumn(label: Text("Price")),
    //                   DataColumn(label: Text("Banner")),
    //                 ],
    //                 source: PromotionalOfferSource(),
    //                 arrowHeadColor: AppColors.green,
    //                 showCheckboxColumn: false,
    //                 rowsPerPage: 10,
    //               ),
    //             ),
    //           ],
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}

class PromotionalOfferSource extends DataTableSource {
  List<PromotionalOfferModel> data = promotionalOffer;

  @override
  DataRow getRow(int index) {
    final rowData = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rowData.iD.toString())),
        DataCell(Text(rowData.promotionalOffers.toString())),
        DataCell(Text(rowData.linkType.toString())),
        DataCell(Text(rowData.lang.toString())),
        DataCell(Text(rowData.targetURL.toString())),
        DataCell(Text(rowData.gTIN.toString())),
        DataCell(Text(rowData.expiryDate.toString())),
        DataCell(Text(rowData.price.toString())),
        DataCell(Text(rowData.banner.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class ProductContents extends StatefulWidget {
  final String gtin;
  const ProductContents({Key? key, required this.gtin}) : super(key: key);

  @override
  State<ProductContents> createState() => _ProductContentsState();
}

class _ProductContentsState extends State<ProductContents> {
  @override
  void initState() {
    super.initState();
    setState(() {
      ProductInformationController.getProductContents(widget.gtin)
          .then((value) {
        productContents = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text("Id")),
        DataColumn(label: Text("Product Allergen Information")),
        DataColumn(label: Text("Product Nutrient Information")),
        DataColumn(label: Text("GTIN")),
        DataColumn(label: Text("Link Type")),
        DataColumn(label: Text("Batch")),
        DataColumn(label: Text("Expiry")),
        DataColumn(label: Text("Serial")),
        DataColumn(label: Text("Manufecturing Date")),
        DataColumn(label: Text("Best Before")),
        DataColumn(label: Text("GLNID Form")),
        DataColumn(label: Text("Unit Price")),
        DataColumn(label: Text("Ingredients")),
        DataColumn(label: Text("Allergen Info")),
        DataColumn(label: Text("Calories")),
        DataColumn(label: Text("Sugar")),
        DataColumn(label: Text("Salt")),
        DataColumn(label: Text("Fat")),
      ],
      source: ProductContentsSource(),
      arrowHeadColor: AppColors.green,
      showCheckboxColumn: false,
      rowsPerPage: 5,
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Product Contents"),
    //     backgroundColor: AppColors.green,
    //   ),
    //   body: FutureBuilder(
    //     future: ProductInformationController.getProductContents(widget.gtin),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: LoadingWidget(),
    //         );
    //       } else if (snapshot.hasError) {
    //         return const Center(
    //           child: Text("Something went wrong"),
    //         );
    //       } else if (!snapshot.hasData) {
    //         return const Center(
    //           child: Text("No data available"),
    //         );
    //       } else {
    //         return Column(
    //           children: [
    //             Expanded(
    //               child: PaginatedDataTable(
    //                 columns: const [
    //                   DataColumn(label: Text("Id")),
    //                   DataColumn(label: Text("Product Allergen Information")),
    //                   DataColumn(label: Text("Product Nutrient Information")),
    //                   DataColumn(label: Text("GTIN")),
    //                   DataColumn(label: Text("Link Type")),
    //                   DataColumn(label: Text("Batch")),
    //                   DataColumn(label: Text("Expiry")),
    //                   DataColumn(label: Text("Serial")),
    //                   DataColumn(label: Text("Manufecturing Date")),
    //                   DataColumn(label: Text("Best Before")),
    //                   DataColumn(label: Text("GLNID Form")),
    //                   DataColumn(label: Text("Unit Price")),
    //                   DataColumn(label: Text("Ingredients")),
    //                   DataColumn(label: Text("Allergen Info")),
    //                   DataColumn(label: Text("Calories")),
    //                   DataColumn(label: Text("Sugar")),
    //                   DataColumn(label: Text("Salt")),
    //                   DataColumn(label: Text("Fat")),
    //                 ],
    //                 source: ProductContentsSource(),
    //                 arrowHeadColor: AppColors.green,
    //                 showCheckboxColumn: false,
    //                 rowsPerPage: 10,
    //               ),
    //             ),
    //           ],
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}

class ProductContentsSource extends DataTableSource {
  List<ProductContentsModel> data = productContents;

  @override
  DataRow getRow(int index) {
    final rowData = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rowData.iD.toString())),
        DataCell(Text(rowData.productAllergenInformation.toString())),
        DataCell(Text(rowData.productNutrientsInformation.toString())),
        DataCell(Text(rowData.gTIN.toString())),
        DataCell(Text(rowData.linkType.toString())),
        DataCell(Text(rowData.batch.toString())),
        DataCell(Text(rowData.expiry.toString())),
        DataCell(Text(rowData.serial.toString())),
        DataCell(Text(rowData.manufacturingDate.toString())),
        DataCell(Text(rowData.bestBeforeDate.toString())),
        DataCell(Text(rowData.gLNIDFrom.toString())),
        DataCell(Text(rowData.unitPrice.toString())),
        DataCell(Text(rowData.ingredients.toString())),
        DataCell(Text(rowData.allergenInfo.toString())),
        DataCell(Text(rowData.calories.toString())),
        DataCell(Text(rowData.sugar.toString())),
        DataCell(Text(rowData.salt.toString())),
        DataCell(Text(rowData.fat.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class ProductLocationOfOrigin extends StatelessWidget {
  const ProductLocationOfOrigin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Product Location Of Origin"),
    );
  }
}

// class ProductRecall extends StatelessWidget {
//   const ProductRecall({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text("Product Recall"),
//     );
//   }
// }

// class Recipe extends StatelessWidget {
//   const Recipe({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text("Recipe"),
//     );
//   }
// }

// class PackagingComposition extends StatelessWidget {
//   const PackagingComposition({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text("Packaging Composition"),
//     );
//   }
// }

// class ElectronicLeaflets extends StatelessWidget {
//   const ElectronicLeaflets({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text("Electronic Leaflets"),
//     );
//   }
// }
