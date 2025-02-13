import 'package:gtrack_nartec/models/Identify/GLN/GLNProductsModel.dart';

abstract class GlnState {}

class GlnInitState extends GlnState {}

class GlnLoadingState extends GlnState {}

class GlnLoadedState extends GlnState {
  List<GLNProductsModel> data = [];

  GlnLoadedState({required this.data});
}

class GlnDeleteState extends GlnState {}

class GlnErrorState extends GlnState {
  final String message;

  GlnErrorState({required this.message});
}
