import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/reminder/reminder_cubit.dart';

class HomeRemindersWidget extends StatelessWidget {
  const HomeRemindersWidget({
    super.key,
    required this.topHight,
    required this.bottomHight,
    required this.toolBarHight,
  });

  final double topHight;
  final double bottomHight;
  final double toolBarHight;

  bool isTimeToCare(DateTime date) {
    return DateTime.now().isAfter(date);
  }

  Color? reminderColor(CareType careType) {
    switch (careType) {
      case CareType.watering:
        return Colors.lightBlue;
      case CareType.fertilizing:
        return Colors.brown[400];
      case CareType.rotation:
        return Colors.yellow[300];

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      shape: WidgetStateProperty.all<BeveledRectangleBorder>(
        const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      minimumSize: WidgetStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          topHight -
          bottomHight -
          toolBarHight -
          50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: BlocBuilder<ReminderCubit, ReminderState>(
        buildWhen: (previous, current) =>
            previous.reminderStatus != current.reminderStatus,
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.reminders.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: isTimeToCare(state.reminders[index].nextCaregDateTime)
                    ? reminderColor(state.reminders[index].careType)
                    : null,
                child: state.reminders[index].id == state.reminderId &&
                        state.reminderStatus == Status.looding
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        state.reminders[index].plantName,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      Text(
                                        // ignore: lines_longer_than_80_chars
                                        ' ${state.reminders[index].careType.name}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('d MMMM').format(state
                                            .reminders[index]
                                            .nextCaregDateTime),
                                      ),
                                      Text(
                                        // ignore: lines_longer_than_80_chars
                                        DateFormat('HH:mm').format(state
                                            .reminders[index]
                                            .nextCaregDateTime),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Card(
                              child: IconButton(
                            onPressed: () {
                              context.read<ReminderCubit>().deletReminder(
                                  state.reminders[index].id,
                                  state.reminders[index].notificationId);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            style: buttonStyle,
                          )),
                          isTimeToCare(state.reminders[index].nextCaregDateTime)
                              ? Card(
                                  child: IconButton(
                                    onPressed: () {
                                      context.read<ReminderCubit>().addReminder(
                                          state.reminders[index].plantName,
                                          state.reminders[index].careType,
                                          DateTime.now(),
                                          TimeOfDay.now(),
                                          state.reminders[index].days,
                                          state.reminders[index].hours,
                                          state.reminders[index].id);
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                    style: buttonStyle,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
