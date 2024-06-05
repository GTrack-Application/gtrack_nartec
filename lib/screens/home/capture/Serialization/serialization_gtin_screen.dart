import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Serialization/create_serial_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:searchable_listview/searchable_listview.dart';

class SerializationGtinScreen extends StatefulWidget {
  final GTIN_Model gtinModel;
  const SerializationGtinScreen({super.key, required this.gtinModel});

  @override
  State<SerializationGtinScreen> createState() =>
      _SerializationGtinScreenState();
}

class _SerializationGtinScreenState extends State<SerializationGtinScreen> {
  @override
  void initState() {
    CaptureCubit.get(context)
        .getSerializationData(widget.gtinModel.barcode ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serialization"),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            10.height,
            _buildGTINText(context, widget.gtinModel.barcode ?? ''),
            10.height,
            _buildSerializationList(context),
            10.height,
            _buildCreateSerialsButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: TextField(
              controller: CaptureCubit.get(context).gtin,
              onSubmitted: (value) {
                CaptureCubit.get(context).getGtinProducts();
              },
              decoration: InputDecoration(
                hintText: 'Enter GTIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Hero(
          tag: widget.gtinModel.id ?? '',
          child: CircleAvatar(
            backgroundColor: AppColors.pink,
            foregroundColor: AppColors.white,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                CaptureCubit.get(context).getGtinProducts();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGTINText(BuildContext context, String gtin) {
    return BlocBuilder<CaptureCubit, CaptureState>(builder: (context, state) {
      return Text(
        "GTIN: $gtin",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.primary,
        ),
      );
    });
  }

  Widget _buildSerializationList(BuildContext context) {
    return Expanded(
      flex: 4,
      child:
          BlocConsumer<CaptureCubit, CaptureState>(listener: (context, state) {
        if (state is CaptureSerializationSuccess) {
          CaptureCubit.get(context).serializationData = state.data;
        }
      }, builder: (context, state) {
        if (state is CaptureSerializationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CaptureSerializationError) {
          return Center(child: Text(state.message));
        } else if (state is CaptureSerializationEmpty) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
            ),
            child: Center(
              child: Text(
                "No data found with ${CaptureCubit.get(context).gtin.text} GTIN",
              ),
            ),
          );
        }
        final serializationData = CaptureCubit.get(context).serializationData;
        return RefreshIndicator(
          onRefresh: () async {
            CaptureCubit.get(context)
                .getSerializationData(widget.gtinModel.barcode ?? '');
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
            ),
            child: SearchableList(
              shrinkWrap: true,
              filter: (query) {
                return serializationData.where((item) {
                  return item.bATCH!.contains(query) ||
                      item.eXPIRYDATE!.contains(query) ||
                      item.serialNo!.contains(query);
                }).toList();
              },
              inputDecoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              initialList: serializationData,
              itemBuilder: (item) {
                final index = serializationData.indexOf(item) + 1;
                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("$index", style: const TextStyle(fontSize: 12)),
                      Text("${item.serialNo}",
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCreateSerialsButton(context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement the create serials functionality
            AppNavigator.goToPage(
              context: context,
              screen: CreateSerialScreen(
                gtin: CaptureCubit.get(context).gtin.text,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pink,
            foregroundColor: AppColors.white,
          ),
          child: const Text(
            "Create Serials",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
