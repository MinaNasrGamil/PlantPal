import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'reminder_form.dart';

class RemindersWidget extends StatelessWidget {
  const RemindersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Set New Reminder !',
              style: TextStyle(fontSize: TextSelectionToolbar.kHandleSize),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32),
            child: ReminderForm(),
          ),
        ],
      ),
    );
  }
}
