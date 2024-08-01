import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/signup/signup_cubit.dart';

class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  bool _isLoding = false;
  TextEditingController passwordController = TextEditingController();
  var _enteredEmail;
  var _enteredUsername;
  var _enteredPassword;
  final _formKey = GlobalKey<FormState>();
  void _submit(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoding = true;
    });
    try {
      ctx
          .read<SignupCubit>()
          .signupFormSubmitted(
              _enteredEmail, _enteredPassword, _enteredUsername)
          .then(
        (_) {
          setState(() {
            _isLoding = false;
          });
        },
      );
    } catch (_) {
      setState(() {
        _isLoding = false;
      });
    }
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHight = MediaQuery.of(context).viewInsets.bottom;
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.signupStatus == SignupStatus.error) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            state.errorMessege,
            style: TextStyle(color: Colors.red),
          )));
        } else if (state.signupStatus == SignupStatus.success) {
          Navigator.pop(context);
        }
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(10),
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
                ? 400
                : MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width > 500
                ? 300
                : MediaQuery.of(context).size.width * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _enteredEmail = newValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 4) {
                                  // ignore: lines_longer_than_80_chars
                                  return 'Please enter Username at least 4 characters';
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  _enteredUsername = newValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  } else if (!validatePassword(value)) {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text(
                                            // ignore: lines_longer_than_80_chars
                                            'Your Password must contain at least 6 characters, one number, one letter and one symbol.')));
                                    return 'Enter valid password';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  _enteredPassword = newValue,
                            ),
                          ),
                          _isLoding
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            ThemeData().primaryColor),
                                  ),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _submit(context);
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: keyboardHight > 0 ? 50 : 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
