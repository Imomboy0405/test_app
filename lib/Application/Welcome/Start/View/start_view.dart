import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Welcome/Start/Bloc/start_bloc.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class StartView extends StatelessWidget {
  final int img;

  const StartView({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartBloc, StartState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // #text
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                width: 200,
                margin: EdgeInsets.only(top: img == 2 ? 130 : 100, left: img == 2 ? 110 : 65),
                child: Text(
                  'welcome_$img'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style0_2(context),
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Text(
                'welcome_info'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.style2(context),
              ),
            ),
          ],
        ),
      );
    });
  }
}
