// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signup_cubit.dart';

class SignupState extends Equatable {
  final String email;
  final String password;
  final String errorMessege;
  final SignupStatus signupStatus;

  SignupState({
    required this.email,
    required this.password,
    required this.errorMessege,
    required this.signupStatus,
  });

  //factory constructor it will give me an existing opject not new one
  factory SignupState.inital() {
    return SignupState(
      email: '',
      password: '',
      errorMessege: '',
      signupStatus: SignupStatus.inital,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, errorMessege, signupStatus];

  SignupState copyWith({
    String? email,
    String? password,
    String? errorMessege,
    SignupStatus? signupStatus,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessege: errorMessege ?? this.errorMessege,
      signupStatus: signupStatus ?? this.signupStatus,
    );
  }
}
