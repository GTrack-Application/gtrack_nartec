abstract class CompletePackingState {} 

class CompletePackingInitial extends CompletePackingState {} 

class CompletePackingLoading extends CompletePackingState {} 

class CompletePackingLoaded extends CompletePackingState {} 

class CompletePackingError extends CompletePackingState {
  final String message;

  CompletePackingError({required this.message});
}