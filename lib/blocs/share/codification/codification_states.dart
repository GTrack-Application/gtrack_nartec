import 'package:gtrack_nartec/models/share/product_information/SearchGpcForCodification.dart';

abstract class CodificationState {}

class CodificationInitial extends CodificationState {}

class CodificationLoading extends CodificationState {}

class CodificationLoaded extends CodificationState {
  final SearchGpcForCodification data;
  CodificationLoaded({required this.data});
}

class CodificationError extends CodificationState {
  final String error;
  CodificationError({required this.error});
}
