import 'package:get_it/get_it.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/Bloc/test_detail_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<MainBloc>(MainBloc());
  locator.registerSingleton<ProfileBloc>(ProfileBloc());
  locator.registerSingleton<ChatBloc>(ChatBloc());
  locator.registerSingleton<TestDetailBloc>(TestDetailBloc());
}