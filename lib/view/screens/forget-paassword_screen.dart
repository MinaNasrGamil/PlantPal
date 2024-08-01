// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import '../../logic/cubit/forget_password/forget_password_cubit.dart';
import '../widgets/authentcation/forget_Password_form_widget.dart';

class ForgetPaasswordScreen extends StatefulWidget {
  const ForgetPaasswordScreen({super.key});

  @override
  State<ForgetPaasswordScreen> createState() => _ForgetPaasswordScreenState();
}

class _ForgetPaasswordScreenState extends State<ForgetPaasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BlocProvider(
            create: (context) =>
                ForgetPasswordCubit(context.read<AuthRepository>()),
            child: const ForgetPasswordFormWidget(),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
