import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/transformation/transformation_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/transformation/transformation_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/features/capture/models/transformation/event_station_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Transformation/evnet_station/selected_event_station_screen.dart';

class EventStationScreen extends StatefulWidget {
  const EventStationScreen({super.key});

  @override
  State<EventStationScreen> createState() => _EventStationScreenState();
}

class _EventStationScreenState extends State<EventStationScreen> {
  late TransformationCubit _eventStationCubit;

  @override
  void initState() {
    super.initState();
    _eventStationCubit = context.read<TransformationCubit>();
    _eventStationCubit.getEventStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Station'),
        backgroundColor: AppColors.pink,
      ),
      body: BlocBuilder<TransformationCubit, TransformationState>(
        builder: (context, state) {
          if (state is EventStationLoadingState) {
            return _buildLoadingPlaceholders();
          } else if (state is EventStationErrorState) {
            return _buildErrorWidget(state);
          }
          return _buildEventStationGrid();
        },
      ),
    );
  }

  Center _buildErrorWidget(EventStationErrorState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.danger,
            size: 48,
          ),
          Text(
            'Error: ${state.message}',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholders() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: 6, // Show 6 placeholder cards
        itemBuilder: (context, index) => _buildPlaceholderCard(),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station name placeholder
            Container(
              height: 16,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // Subprocess name placeholder
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            // Bottom row placeholders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Main process name placeholder
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Date placeholder
                Container(
                  height: 10,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventStationGrid() {
    final stations = _eventStationCubit.stations;
    return stations.isEmpty
        ? const Center(child: Text('No event stations found'))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                return _buildEventStationCard(station);
              },
            ),
          );
  }

  Widget _buildEventStationCard(EventStation station) {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        splashColor: AppColors.pink.withValues(alpha: 0.2),
        onTap: () {
          AppNavigator.goToPage(
            context: context,
            screen: SelectedEventStationScreen(station: station),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: station.id,
                child: Text(
                  station.eventStationName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                station.eventStationSubProcess?.name ?? 'No subprocess',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              const Spacer(),
              // Flexible(
              //   child: Text(
              //     station.eventStationSubProcess?.eventStationMainProcess?.name ??
              //         'N/A',
              //     style: const TextStyle(fontSize: 12),
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      station.eventStationSubProcess?.eventStationMainProcess
                              ?.name ??
                          'N/A',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    station.createdAt.toString().substring(0, 10),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
