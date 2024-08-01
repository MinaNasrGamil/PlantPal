// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final String errorMessege;
  final LoginStatus loginStatus;

  const LoginState({
    required this.email,
    required this.password,
    required this.errorMessege,
    required this.loginStatus,
  });

  //factory constructor it will give me an existing opject not new one
  factory LoginState.inital() {
    return const LoginState(
      email: '',
      password: '',
      errorMessege: '',
      loginStatus: LoginStatus.inital,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        password,
        errorMessege,
        loginStatus,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessege,
    LoginStatus? loginStatus,
    VerificationcStatus? verificationcStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessege: errorMessege ?? this.errorMessege,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}
