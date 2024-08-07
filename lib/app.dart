import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_app/Application/Main/View/main_page.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_page.dart';
import 'package:test_app/Application/Menus/Home/View/home_detail_page.dart';
import 'package:test_app/Application/Menus/Home/View/home_doctor_page.dart';
import 'package:test_app/Application/Menus/Home/View/home_page.dart';
import 'package:test_app/Application/Menus/Profile/Detail/View/profile_detail_page.dart';
import 'package:test_app/Application/Menus/Test/Quiz/View/quiz_page.dart';
import 'package:test_app/Application/Menus/Test/Test/View/test_page.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/View/test_detail_page.dart';
import 'package:test_app/Application/Welcome/SignIn/View/sign_in_page.dart';
import 'package:test_app/Application/Welcome/SignUp/View/sign_up_page.dart';
import 'package:test_app/Application/Welcome/Splash/splash_page.dart';
import 'package:test_app/Application/Welcome/Start/View/start_page.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/init_service.dart';

import 'Application/Menus/Chat/View/chat_detail_page.dart';
import 'Application/Menus/Chat/View/chat_user_info_page.dart';
import 'Application/Menus/Profile/Profile/View/profile_page.dart';

class TestApp extends StatelessWidget {
  final Future _initFuture = Init.initialize();
  TestApp({super.key});

  Widget _startPage() {
    return FutureBuilder(
      future: DBService.loadData(StorageKey.user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainPage();
        } else {
          return const StartPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Menopause',
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.purpleAccent),
        canvasColor: AppColors.transparentPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _startPage();
          } else {
            return const SplashPage();
          }
        },
      ),
      routes: {
        StartPage.id: (context) => const StartPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        SignInPage.id: (context) => const SignInPage(),
        ProfilePage.id: (context) => const ProfilePage(),
        ProfileDetailPage.id: (context) => const ProfileDetailPage(),
        MainPage.id: (context) => const MainPage(),
        HomePage.id: (context) => const HomePage(),
        ChatPage.id: (context) => const ChatPage(),
        TestPage.id: (context) => const TestPage(),
        TestDetailPage.id: (context) => const TestDetailPage(),
        QuizPage.id: (context) => const QuizPage(),
        ChatDetailPage.id: (context) => const ChatDetailPage(),
        ChatUserInfoPage.id: (context) => const ChatUserInfoPage(),
        HomeDetailPage.id: (context) => const HomeDetailPage(),
        HomeDoctorPage.id: (context) => const HomeDoctorPage(),
      },
    );
  }
}
