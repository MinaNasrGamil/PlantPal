import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/reminder/reminder_cubit.dart';

class ReminderForm extends StatefulWidget {
  const ReminderForm({super.key});

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  String _plantNmae = '';
  int _days = 0;
  int _hours = 0;
  bool _isLoding = false;
  String? _selectedDropdwonItem;
  final _formKey = GlobalKey<FormState>();
  DateTime lastCaregDate = DateTime.now();
  TimeOfDay lastCareingTime = const TimeOfDay(hour: 9, minute: 0);

  void _submit(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoding = true;
    });
    _formKey.currentState!.save();
    try {
      await ctx
          .read<ReminderCubit>()
          .addReminder(
              _plantNmae,
              _selectedDropdwonItem == 'Watering'
                  ? CareType.watering
                  : _selectedDropdwonItem == 'Fertilizing'
                      ? CareType.fertilizing
                      : _selectedDropdwonItem == 'Rotation'
                          ? CareType.rotation
                          : CareType.watering,
              lastCaregDate,
              lastCareingTime,
              _days,
              _hours,
              null)
          .then(
        (_) {
          setState(() {
            _isLoding = false;
          });
          _formKey.currentState!.reset();
          ScaffoldMessenger.of(ctx).clearSnackBars();
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Reminders saved successfully')),
          );
        },
      );
    } catch (e) {
      print('$e erroooooooor from reminderForm');
      setState(() {
        _isLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> showCustomDatePicker({required BuildContext context}) {
      return showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime.now(),
              onDateChanged: (DateTime date) {
                Navigator.of(context).pop(date);
              },
            ),
          );
        },
      );
    }

    return Form(
      key: _formKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Plant Selection
            TextFormField(
              enabled: _isLoding ? false : true,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              decoration: const InputDecoration(
                labelText: 'Plant Name',
              ),
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a valid Plant Name.';
                }
                return null;
              },
              onSaved: (value) {
                _plantNmae = value!;
              },
            ),
            //reminder type
            DropdownButtonFormField<String>(
              value: _selectedDropdwonItem ?? 'Watering',
              onChanged: (newValue) {
                setState(() {
                  _selectedDropdwonItem = newValue;
                });
              },
              items: const [
                DropdownMenuItem(value: 'Watering', child: Text('Watering')),
                DropdownMenuItem(
                    value: 'Fertilizing', child: Text('Fertilizing')),
                DropdownMenuItem(value: 'Rotation', child: Text('Rotation')),
              ],
            ),
            // Watering Reminder
            ListTile(
              title: Text('Last ${_selectedDropdwonItem ?? "Watering"} Date ?'),
              subtitle: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        DateTime? selectedDate =
                            await showCustomDatePicker(context: context);
                        if (selectedDate != null) {
                          setState(() {
                            lastCaregDate = selectedDate;
                          });
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<BeveledRectangleBorder>(
                          const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                                'Date: ${lastCaregDate.month}/${lastCaregDate.day}/${lastCaregDate.year}'),
                            const Spacer(),
                            const Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: lastCareingTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            lastCareingTime = pickedTime;
                          });
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<BeveledRectangleBorder>(
                          const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Time: ${lastCareingTime.format(context)}'),
                              const Spacer(),
                              const Icon(Icons.edit),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            // Next Reminder
            ListTile(
              title: Text(
                  // ignore: lines_longer_than_80_chars
                  'Please specify the days and hours you will ${_selectedDropdwonItem ?? "Watering"} the plant ?'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: TextFormField(
                          enabled: _isLoding ? false : true,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: 'Days',
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                int.parse(value) < 0) {
                              return 'Please enter a valid number of days.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _days = int.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: TextFormField(
                          enabled: _isLoding ? false : true,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: 'Hours',
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                int.parse(value) < 0) {
                              return 'Please enter a valid number of hours.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _hours = int.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _isLoding
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text('Save'),
                      ),
                ElevatedButton(
                  onPressed: () {
                    // Reset form fields
                    _formKey.currentState!.reset();
                    setState(() {
                      lastCaregDate = DateTime.now();
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
