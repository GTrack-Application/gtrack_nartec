import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';

class GTINScreenV2 extends StatefulWidget {
  const GTINScreenV2({super.key});

  @override
  State<GTINScreenV2> createState() => _GTINScreenV2State();
}

class _GTINScreenV2State extends State<GTINScreenV2> {
  TextEditingController searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  late GtinCubit gtinCubit;

  @override
  void initState() {
    super.initState();
    gtinCubit = context.read<GtinCubit>();
    _scrollController.addListener(_onScroll);
    gtinCubit.getProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<GtinCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTIN'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SafeArea(
        child: BlocBuilder<GtinCubit, GtinState>(
          builder: (context, state) {
            if (state is GtinLoadingState) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5, // Show 5 placeholder cards
                itemBuilder: (context, index) => _buildPlaceholderCard(),
              );
            }

            if (state is GtinErrorState) {
              return Center(child: Text(state.message));
            }

            List<GTIN_Model> products = [];
            bool hasMore = false;

            if (state is GtinLoadedState) {
              products = state.data;
              hasMore = state.hasMoreData;
            } else if (state is GtinLoadingMoreState) {
              products = state.currentData;
              hasMore = state.hasMoreData;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         AppNavigator.goToPage(
                  //           context: context,
                  //           screen: const AddGtinScreen(),
                  //         );
                  //       },
                  //       child: Container(
                  //         width: 100,
                  //         height: 40,
                  //         decoration: BoxDecoration(
                  //           color: Colors.grey[200],
                  //           borderRadius: BorderRadius.circular(50),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               'assets/icons/add_Icon.png',
                  //               width: 20,
                  //               height: 20,
                  //             ),
                  //             const SizedBox(width: 5),
                  //             Text(
                  //               'Add',
                  //               style: TextStyle(
                  //                 color: Colors.green[700],
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Expanded(
                  //       child: TextField(
                  //         controller: searchController,
                  //         onChanged: (value) {
                  //           if (value.isNotEmpty) {
                  //             setState(() {
                  //               productsFiltered = products
                  //                   .where((element) => element.barcode
                  //                       .toString()
                  //                       .toLowerCase()
                  //                       .contains(value.toLowerCase()))
                  //                   .toList();
                  //             });
                  //           } else {
                  //             setState(() {
                  //               productsFiltered = products;
                  //             });
                  //           }
                  //         },
                  //         decoration: const InputDecoration(
                  //           suffixIcon: Icon(Ionicons.search_outline),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "GTIN List",
                  //         style: TextStyle(fontSize: 18),
                  //       ),
                  //       Icon(
                  //         Ionicons.filter_outline,
                  //         size: 30,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<GtinCubit>().refresh();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: products.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == products.length) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }

                          return ProductCard(product: products[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildPlaceholderCard() {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status bar placeholder
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                // GTIN number placeholder
                Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                // Product details placeholders
                ...List.generate(
                  6,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final GTIN_Model product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isVerified = product.gepirPosted == "1";
    return Card(
      color: Color(0xFFFFFBEB),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.skyBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Actions Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Text(
                  isVerified ? 'Verified' : 'Un-Verified',
                  style: TextStyle(
                    color: isVerified ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // QR Code
                Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=50x50&data=${product.barcode}',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                // Action Icons
                Icon(Icons.visibility_outlined,
                    size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Icon(Icons.edit_outlined, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Icon(Icons.copy_outlined, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.skyBlue, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        isVerified ? AppColors.green : AppColors.danger,
                    child: Icon(
                      isVerified ? Icons.check : Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              if (product.frontImage != null)
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  child: CachedNetworkImage(
                    imageUrl: '${AppUrls.gs1Url}${product.frontImage}',
                    fit: BoxFit.contain,
                    errorWidget: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 40,
                    ),
                  ),
                ),
              // Product Information
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              'GTIN: ${product.barcode ?? ""}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Brand Name:', product.brandName),
                            _buildInfoRow('Product Description:',
                                product.productnameenglish),
                            _buildInfoRow('GPC:', product.gpc),
                            _buildInfoRow('Country of Origin:', product.origin),
                            _buildInfoRow(
                                'Country of Sale:', product.countrySale),
                            _buildInfoRow('Net Content:',
                                '${product.size} ${product.unit}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'N/A',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Icon(
                  value != null ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: value != null ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
