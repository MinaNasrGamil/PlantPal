import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/enums.dart';
import '../../../data/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit(this._authRepository) : super(SignupState.inital());

  Future<void> signupFormSubmitted(
      String email, String password, String username) async {
    if (state.signupStatus == SignupStatus.submiting) return;
    emit(state.copyWith(
      email: email,
      password: password,
      signupStatus: SignupStatus.submiting,
    ));

    // ignore: lines_longer_than_80_chars
    //!may be an error becous i added email and pass in this fun but att the video he made a emailChang and passchange
    try {
      await _authRepository.signup(
        email: state.email,
        password: state.password,
        username: username,
      );
      emit(state.copyWith(signupStatus: SignupStatus.success));
    } on FirebaseAuthException catch (error) {
      print('Error from loginWithCredentials: ${error.message}');
      emit(state.copyWith(
          signupStatus: SignupStatus.error, errorMessege: error.message));
    }
  }
}
