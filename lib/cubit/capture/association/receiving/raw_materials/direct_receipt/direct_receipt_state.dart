abstract class DirectReceiptState {}

class DirectReceiptInitial extends DirectReceiptState {}

class DirectReceiptLoading extends DirectReceiptState {}

class DirectReceiptLoaded extends DirectReceiptState {
  final List<Map<String, dynamic>> directReceiptModel;

  DirectReceiptLoaded({required this.directReceiptModel});
}

class DirectReceiptError extends DirectReceiptState {
  final String message;

  DirectReceiptError({required this.message});
}
