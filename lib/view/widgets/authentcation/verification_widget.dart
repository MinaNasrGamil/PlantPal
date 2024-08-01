import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/bloc/app_bloc.dart';

class VerificattionWidget extends StatefulWidget {
  const VerificattionWidget({
    super.key,
  });

  @override
  State<VerificattionWidget> createState() => _VerificattionWidgetState();
}

class _VerificattionWidgetState extends State<VerificattionWidget> {
  bool _isclicked = false;
  int _sconds = 30;
  void waitSeconds() {
    setState(() {
      _isclicked = true;
    });

    for (int i = 1; i <= 30; i++) {
      Timer(Duration(seconds: i), () {
        setState(() {
          _sconds = 30 - i;
        });
        if (i == 30) {
          setState(() {
            _sconds = 30;
            _isclicked = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('verify your email'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: _isclicked
                      ? null
                      : () {
                          waitSeconds();
                          context
                              .read<AppBloc>()
                              .add(AppEmailVerifyRequested());
                        },
                  child: _isclicked
                      ? Text('Send again after $_sconds')
                      : const Text('Send email verification')),
              ElevatedButton(
                  onPressed: () {
                    context.read<AppBloc>().add(AppLogoutRequested());
                  },
                  child: const Text('Done')),
            ],
          ),
        )
      ],
    );
  }
}
