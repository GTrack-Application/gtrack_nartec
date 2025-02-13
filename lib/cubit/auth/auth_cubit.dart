import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/auth/auth_controller.dart';
import 'package:gtrack_nartec/cubit/auth/auth_state.dart';
import 'package:gtrack_nartec/models/auth/LoginResponseModel.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(
    String email,
    String password,
    String activity,
  ) async {
    emit(LoginLoading());
    try {
      LoginResponseModel model =
          await AuthController.completeLogin(email, password, activity);
      emit(LoginSuccess(model));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
