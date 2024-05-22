import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/capture/association/transfer/capture_cubit.dart';
import 'package:searchable_listview/searchable_listview.dart';

class SerializationScreen extends StatelessWidget {
  const SerializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serialization"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                // rounded button
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      CaptureCubit.get(context).getSerializationData();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
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

                  return SearchableList(
                    filter: (query) => CaptureCubit.get(context)
                        .serializationData
                        .where((item) {
                      // Filter it based on the following fields
                      /*
                          1. Batch No.
                          2. Expiry Date
                          3. Serial
                      */
                      return item.bATCH!.contains(query) ||
                          item.eXPIRYDATE!.contains(query) ||
                          item.serialNo!.contains(query);
                    }).toList(),
                    inputDecoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    initialList: CaptureCubit.get(context).serializationData,
                    itemBuilder: (item) => Card(
                      child: ListTile(
                        title: Text(item.bATCH.toString()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
