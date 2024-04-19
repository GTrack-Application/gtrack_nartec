// import 'package:flutter/material.dart';
// import 'package:gtrack_mobile_app/controllers/share/product_information/digital_links_controller.dart';
// import 'package:gtrack_mobile_app/controllers/share/product_information/product_information_controller.dart';
// import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
// import 'package:gtrack_mobile_app/models/share/product_information/location_origin_model.dart';
// import 'package:gtrack_mobile_app/models/share/product_information/product_contents_model.dart';
// import 'package:gtrack_mobile_app/models/share/product_information/promotional_offer_model.dart';
// import 'package:gtrack_mobile_app/models/share/product_information/recipe_model.dart';
// import 'package:gtrack_mobile_app/models/share/product_information/safety_information_model.dart';

// // Some global variables
// List<SafetyInfromationModel> safetyInformation = [];
// List<PromotionalOfferModel> promotionalOffer = [];
// List<ProductContentsModel> productContents = [];
// List<LocationOriginModel> locationOrigin = [];
// List<SafetyInfromationModel> productRecall = [];
// List<RecipeModel> recipe = [];
// List<ProductContentsModel> packagingComposition = [];
// List<ProductContentsModel> leaflets = [];

// class DigitalLinkScreen extends StatefulWidget {
//   final String gtin;
//   const DigitalLinkScreen({super.key, required this.gtin});

//   @override
//   State<DigitalLinkScreen> createState() => _DigitalLinkScreenState();
// }

// class _DigitalLinkScreenState extends State<DigitalLinkScreen> {
//   final List data = [
//     "Safety Information",
//     "Promotional Offers",
//     "Product Contents",
//     "Product Location Of Origin",
//     "Product Recall",
//     "Recipe",
//     "Packaging Composition",
//     "Electronic Leaflets",
//   ];

//   final List<Widget> screens = [];
//   String? gtin;

