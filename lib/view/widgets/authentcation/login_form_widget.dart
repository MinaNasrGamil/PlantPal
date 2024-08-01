import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/login/login_cubit.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _isLoding = false;
  // Define the text editing controllers
  String _enteredEmail = '';

  String _enteredPassword = '';

  final _formkey = GlobalKey<FormState>();

  void _submit(BuildContext ctx) async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoding = true;
    });
    _formkey.currentState!.save();
    try {
      await ctx
          .read<LoginCubit>()
          .loginWithCredentials(_enteredEmail, _enteredPassword)
          .then(
        (_) {
          print('hoioiiiiii');
          setState(() {
            _isLoding = false;
          });
        },
      );
    } on FirebaseAuthException catch (_) {
      print('erroooooooor from logWidget');
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
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.error) {
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
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
                            _enteredEmail = value!;
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          enabled: _isLoding ? false : true,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                      ),
                      _isLoding
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    ThemeData().primaryColor),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _submit(context);
                              },
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            child: Text(
                              'Sign Up?',
                              style: TextStyle(color: ThemeData().primaryColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                          ),
                          const Text('OR'),
                          TextButton(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: ThemeData().primaryColor),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/forgetpassword');
                            },
                          ),
                        ],
                      ),
                    ],
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
