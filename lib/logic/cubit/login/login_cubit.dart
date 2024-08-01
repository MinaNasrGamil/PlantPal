import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/enums.dart';
import '../../../data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super((LoginState.inital()));

  Future<void> loginWithCredentials(String email, String password) async {
    print('login heeereee');
    if (state.loginStatus == LoginStatus.submiting) return;
    emit(state.copyWith(
      email: email,
      password: password,
      loginStatus: LoginStatus.submiting,
    ));

    try {
      await _authRepository
          .loginWithEmailAndPassword(
        email: state.email,
        password: state.password,
      )
          .then(
        (_) {
          emit(state.copyWith(loginStatus: LoginStatus.success));
        },
      );
    } on FirebaseAuthException catch (error) {
      print('Error from loginWithCredentials: ${error.message}');
      emit(state.copyWith(
          loginStatus: LoginStatus.error, errorMessege: error.message));
      // Handle the error here
    }
  }
}
