import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../constants/enums.dart';
import '../../../data/models/reminder_model.dart';
import '../../../data/repositories/plant_repository.dart';

part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final PlantRepository plantRepository;
  ReminderCubit(this.plantRepository) : super(ReminderState.inital()) {
    fechReminderData();
  }

  Future<void> fechReminderData() async {
    emit(state.copyWith(reminderStatus: Status.looding));
    try {
      List<Reminder> reminders = await plantRepository.fetchRemindersData();
      emit(state.copyWith(
        reminderStatus: Status.success,
        reminders: reminders,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(reminderStatus: Status.error));
    }
  }

  Future<void> addReminder(
    String plantName,
    CareType careType,
    DateTime lastCaregDate,
    TimeOfDay lastCareingTime,
    int days,
    int hours,
    String? reminderId,
  ) async {
    emit(
        state.copyWith(reminderStatus: Status.looding, reminderId: reminderId));
    try {
      await plantRepository
          .addReminder(
        plantName,
        careType,
        lastCaregDate,
        lastCareingTime,
        days,
        hours,
        reminderId,
      )
          .then(
        (_) async {
          fechReminderData().then(
            (_) {
              emit(state.copyWith(
                  reminderStatus: Status.success, reminderId: ''));
            },
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(reminderStatus: Status.error, reminderId: ''));
      print(e);
    }
  }

  Future<void> deletReminder(
    String reminderId,
    int notifactionId,
  ) async {
    emit(
        state.copyWith(reminderStatus: Status.looding, reminderId: reminderId));
    try {
      await plantRepository.deletReminder(reminderId, notifactionId).then(
        (_) async {
          fechReminderData().then(
            (_) {
              emit(state.copyWith(
                  reminderStatus: Status.success, reminderId: ''));
            },
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(reminderStatus: Status.error, reminderId: ''));
      print(e);
    }
  }
}
