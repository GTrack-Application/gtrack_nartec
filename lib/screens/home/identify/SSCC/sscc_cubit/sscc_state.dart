abstract class SSCCState {}

class SsccInitial extends SSCCState {}

class SsccLoading extends SSCCState {}

class SsccLoaded extends SSCCState {}

class SsccDeleted extends SSCCState {}

class SsccError extends SSCCState {
  final String error;
  SsccError({required this.error});
}
