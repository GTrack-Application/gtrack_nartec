abstract class GLNState {}

class GLNInitial extends GLNState {}

class GLNLoading extends GLNState {}

class GLNLoaded extends GLNState {}

class GLNError extends GLNState {
  final String message;
  GLNError({required this.message});
}
