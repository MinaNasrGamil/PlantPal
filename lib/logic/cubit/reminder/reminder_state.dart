// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reminder_cubit.dart';

class ReminderState extends Equatable {
  final List<Reminder> reminders;
  final Status reminderStatus;
  final String reminderId;

  const ReminderState({
    required this.reminders,
    required this.reminderStatus,
    required this.reminderId,
  });

  factory ReminderState.inital() {
    return const ReminderState(
      reminders: [],
      reminderStatus: Status.inital,
      reminderId: '',
    );
  }

  @override
  List<Object?> get props => [
        reminders,
        reminderStatus,
        reminderId,
      ];

  ReminderState copyWith({
    List<Reminder>? reminders,
    Status? reminderStatus,
    String? reminderId,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      reminderStatus: reminderStatus ?? this.reminderStatus,
      reminderId: reminderId ?? this.reminderId,
    );
  }
}
