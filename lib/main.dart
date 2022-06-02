import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thunder_chat_app/cubits/auth/auth_cubit.dart';
import 'package:thunder_chat_app/cubits/delete_chat/delete_chat_cubit.dart';
import 'package:thunder_chat_app/cubits/fetch_chat/fetch_chat_cubit.dart';
import 'package:thunder_chat_app/cubits/get_user_chats/get_user_chats_cubit.dart';
import 'package:thunder_chat_app/cubits/image_picker/image_picker_cubit.dart';
import 'package:thunder_chat_app/cubits/signin/signin_cubit.dart';
import 'package:thunder_chat_app/cubits/users/users_cubit.dart';
import 'package:thunder_chat_app/pages/home_page.dart';
import 'package:thunder_chat_app/pages/signin_page.dart';
import 'package:thunder_chat_app/pages/signup_page.dart';
import 'package:thunder_chat_app/pages/splash_screen.dart';
import 'package:thunder_chat_app/repo/auth_repo.dart';
import 'package:thunder_chat_app/repo/chats_repo.dart';
import 'package:thunder_chat_app/repo/users_repo.dart';

import 'cubits/chat/send_message_cubit.dart';
import 'cubits/fetch_messages/fetch_messages_cubit.dart';
import 'cubits/signup/signup_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(
          create: (context) => AuthRepo(
            imagePicker: ImagePicker(),
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        RepositoryProvider<UsersRepo>(
          create: (context) => UsersRepo(),
        ),
        RepositoryProvider<ChatRepo>(
          create: (context) => ChatRepo(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
          BlocProvider<SigninCubit>(
            create: (context) => SigninCubit(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
          BlocProvider<ImagePickerCubit>(
            create: (context) => ImagePickerCubit(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
          BlocProvider<UsersCubit>(
            create: (context) => UsersCubit(
              usersRepo: context.read<UsersRepo>(),
            ),
          ),
          BlocProvider<SendMessageCubit>(
            create: (context) => SendMessageCubit(
              chatRepo: context.read<ChatRepo>(),
            ),
          ),
          BlocProvider<FetchMessagesCubit>(
            create: (context) => FetchMessagesCubit(
              chatRepo: context.read<ChatRepo>(),
            ),
          ),
          BlocProvider<FetchChatCubit>(
            create: (context) => FetchChatCubit(
              chatRepo: context.read<ChatRepo>(),
            ),
          ),
          BlocProvider<GetUserChatsCubit>(
            create: (context) => GetUserChatsCubit(
              chatRepo: context.read<ChatRepo>(),
              fetchChatCubit: context.read<FetchChatCubit>(),
            ),
          ),
          BlocProvider<DeleteChatCubit>(
            create: (context) => DeleteChatCubit(
              chatRepo: context.read<ChatRepo>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thunder Chat App',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: const SplashScreen(),
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(),
            HomePage.routeName: (context) => const HomePage(),
            SignupPage.routeName: (context) => const SignupPage(),
            SigninPage.routeName: (context) => const SigninPage(),
          },
        ),
      ),
    );
  }
}