//   // Default Radio Button Selected Item When App Starts.
//   int selectedIndex = 0;
//   @override
//   void initState() {
//     screens.insert(0, SafetyInformation(gtin: widget.gtin));
//     screens.insert(1, PromotionalOffers(gtin: widget.gtin));
//     screens.insert(2, ProductContents(gtin: widget.gtin));
//     screens.insert(3, ProductLocationOfOrigin(gtin: widget.gtin));
//     screens.insert(4, ProductRecall(gtin: widget.gtin));
//     screens.insert(5, Recipe(gtin: widget.gtin));
//     screens.insert(6, PackagingComposition(gtin: widget.gtin));
//     screens.insert(7, ElectronicLeaflets(gtin: widget.gtin));

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Create list of radio list based on above data variable but we will be able to select only one at a time.
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: data.length,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = index;
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 5),
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     decoration: BoxDecoration(
//                       color: selectedIndex == index
//                           ? AppColors.green
//                           : AppColors.green.withOpacity(0.2),
//                       border: Border.all(width: 1, color: AppColors.green),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text(
//                       data[index],
//                       style: TextStyle(
//                         color: (selectedIndex == index)
//                             ? AppColors.white
//                             : AppColors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//             ),
//             const Divider(thickness: 2, color: AppColors.green),
//             Text(
//               data[selectedIndex],
//               style: const TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             screens[selectedIndex],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SafetyInformation extends StatefulWidget {
//   final String gtin;
//   const SafetyInformation({super.key, required this.gtin});

//   @override
//   State<SafetyInformation> createState() => _SafetyInformationState();
// }

// class _SafetyInformationState extends State<SafetyInformation> {
//   @override
//   void initState() {
//     DigitalLinksController()
//         .getDigitalLinksData(
//       "safety-information",
//       widget.gtin,
//     )
//         // SafetyInfromationController.getSafeInfromation(widget.gtin)
//         .then((value) {
//       safetyInformation = value;
//       setState(() {});
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       headingRowColor: MaterialStateProperty.all(Colors.blue),
//       columns: const [
//         // DataColumn(label: Text("Id", style: TextStyle(color: Colors.white))),
//         DataColumn(
//             label: Text("Link Title", style: TextStyle(color: Colors.white))),
//         DataColumn(
//             label: Text("Link Type", style: TextStyle(color: Colors.white))),
//         DataColumn(
//             label: Text("Language", style: TextStyle(color: Colors.white))),
//         DataColumn(
//             label: Text("Target URL", style: TextStyle(color: Colors.white))),
//         DataColumn(
//             label: Text("Mime Type", style: TextStyle(color: Colors.white))),
//         // DataColumn(label: Text("Logo", style: TextStyle(color: Colors.white))),
//         // DataColumn(
//         //     label: Text("Company Name", style: TextStyle(color: Colors.white))),
//         // DataColumn(
//         //     label: Text("Process", style: TextStyle(color: Colors.white))),
//       ],
//       source: SafetyInformationSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class SafetyInformationSource extends DataTableSource {
//   List<SafetyInfromationModel> data = safetyInformation;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         // DataCell(Text(rowData.iD.toString())),
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//         // DataCell(Text(rowData.logo.toString())),
//         // DataCell(Text(rowData.companyName.toString())),
//         // DataCell(Text(rowData.process.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class PromotionalOffers extends StatefulWidget {
//   final String gtin;
//   const PromotionalOffers({super.key, required this.gtin});

//   @override
//   State<PromotionalOffers> createState() => _PromotionalOffersState();
// }

// class _PromotionalOffersState extends State<PromotionalOffers> {
//   @override
//   void initState() {
//     DigitalLinksController()
//         .getDigitalLinksData("promotional-offers", widget.gtin)
//         // ProductInformationController.getPromotionalOffer(widget.gtin)
//         .then((value) {
//       promotionalOffer = value as List<PromotionalOfferModel>;
//       setState(() {});
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         // DataColumn(label: Text("Id")),
//         DataColumn(label: Text("Link Title")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target URL")),
//         DataColumn(label: Text("Mime Type")),
//         // DataColumn(label: Text("Expiry Date")),
//         // DataColumn(label: Text("Price")),
//         // DataColumn(label: Text("Banner")),
//       ],
//       source: PromotionalOfferSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class PromotionalOfferSource extends DataTableSource {
//   List<PromotionalOfferModel> data = promotionalOffer;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         // DataCell(Text(rowData.id.toString())),
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//         // DataCell(Text(rowData.expiryDate.toString())),
//         // DataCell(Text(rowData.price.toString())),
//         // DataCell(Text(rowData.banner.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class ProductContents extends StatefulWidget {
//   final String gtin;
//   const ProductContents({super.key, required this.gtin});

//   @override
//   State<ProductContents> createState() => _ProductContentsState();
// }

// class _ProductContentsState extends State<ProductContents> {
//   @override
//   void initState() {
//     super.initState();

//     DigitalLinksController()
//         .getDigitalLinksData(
//       "product-contents",
//       widget.gtin,
//     )
//         // ProductInformationController.getProductContents(widget.gtin)
//         .then((value) {
//       productContents = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         // DataColumn(label: Text("Id")),
//         // DataColumn(label: Text("Product Allergen Information")),
//         // DataColumn(label: Text("Product Nutrient Information")),
//         DataColumn(label: Text("link Title")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target Url")),
//         DataColumn(label: Text("Mime Type")),
//         // DataColumn(label: Text("Manufecturing Date")),
//         // DataColumn(label: Text("Best Before")),
//         // DataColumn(label: Text("GLNID Form")),
//         // DataColumn(label: Text("Unit Price")),
//         // DataColumn(label: Text("Ingredients")),
//         // DataColumn(label: Text("Allergen Info")),
//         // DataColumn(label: Text("Calories")),
//         // DataColumn(label: Text("Sugar")),
//         // DataColumn(label: Text("Salt")),
//         // DataColumn(label: Text("Fat")),
//       ],
//       source: ProductContentsSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class ProductContentsSource extends DataTableSource {
//   List<ProductContentsModel> data = productContents;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         // DataCell(Text(rowData.iD.toString())),
//         // DataCell(Text(rowData.productAllergenInformation.toString())),
//         // DataCell(Text(rowData.productNutrientsInformation.toString())),
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//         // DataCell(Text(rowData.manufacturingDate.toString())),
//         // DataCell(Text(rowData.bestBeforeDate.toString())),
//         // DataCell(Text(rowData.gLNIDFrom.toString())),
//         // DataCell(Text(rowData.unitPrice.toString())),
//         // DataCell(Text(rowData.ingredients.toString())),
//         // DataCell(Text(rowData.allergenInfo.toString())),
//         // DataCell(Text(rowData.calories.toString())),
//         // DataCell(Text(rowData.sugar.toString())),
//         // DataCell(Text(rowData.salt.toString())),
//         // DataCell(Text(rowData.fat.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class ProductLocationOfOrigin extends StatefulWidget {
//   final String gtin;
//   const ProductLocationOfOrigin({super.key, required this.gtin});

//   @override
//   State<ProductLocationOfOrigin> createState() =>
//       _ProductLocationOfOriginState();
// }

// class _ProductLocationOfOriginState extends State<ProductLocationOfOrigin> {
//   @override
//   void initState() {
//     super.initState();

//     ProductInformationController.getProductLocationOrigin(widget.gtin)
//         .then((value) {
//       locationOrigin = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         DataColumn(label: Text("Id")),
//         DataColumn(label: Text("Product Location Origin")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target URL")),
//         DataColumn(label: Text("GTIN")),
//         DataColumn(label: Text("Expiry Date")),
//       ],
//       source: ProductLocationOriginSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class ProductLocationOriginSource extends DataTableSource {
//   List<LocationOriginModel> data = locationOrigin;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(rowData.iD.toString())),
//         DataCell(Text(rowData.productLocationOrigin.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.lang.toString())),
//         DataCell(Text(rowData.targetURL.toString())),
//         DataCell(Text(rowData.gTIN.toString())),
//         DataCell(Text(rowData.expiryDate.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class ProductRecall extends StatefulWidget {
//   final String gtin;
//   const ProductRecall({super.key, required this.gtin});

//   @override
//   State<ProductRecall> createState() => _ProductRecallState();
// }

// class _ProductRecallState extends State<ProductRecall> {
//   @override
//   void initState() {
//     super.initState();

//     DigitalLinksController()
//         .getDigitalLinksData(
//       "product-recall",
//       widget.gtin,
//     )
//         // ProductInformationController.getProductRecallByGtin(widget.gtin)
//         .then((value) {
//       productRecall = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         // DataColumn(label: Text("Id")),
//         DataColumn(label: Text("Link Title")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target URL")),
//         DataColumn(label: Text("Mime Type")),
//         // DataColumn(label: Text("Expiry Date")),
//       ],
//       source: ProductRecallSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class ProductRecallSource extends DataTableSource {
//   List<SafetyInfromationModel> data = productRecall;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         // DataCell(Text(rowData.iD.toString())),
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//         // DataCell(Text(rowData.expiryDate.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class Recipe extends StatefulWidget {
//   final String gtin;
//   const Recipe({super.key, required this.gtin});

//   @override
//   State<Recipe> createState() => _RecipeState();
// }

// class _RecipeState extends State<Recipe> {
//   @override
//   void initState() {
//     super.initState();

//     DigitalLinksController()
//         .getDigitalLinksData(
//       "recipe",
//       widget.gtin,
//     )
//         // ProductInformationController.getRecipeByGtin(widget.gtin)
//         .then((value) {
//       recipe = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         // DataColumn(label: Text("Id")),
//         // DataColumn(label: Text("Logo")),
//         // DataColumn(label: Text("Title")),
//         // DataColumn(label: Text("Description")),
//         DataColumn(label: Text("Link Title")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target Url")),
//         DataColumn(label: Text("Mime Type")),
//       ],
//       source: RecipeSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class RecipeSource extends DataTableSource {
//   List<RecipeModel> data = recipe;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//         // DataCell(Text(rowData.ingredients.toString())),
//         // DataCell(Text(rowData.gTIN.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class PackagingComposition extends StatefulWidget {
//   final String gtin;
//   const PackagingComposition({super.key, required this.gtin});

//   @override
//   State<PackagingComposition> createState() => _PackagingCompositionState();
// }

// class _PackagingCompositionState extends State<PackagingComposition> {
//   @override
//   void initState() {
//     super.initState();

//     DigitalLinksController()
//         .getDigitalLinksData(
//       "packaging-composition",
//       widget.gtin,
//     )
//         // ProductInformationController.getPackagingCompositionByGtin(widget.gtin)
//         .then((value) {
//       packagingComposition = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         // DataColumn(label: Text("Id")),
//         // DataColumn(label: Text("Logo")),
//         // DataColumn(label: Text("Title")),
//         // DataColumn(label: Text("Consumer Product Variant")),
//         // DataColumn(label: Text("Packaging")),
//         // DataColumn(label: Text("Material")),
//         // DataColumn(label: Text("Recyclability")),
//         DataColumn(label: Text("Link Title")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target Url")),
//         DataColumn(label: Text("Mime Type")),
//       ],
//       source: PackagingCompositionSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class PackagingCompositionSource extends DataTableSource {
//   List<ProductContentsModel> data = packagingComposition;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         // DataCell(Text(rowData.iD.toString())),
//         // DataCell(Text(rowData.logo.toString())),
//         // DataCell(Text(rowData.title.toString())),
//         // DataCell(Text(rowData.consumerProductVariant.toString())),
//         // DataCell(Text(rowData.packaging.toString())),
//         // DataCell(Text(rowData.material.toString())),
//         // DataCell(Text(rowData.recyclability.toString())),
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class ElectronicLeaflets extends StatefulWidget {
//   final String gtin;
//   const ElectronicLeaflets({super.key, required this.gtin});

//   @override
//   State<ElectronicLeaflets> createState() => _ElectronicLeafletsState();
// }

// class _ElectronicLeafletsState extends State<ElectronicLeaflets> {
//   @override
//   void initState() {
//     super.initState();

//     DigitalLinksController()
//         .getDigitalLinksData(
//       "electronic-leaflets",
//       widget.gtin,
//     )
//         // ProductInformationController.getLeafletsByGtin(widget.gtin)
//         .then((value) {
//       leaflets = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: const [
//         // DataColumn(label: Text("Id")),
//         // DataColumn(label: Text("Product Leaflets Information")),
//         DataColumn(label: Text("Link Title")),
//         DataColumn(label: Text("Link Type")),
//         DataColumn(label: Text("Language")),
//         DataColumn(label: Text("Target Url")),
//         DataColumn(label: Text("Mime Type")),
//       ],
//       source: LeafletsSource(),
//       arrowHeadColor: AppColors.green,
//       showCheckboxColumn: false,
//       rowsPerPage: 5,
//     );
//   }
// }

// class LeafletsSource extends DataTableSource {
//   List<ProductContentsModel> data = leaflets;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         // DataCell(Text(rowData.iD.toString())),
//         // DataCell(Text(rowData.productLeafletInformation.toString())),
//         DataCell(Text(rowData.linkTitle.toString())),
//         DataCell(Text(rowData.linkType.toString())),
//         DataCell(Text(rowData.language.toString())),
//         DataCell(Text(rowData.targetUrl.toString())),
//         DataCell(Text(rowData.mimeType.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }
