// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'forget_password_cubit.dart';

class ForgetPasswordState extends Equatable {
  final String email;
  final String errorMessege;
  final ForgetPasswordStatus forgetPasswordStatus;
  const ForgetPasswordState({
    required this.email,
    required this.errorMessege,
    required this.forgetPasswordStatus,
  });
  factory ForgetPasswordState.inital() {
    return const ForgetPasswordState(
      email: '',
      errorMessege: '',
      forgetPasswordStatus: ForgetPasswordStatus.inital,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        errorMessege,
        forgetPasswordStatus,
      ];

  ForgetPasswordState copyWith({
    String? email,
    String? errorMessege,
    ForgetPasswordStatus? forgetPasswordStatus,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,
      errorMessege: errorMessege ?? this.errorMessege,
      forgetPasswordStatus: forgetPasswordStatus ?? this.forgetPasswordStatus,
    );
  }
}
