abstract class CreateBundleState {}

class CreateBundleInitial extends CreateBundleState {}

class CreateBundleLoading extends CreateBundleState {}

class CreateBundleLoaded extends CreateBundleState {}

class CreateBundleError extends CreateBundleState {
  final String message;

  CreateBundleError({required this.message});
}
