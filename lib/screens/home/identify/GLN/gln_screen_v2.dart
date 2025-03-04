import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class _GlnScreenV2State extends State<GlnScreenV2>
    with TickerProviderStateMixin {
  final searchController = TextEditingController();
  late GlnCubit glnCubit;
  late TabController _tabController;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    glnCubit = context.read<GlnCubit>();
    glnCubit.getGlnData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Refresh map when switching to map tab
      if (_tabController.index == 1) {
        glnCubit.updateMapMarkers();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GLN'),
        backgroundColor: AppColors.skyBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          tabs: const [
            Tab(text: 'GLN', icon: Icon(Icons.list)),
            Tab(text: 'Map', icon: Icon(Icons.map)),
          ],
          labelColor: AppColors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // GLN List Tab
          _buildGlnListTab(),

          // Map Tab
          _buildMapTab(),
        ],
      ),
    );
  }

  Widget _buildGlnListTab() {
    return BlocConsumer<GlnCubit, GlnState>(
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
                      child: TextFormFieldWidget(controller: searchController),
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
                  itemCount: glnCubit.glnList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = glnCubit.glnList[index];
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
                            color: AppColors.grey.withValues(alpha: 0.2),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    // const Icon(
                                    //   Icons.edit,
                                    //   size: 14,
                                    //   color: AppColors.skyBlue,
                                    // ),
                                    // const SizedBox(width: 4),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     // Edit functionality
                                    //   },
                                    //   child: const Text(
                                    //     'Edit',
                                    //     style: TextStyle(
                                    //       fontSize: 12,
                                    //       color: AppColors.skyBlue,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(width: 12),
                                    const Icon(
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
    );
  }

  Widget _buildMapTab() {
    return BlocConsumer<GlnCubit, GlnState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GlnLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        final markers = glnCubit.markers;

        // Default center position (Riyadh, Saudi Arabia)
        const defaultCenter = LatLng(24.7136, 46.6753);

        // Try to get center from first marker if available
        LatLng center = defaultCenter;
        if (markers.isNotEmpty) {
          center = markers.first.position;
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 12,
          ),
          markers: markers,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
        );
      },
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.2),
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
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 16,
              width: 150,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 60,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
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
  }
}
