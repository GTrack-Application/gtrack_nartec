import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/screens/home/identify/GLN/add_gln_screen.dart';

class GlnScreenV2 extends StatefulWidget {
  const GlnScreenV2({super.key});

  @override
  State<GlnScreenV2> createState() => _GlnScreenV2State();
}

class _GlnScreenV2State extends State<GlnScreenV2> {
  final searchController = TextEditingController();
  late GlnCubit glnCubit;

  @override
  void initState() {
    super.initState();
    glnCubit = context.read<GlnCubit>();
    glnCubit.getGlnData();
  }

  @override
  Widget build(BuildContext context) {
    final glnList = glnCubit.glnList;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GLN',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.pink,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<GlnCubit, GlnState>(
        listener: (context, state) {
          if (state is GlnErrorState) {
            AppSnackbars.danger(context, state.message);
          } else if (state is GlnDeleteState) {
            context.read<GlnCubit>().getGlnData();
          }
        },
        builder: (context, state) {
          if (state is GlnLoadingState) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildPlaceholderCard();
              },
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: AddGlnScreen(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/add_Icon.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            TextFormFieldWidget(controller: searchController),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    glnCubit.getGlnData();
                  },
                  child: ListView.builder(
                    itemCount: glnList.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = glnList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: item.status == 'active'
                                          ? AppColors.green
                                          : AppColors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.status,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'GLN: ${item.glnBarcodeNumber}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Checkbox(
                                    value:
                                        glnCubit.selectedGlnList.contains(item),
                                    activeColor: AppColors.skyBlue,
                                    onChanged: (value) {
                                      glnCubit.selectGln(item);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.locationNameEn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item.locationNameAr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.addressEn,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: AppColors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Created: ${item.createdAt.substring(0, 10)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.edit,
                                        size: 14,
                                        color: AppColors.skyBlue,
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          // Edit functionality
                                        },
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.skyBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.delete_outline,
                                        size: 14,
                                        color: AppColors.danger,
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<GlnCubit>()
                                              .deleteGlnV2(item.id);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.danger,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and GLN number placeholder row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Status badge placeholder
                Container(
                  width: 80,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // GLN number placeholder
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Checkbox placeholder
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Location name placeholders
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // English name placeholder
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Arabic name placeholder
                Container(
                  height: 16,
                  width: double.infinity * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Address placeholders
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // English address header
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // English address placeholder
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Arabic address header
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Arabic address placeholder
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Coordinates placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 130,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Footer with date and actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date placeholder
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Actions placeholder
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
