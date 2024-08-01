import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../constants/enums.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  StreamSubscription<User>? _userSubscription;

  AppBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(authRepository.currentUser.isNotEmpty
            ? AppState.authenticated(
                authRepository.currentUser,
                authRepository.isVerified()
                    ? VerificationcStatus.verified
                    : VerificationcStatus.notVerified,
              )
            : const AppState.unAuthenticated()) {
    on<AppUserChanged>(_onUserChange);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppEmailVerifyRequested>(_onEmailVerifyRequested);
    _userSubscription = _authRepository.user.listen(
      (event) => add(AppUserChanged(event)),
    );
  }
  void _onUserChange(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    print('in onUserChange isEmailVerified = > ${event.user.isVerified}');
    emit(event.user.isNotEmpty
        ? AppState.authenticated(
            event.user,
            event.user.isVerified
                ? VerificationcStatus.verified
                : VerificationcStatus.notVerified,
          )
        : const AppState.unAuthenticated());
  }

  void _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_authRepository.logout());
  }

  Future<void> _onEmailVerifyRequested(
    AppEmailVerifyRequested event,
    Emitter<AppState> emit,
  ) async {
    await _authRepository.sendEmailVerification();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
