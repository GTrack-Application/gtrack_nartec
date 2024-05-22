import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_cubit.dart';
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
            Container(
              height: 45,
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Scan GTIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
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
            const Divider(),
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
                    // filter: (query) =>
                    //     GtinCubit.get(context).data.where((item) {
                    //   // Filter it based on the following fields
                    //   /*
                    //       1. Batch No.
                    //       2. Expiry Date
                    //       3. Serial
                    //   */
                    //   return item.batchNo.contains(query) ||
                    //       item.expiryDate.contains(query) ||
                    //       item.serial.contains(query);

                    // }).toList(),
                    inputDecoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                    ),
                    initialList: GtinCubit.get(context).data,
                    itemBuilder: (item) => Card(
                      child: ListTile(
                        title: Text(item.status.toString()),
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
