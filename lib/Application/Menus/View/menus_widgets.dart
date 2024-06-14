import 'package:flutter/material.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Configuration/app_colors.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.screenWidth,
    required this.bloc,
  });

  final double screenWidth;
  final MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      height: 83,
      decoration: BoxDecoration(
        color: AppColors.darker,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
        itemBuilder: (context, index) => SizedBox(
          width: screenWidth * .245,
          child: MaterialButton(
            onPressed: () => bloc.add(MainMenuButtonEvent(index: index)),
            splashColor: AppColors.transparentPurple,
            highlightColor: AppColors.transparentBlack,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // #menu_icon
                Image(
                  image: index + 1 == bloc.currentScreen ? bloc.listOfMenuIcons[index + 4] : bloc.listOfMenuIcons[index],
                  height: 50,
                  width: 50,
                ),
                if (index + 1 == bloc.currentScreen && bloc.currentScreen != 1)
                  Container(
                    width: 65,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(.5),
                          spreadRadius: -8,
                          blurRadius: 12,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
