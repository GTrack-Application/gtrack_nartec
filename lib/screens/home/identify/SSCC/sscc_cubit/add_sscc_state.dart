abstract class AddSSCCState {}

class AddSSCCInitial extends AddSSCCState {}

class AddSSCCLoading extends AddSSCCState {}

class AddSSCCError extends AddSSCCState {
  final String error;
  AddSSCCError({required this.error});
}

class AddSSCCAddedByPallet extends AddSSCCState {}

class AddSSCCAddedByLabel extends AddSSCCState {}
