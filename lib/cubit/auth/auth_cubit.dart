import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/auth/auth_controller.dart';
import 'package:gtrack_mobile_app/cubit/auth/auth_state.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(
    String email,
    String password,
    String activity,
  ) async {
    emit(LoginLoading());
    try {
      bool networkStatus = await isNetworkAvailable();
      if (!networkStatus) {
        emit(LoginFailure('No Internet Connection'));
        return;
      }
      await AuthController.completeLogin(email, password, activity);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
