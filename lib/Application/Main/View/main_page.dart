import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_page.dart';
import 'package:test_app/Application/Menus/Home/View/home_page.dart';
import 'package:test_app/Application/Menus/Profile/Profile/View/profile_page.dart';
import 'package:test_app/Application/Menus/Test/Test/View/test_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import '../Bloc/main_bloc.dart';

class MainPage extends StatelessWidget {
  static const id = '/main_page';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    MainBloc bloc = locator<MainBloc>();

    return BlocBuilder<MainBloc, MainState>(
      bloc: bloc,
      builder: (context, state) {
        bloc.controller.addListener(() => bloc.listen());
        bloc.keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        if ((bloc.keyboardHeight > 0 && locator<ChatBloc>().focus) ||
            (bloc.keyboardHeight == 0 && !locator<ChatBloc>().focus)) {
          locator<ChatBloc>().add(ChatKeyboardEvent());
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (v) => bloc.add(MainExitEvent()),
          child: Scaffold(
            backgroundColor: AppColors.black,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                myBackground(context),

                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      MyBottomNavigationBar(screenWidth: screenWidth, bloc: bloc),

                      PageView(
                        physics: state is MainInitialState
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        controller: bloc.controller,
                        pageSnapping: true,
                        children: const [
                          ProfilePage(),
                          HomePage(),
                          TestPage(),
                          ChatPage(),
                          ProfilePage(),
                          HomePage(),
                        ],
                      ),

                      if(state is! MainHideBottomNavigationBarState)
                        MyBottomNavigationBar(screenWidth: screenWidth, bloc: bloc),

                    ],
                  ),
                ),

                if (bloc.exitState)
                  MyProfileScreen(
                    doneButton: true,
                    textTitle: 'exit'.tr(),
                    textCancel: 'cancel'.tr(),
                    textDone: 'confirm'.tr(),
                    functionDone: () => bloc.add(MainDoneEvent()),
                    functionCancel: () => bloc.add(MainCancelEvent()),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text('confirm_exit'.tr(), style: AppTextStyles.style13(context)),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
