import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class AssetDetailsScreen extends StatelessWidget {
  const AssetDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Details'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: ItemDetailsCubit.get(context).assetIdController,
                labelText: 'AssetIdNo',
              ),
              CustomTextField(
                controller: ItemDetailsCubit.get(context).tagNoController,
                labelText: 'TagNo',
              ),
              CustomTextField(
                controller: ItemDetailsCubit.get(context).descriptionController,
                labelText: 'Asset Description',
              ),
              CustomTextField(
                controller: ItemDetailsCubit.get(context).classController,
                labelText: 'Asset Class',
              ),
              CustomTextField(
                controller: ItemDetailsCubit.get(context).locationController,
                labelText: 'Asset GLNLocation',
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (!ItemDetailsCubit.get(context).isEmptyTextField()) {
                        ItemDetailsCubit.get(context).addAssetDetails();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 40,
                width: double.infinity,
                alignment: Alignment.center,
                color: AppColors.pink,
                child: const Text(
                  'List of Assets',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              BlocConsumer<ItemDetailsCubit, ItemDetailsState>(
                listener: (context, state) {
                  if (state is ItemDetailsAssetDetailsSuccess) {
                    ItemDetailsCubit.get(context).assets.add(state.asset);
                    ItemDetailsCubit.get(context).clearTextFields();
                  } else if (state is ItemDetailsAssetDetailsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    shrinkWrap: true, // Add this line
                    physics:
                        const NeverScrollableScrollPhysics(), // Add this line
                    itemCount: ItemDetailsCubit.get(context).assets.length,
                    itemBuilder: (context, index) {
                      final asset = ItemDetailsCubit.get(context).assets[index];
                      return Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.pink,
                              child: Text((index + 1).toString()),
                            ),
                            title: Text(asset.assetId),
                            subtitle: Text(asset.tagNo),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                ItemDetailsCubit.get(context)
                                    .deleteAsset(index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
