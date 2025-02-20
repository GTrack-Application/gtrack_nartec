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
