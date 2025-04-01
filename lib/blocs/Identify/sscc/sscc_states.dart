import 'package:gtrack_nartec/features/identify/models/IDENTIFY/SSCC/SsccModel.dart';

abstract class SsccState {}

class SsccInitState extends SsccState {}

class SsccLoadingState extends SsccState {}

class SsccLoadedState extends SsccState {
  List<SsccModel> data = [];

  SsccLoadedState({required this.data});
}

class SsccDeletedState extends SsccState {}

class SsccErrorState extends SsccState {
  final String message;

  SsccErrorState({required this.message});
}
