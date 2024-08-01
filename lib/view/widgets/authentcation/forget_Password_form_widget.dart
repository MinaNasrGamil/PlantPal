// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/forget_password/forget_password_cubit.dart';

class ForgetPasswordFormWidget extends StatefulWidget {
  const ForgetPasswordFormWidget({super.key});

  @override
  State<ForgetPasswordFormWidget> createState() =>
      _ForgetPasswordFormWidgetState();
}

class _ForgetPasswordFormWidgetState extends State<ForgetPasswordFormWidget> {
  bool _isLoding = false;
  // Define the text editing controllers
  String _enteredEnail = '';

  final _formkey = GlobalKey<FormState>();

  void _submit(BuildContext ctx) async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoding = true;
    });
    try {
      await ctx
          .read<ForgetPasswordCubit>()
          .sendPasswordResetEmail(_enteredEnail);
      setState(() {
        _isLoding = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.forgetPasswordStatus == ForgetPasswordStatus.error) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            state.errorMessege,
            style: const TextStyle(color: Colors.red),
          )));
        }
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height > 500
                ? 300
                : MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width > 500
                ? 300
                : MediaQuery.of(context).size.width * .9,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: TextFormField(
                            enabled: _isLoding ? false : true,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEnail = value!;
                            },
                          ),
                        ),
                        _isLoding
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          ThemeData().primaryColor),
                                ),
                                child: const Text(
                                  'Send a password reset email ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _submit(context);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
