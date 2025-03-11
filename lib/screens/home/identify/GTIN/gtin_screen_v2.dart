import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/card/gtin_card.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_field_widget.dart';
import 'package:gtrack_nartec/screens/home/identify/GTIN/digital_link_view_data_screen.dart';

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
    gtinCubit = GtinCubit.get(context);
    _scrollController.addListener(_onScroll);
    gtinCubit.getProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      gtinCubit.loadMore(
        searchQuery: gtinCubit.searchController.text.isNotEmpty
            ? gtinCubit.searchController.text
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<GTIN_Model> products = [];
    // bool hasMore = false;
    final products = gtinCubit.products;
    bool hasMore = gtinCubit.hasMoreData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTIN'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SafeArea(
        child: BlocConsumer<GtinCubit, GtinState>(
          listener: (context, state) {
            // if (state is GtinLoadedState) {
            //   products = state.data;
            //   hasMore = state.hasMoreData;
            // } else if (state is GtinLoadingMoreState) {
            //   products = state.currentData;
            //   hasMore = state.hasMoreData;
            // }
          },
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

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFieldWidget(
                          controller: gtinCubit.searchController,
                          hintText: "Search by GTIN",
                        ),
                      ),
                      Expanded(
                        child: PrimaryButtonWidget(
                          text: "Search",
                          backgroungColor: AppColors.skyBlue,
                          isLoading: state is GtinLoadingState,
                          onPressed: () {
                            gtinCubit.getProducts(
                              searchQuery: gtinCubit.searchController.text,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (gtinCubit.searchController.text.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 8.0,
                      children: [
                        const Spacer(),
                        Expanded(
                          child: PrimaryButtonWidget(
                            text: "Clear",
                            height: 35,
                            backgroungColor: AppColors.skyBlue,
                            onPressed: () {
                              gtinCubit.searchController.clear();
                              gtinCubit.getProducts();
                            },
                          ),
                        ),
                      ],
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        gtinCubit.refresh();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: products.length +
                            (hasMore && state is GtinLoadingMoreState ? 1 : 0),
                        itemBuilder: (context, index) {
                          final isMoreLoading = state is GtinLoadingMoreState &&
                              index == products.length;
                          if (isMoreLoading) {
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
                          final product = products[index];
                          return GtinProductCard(
                            product: products[index],
                            borderColor: AppColors.grey,
                            backgroundColor: Color(0xFFFFFBEB),
                            onTap: () {
                              AppNavigator.goToPage(
                                  context: context,
                                  screen: DigitalLinkViewDataScreen(
                                    barcode: product.barcode ?? '',
                                    gtin: product,
                                  ));
                            },
                          );
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
              color: AppColors.grey.withValues(alpha: 0.1),
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
                    color: AppColors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                // GTIN number placeholder
                Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.1),
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
                            color: AppColors.grey.withValues(alpha: 0.1),
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
                                  color: AppColors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withValues(alpha: 0.1),
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
