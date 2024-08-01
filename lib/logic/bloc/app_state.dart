part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  final AppStatus status;
  final VerificationcStatus verificationStatus;
  final User user;

  const AppState.first({
    required this.status,
    required this.verificationStatus,
    this.user = User.empty,
  });
  const AppState.authenticated(
    User user,
    VerificationcStatus verificationcStatus,
  ) : this.first(
          status: AppStatus.authenticated,
          verificationStatus: verificationcStatus,
          user: user,
        );

  const AppState.unAuthenticated()
      : this.first(
          status: AppStatus.unAuthenticated,
          verificationStatus: VerificationcStatus.notVerified,
        );
  @override
  List<Object?> get props => [status, user];
}
