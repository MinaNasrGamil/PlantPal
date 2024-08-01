import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/app_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
      bottomSheet: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () {
            context.read<AppBloc>().add(AppLogoutRequested());
            Navigator.pop(context);
          },
          child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Center(child: Text('LogOut')))),
    );
  }
}
