import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Serialization/create_serial_screen.dart';
import 'package:searchable_listview/searchable_listview.dart';

class SerializationScreen extends StatelessWidget {
  const SerializationScreen({super.key});

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
            const SizedBox(height: 8),
            _buildGTINText(context),
            _buildSerializationList(context),
            // if (CaptureCubit.get(context).serializationData.isNotEmpty)
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
              onChanged: (value) {
                CaptureCubit.get(context).gtin = value;
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
        CircleAvatar(
          backgroundColor: AppColors.pink,
          foregroundColor: AppColors.white,
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              CaptureCubit.get(context).getSerializationData();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGTINText(BuildContext context) {
    return BlocBuilder<CaptureCubit, CaptureState>(
      builder: (context, state) {
        final gtin = CaptureCubit.get(context).gtin;
        if (gtin.isNotEmpty) {
          return Text(
            "GTIN: $gtin",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppColors.primary,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSerializationList(BuildContext context) {
    return Expanded(
      flex: 4,
      child: BlocConsumer<CaptureCubit, CaptureState>(
        listener: (context, state) {
          if (state is CaptureSerializationSuccess) {
            CaptureCubit.get(context).serializationData = state.data;
          }
        },
        builder: (context, state) {
          if (state is CaptureSerializationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CaptureSerializationError) {
            return Center(child: Text(state.message));
          }

          final serializationData = CaptureCubit.get(context).serializationData;
          if (serializationData.isNotEmpty) {
            return Container(
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
                      border: Border.all(color: AppColors.skyBlue),
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCreateSerialsButton(context) {
    return Expanded(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              // Implement the create serials functionality
              AppNavigator.goToPage(
                context: context,
                screen: const CreateSerialScreen(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.white,
            ),
            child: const Text("Create Serials"),
          ),
        ],
      ),
    );
  }
}
