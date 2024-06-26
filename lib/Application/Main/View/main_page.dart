import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_page.dart';
import 'package:test_app/Application/Menus/Home/View/home_page.dart';
import 'package:test_app/Application/Menus/Profile/View/profile_page.dart';
import 'package:test_app/Application/Menus/Test/Test/View/test_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import '../Bloc/main_bloc.dart';

class MainPage extends StatelessWidget {
  static const id = '/main_page';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => locator<MainBloc>(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          MainBloc bloc = locator<MainBloc>();
          bloc.controller.addListener(() => bloc.listen());
          return Scaffold(
            backgroundColor: AppColors.black,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                myBackground(context),

                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 200,
                          height: 83,
                          color: AppColors.dark,
                        ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
