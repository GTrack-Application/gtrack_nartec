part of 'packaging_cubit.dart';

abstract class PackagingState {}

class PackagingInitial extends PackagingState {}

class PackagingScanLoading extends PackagingState {}

class PackagingScanLoaded extends PackagingState {}

class PackagingScanError extends PackagingState {
  final String message;
  PackagingScanError({required this.message});
}

class PackagingInsertLoading extends PackagingState {}

class PackagingInsertLoaded extends PackagingState {}

class PackagingInsertError extends PackagingState {
  final String message;
  PackagingInsertError({required this.message});
}

class PackagingMasterLoading extends PackagingState {}

class PackagingMasterLoaded extends PackagingState {
  final List<PackagingMasterModel> packages;
  final bool hasReachedEnd;

  PackagingMasterLoaded({
    required this.packages,
    required this.hasReachedEnd,
  });
}

class PackagingMasterError extends PackagingState {
  final String message;
  PackagingMasterError({required this.message});
}
