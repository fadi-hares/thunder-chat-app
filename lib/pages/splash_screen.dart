import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thunder_chat_app/cubits/auth/auth_cubit.dart';
import 'package:thunder_chat_app/pages/home_page.dart';
import 'package:thunder_chat_app/pages/signin_page.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unAuthenticated) {
          Navigator.pushNamed(
            context,
            SigninPage.routeName,
          );
        } else if (state.authStatus == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        }
      },
      builder: (context, state) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
