import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thunder_chat_app/cubits/image_picker/image_picker_cubit.dart';
import 'package:thunder_chat_app/cubits/signup/signup_cubit.dart';
import 'package:thunder_chat_app/pages/signin_page.dart';
import 'package:validators/validators.dart';

import '../utils/error_dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const routeName = '/signup';
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password, _name;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final _form = _key.currentState;
    if (_form != null && _form.validate()) {
      _form.save();
      context.read<SignupCubit>().signup(
            email: _email!,
            password: _password!,
            name: _name!,
            imagePath: context.read<ImagePickerCubit>().state.imagePath,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.signupStatus == SignupStatus.error) {
              errorDialog(context, state.customError);
            }
          },
          builder: (context, state) => Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Form(
                  key: _key,
                  autovalidateMode: _autovalidateMode,
                  child: ListView(
                    shrinkWrap: true,
                    reverse: true,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await context.read<ImagePickerCubit>().pickImage();
                        },
                        child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
                          builder: (context, state) {
                            return Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CircleAvatar(
                                  radius: 70,
                                  backgroundImage: state.imagePath != null
                                      ? FileImage(File(state.imagePath!))
                                      : AssetImage('assets/images/upload.jpg')
                                          as ImageProvider,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          labelText: 'Enter your Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.trim().length < 2) {
                            return 'User name must be 2 characters long at least';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          labelText: 'Enter your Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!isEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          labelText: 'Enter your Password',
                          prefixIcon: Icon(Icons.lock,
                              color: Theme.of(context).primaryColor),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid password';
                          }
                          if (value.trim().length < 6) {
                            return 'Please enter a 6 characters password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          labelText: 'Repeat your Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _textEditingController.text) {
                            return 'Passwords dosn\'t matches';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 5,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            textStyle: const TextStyle(fontSize: 20),
                            minimumSize: const Size(10, 20),
                          ),
                          onPressed: _submit,
                          child: state.signupStatus == SignupStatus.submitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: state.signupStatus == SignupStatus.submitting
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, SigninPage.routeName);
                              },
                        child: const Text('Already a member? Sign in'),
                      ),
                    ].reversed.toList(),
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
