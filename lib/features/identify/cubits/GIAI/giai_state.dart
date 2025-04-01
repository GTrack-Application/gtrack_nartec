import 'package:gtrack_nartec/features/identify/models/IDENTIFY/GIAI/giai_model.dart';

class GIAIState {}

class GIAIInitial extends GIAIState {}

class GIAIGetGIAILoading extends GIAIState {}

class GIAIGetGIAISuccess extends GIAIState {
  final List<GIAIModel> giai;

  GIAIGetGIAISuccess({required this.giai});
}

class GIAIGetGIAIError extends GIAIState {
  final String message;

  GIAIGetGIAIError({required this.message});
}

class GIAIDeleteGIAILoading extends GIAIState {}

class GIAIDeleteGIAISuccess extends GIAIState {}

class GIAIDeleteGIAIError extends GIAIState {
  final String message;

  GIAIDeleteGIAIError({required this.message});
}
