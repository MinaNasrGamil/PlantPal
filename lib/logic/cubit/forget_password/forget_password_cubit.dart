import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/enums.dart';
import '../../../data/repositories/auth_repository.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository _authRepository;
  ForgetPasswordCubit(this._authRepository)
      : super(ForgetPasswordState.inital());

  Future<void> sendPasswordResetEmail(String email) async {
    emit(state.copyWith(
      email: email,
    ));

    try {
      await _authRepository
          .sendPasswordResetEmail(
        email: state.email,
      )
          .then(
        (_) {
          emit(state.copyWith(
              forgetPasswordStatus: ForgetPasswordStatus.success));
        },
      );
    } on FirebaseAuthException catch (error) {
      print('Error from loginWithCredentials: ${error.message}');
      emit(state.copyWith(
        forgetPasswordStatus: ForgetPasswordStatus.error,
        errorMessege: error.message,
      ));
      // Handle the error here
    }
  }
}
