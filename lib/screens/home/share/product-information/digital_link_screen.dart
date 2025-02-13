import 'package:flutter/material.dart';
import 'package:gtrack_nartec/controllers/share/product_information/digital_links_controller.dart';
import 'package:gtrack_nartec/controllers/share/product_information/product_information_controller.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/share/product_information/location_origin_model.dart';
import 'package:gtrack_nartec/models/share/product_information/product_contents_model.dart';
import 'package:gtrack_nartec/models/share/product_information/promotional_offer_model.dart';
import 'package:gtrack_nartec/models/share/product_information/recipe_model.dart';
import 'package:gtrack_nartec/models/share/product_information/safety_information_model.dart';
import 'package:gtrack_nartec/screens/home/share/product-information/codification_screen.dart';

// Some global variables
List<SafetyInfromationModel> safetyInformation = [];
List<PromotionalOfferModel> promotionalOffer = [];
List<ProductContentsModel> productContents = [];
List<LocationOriginModel> locationOrigin = [];
List<SafetyInfromationModel> productRecall = [];
List<RecipeModel> recipe = [];
List<ProductContentsModel> packagingComposition = [];
List<ProductContentsModel> leaflets = [];

class DigitalLinkScreen extends StatefulWidget {
  final String gtin;
  const DigitalLinkScreen({super.key, required this.gtin});

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
    screens.insert(0, SafetyInformation(gtin: widget.gtin));
    screens.insert(1, PromotionalOffers(gtin: widget.gtin));
    screens.insert(2, ProductContents(gtin: widget.gtin));
    screens.insert(3, ProductLocationOfOrigin(gtin: widget.gtin));
    screens.insert(4, ProductRecall(gtin: widget.gtin));
    screens.insert(5, Recipe(gtin: widget.gtin));
    screens.insert(6, PackagingComposition(gtin: widget.gtin));
    screens.insert(7, ElectronicLeaflets(gtin: widget.gtin));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Create list of radio list based on above data variable but we will be able to select only one at a time.
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
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
            const Divider(thickness: 2, color: AppColors.green),
            Text(
              data[selectedIndex],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            screens[selectedIndex],
          ],
        ),
      ),
    );
  }
}

class SafetyInformation extends StatefulWidget {
  final String gtin;
  const SafetyInformation({super.key, required this.gtin});

  @override
  State<SafetyInformation> createState() => _SafetyInformationState();
}

class _SafetyInformationState extends State<SafetyInformation> {
  List<SafetyInfromationModel> getInfrom = [];

  @override
  void initState() {
    DigitalLinksController()
        .getDigitalLinksData(
      "safety-information",
      widget.gtin,
    )
        // SafetyInfromationController.getSafeInfromation(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}

class PromotionalOffers extends StatefulWidget {
  final String gtin;
  const PromotionalOffers({super.key, required this.gtin});

  @override
  State<PromotionalOffers> createState() => _PromotionalOffersState();
}

class _PromotionalOffersState extends State<PromotionalOffers> {
  List<PromotionalOfferModel> getInfrom = [];

  @override
  void initState() {
    DigitalLinksController()
        .getDigitalLinksData("promotional-offers", widget.gtin)
        // ProductInformationController.getPromotionalOffer(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}

class ProductContents extends StatefulWidget {
  final String gtin;
  const ProductContents({super.key, required this.gtin});

  @override
  State<ProductContents> createState() => _ProductContentsState();
}

class _ProductContentsState extends State<ProductContents> {
  List<ProductContentsModel> getInfrom = [];

  @override
  void initState() {
    super.initState();

    DigitalLinksController()
        .getDigitalLinksData(
      "product-contents",
      widget.gtin,
    )
        // ProductInformationController.getProductContents(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}

class ProductLocationOfOrigin extends StatefulWidget {
  final String gtin;
  const ProductLocationOfOrigin({super.key, required this.gtin});

  @override
  State<ProductLocationOfOrigin> createState() =>
      _ProductLocationOfOriginState();
}

class _ProductLocationOfOriginState extends State<ProductLocationOfOrigin> {
  List<LocationOriginModel> getInfrom = [];

  @override
  void initState() {
    super.initState();

    ProductInformationController.getProductLocationOrigin(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "ID: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].iD.toString(),
          ),
          BorderedRowWidget(
            value1: "Product Location Origin: ",
            value2: getInfrom.isEmpty
                ? ""
                : getInfrom[0].productLocationOrigin ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].lang ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetURL ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "GTIN: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].gTIN ?? "",
          ),
          BorderedRowWidget(
            value1: "Expiry Date: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].expiryDate ?? "",
          ),
        ],
      ),
    );
  }
}

class ProductRecall extends StatefulWidget {
  final String gtin;
  const ProductRecall({super.key, required this.gtin});

  @override
  State<ProductRecall> createState() => _ProductRecallState();
}

class _ProductRecallState extends State<ProductRecall> {
  List<SafetyInfromationModel> getInfrom = [];

  @override
  void initState() {
    super.initState();

    DigitalLinksController()
        .getDigitalLinksData(
      "product-recall",
      widget.gtin,
    )
        // ProductInformationController.getProductRecallByGtin(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}

class Recipe extends StatefulWidget {
  final String gtin;
  const Recipe({super.key, required this.gtin});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  List<RecipeModel> getInfrom = [];

  @override
  void initState() {
    super.initState();

    DigitalLinksController()
        .getDigitalLinksData(
      "recipe",
      widget.gtin,
    )
        // ProductInformationController.getRecipeByGtin(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}

class PackagingComposition extends StatefulWidget {
  final String gtin;
  const PackagingComposition({super.key, required this.gtin});

  @override
  State<PackagingComposition> createState() => _PackagingCompositionState();
}

class _PackagingCompositionState extends State<PackagingComposition> {
  List<ProductContentsModel> getInfrom = [];
  @override
  void initState() {
    super.initState();

    DigitalLinksController()
        .getDigitalLinksData(
      "packaging-composition",
      widget.gtin,
    )
        // ProductInformationController.getPackagingCompositionByGtin(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}

class ElectronicLeaflets extends StatefulWidget {
  final String gtin;
  const ElectronicLeaflets({super.key, required this.gtin});

  @override
  State<ElectronicLeaflets> createState() => _ElectronicLeafletsState();
}

class _ElectronicLeafletsState extends State<ElectronicLeaflets> {
  List<ProductContentsModel> getInfrom = [];

  @override
  void initState() {
    super.initState();

    DigitalLinksController()
        .getDigitalLinksData(
      "electronic-leaflets",
      widget.gtin,
    )
        // ProductInformationController.getLeafletsByGtin(widget.gtin)
        .then((value) {
      setState(() {
        getInfrom = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          BorderedRowWidget(
            value1: "Link Title: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkTitle ?? "",
          ),
          BorderedRowWidget(
            value1: "Link Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].linkType ?? "",
          ),
          BorderedRowWidget(
            value1: "Language: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].language ?? "",
          ),
          BorderedRowWidget(
            value1: "Target URL: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].targetUrl ?? "",
          ),
          BorderedRowWidget(
            value1: "Mime Type: ",
            value2: getInfrom.isEmpty ? "" : getInfrom[0].mimeType ?? "",
          ),
        ],
      ),
    );
  }
}
