import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Edit/Bloc/profile_edit_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ProfileEditPage extends StatelessWidget {
  static const id = '/profile_edit_page';

  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = locator<ProfileBloc>();
    return BlocProvider(
      create: (context) => ProfileEditBloc()..add(InitialEvent(phone: profileBloc.phoneNumber)),
      child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
        builder: (context, state) {
          final ProfileEditBloc bloc = BlocProvider.of<ProfileEditBloc>(context);
          return PopScope(
            canPop: state is! ProfileEditLoading,
            child: Stack(
              children: [

                // #initial_screen
                Scaffold(
                  backgroundColor: AppColors.pink,
                  appBar: MyAppBar(titleText: 'edit_profile'.tr(), ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // #full_name
                        const SizedBox(height: 5),
                        Text(
                          'full_name'.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.style4(context),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          disabled: true,
                          context1: context,
                          controller: TextEditingController(text: profileBloc.fullName),
                          keyboard: TextInputType.number,
                          focus: FocusNode(),
                          errorTxt: 'errorTxt',
                          errorState: false,
                          suffixIc: true,
                          icon: Icons.abc,
                          labelTxt: '',
                          hintTxt: 'email'.tr(),
                          snackBarTxt: 'snackBarTxt',
                          onChanged: () => (),
                          onTap: () => (),
                          onSubmitted: () => (),
                        ),
                        const SizedBox(height: 20),

                        // #email
                        Text(
                          'email'.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.style4(context),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          disabled: true,
                          context1: context,
                          controller: TextEditingController(text: profileBloc.email),
                          keyboard: TextInputType.number,
                          focus: FocusNode(),
                          errorTxt: 'errorTxt',
                          errorState: false,
                          suffixIc: true,
                          icon: Icons.mail,
                          labelTxt: '',
                          hintTxt: 'email'.tr(),
                          snackBarTxt: 'snackBarTxt',
                          onChanged: () => (),
                          onTap: () => (),
                          onSubmitted: () => (),
                        ),
                        const SizedBox(height: 20),

                        // #phone
                        Text(
                          'phone'.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.style4(context),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          context1: context,
                          inputFormatters: [bloc.maskFormatter],
                          controller: bloc.phoneController,
                          keyboard: TextInputType.number,
                          focus: bloc.focusPhone,
                          errorTxt: 'errorTxt',
                          errorState: false,
                          suffixIc: bloc.suffixDone,
                          icon: Icons.phone,
                          labelTxt: '',
                          hintTxt: '+998 (00) 000-00-00',
                          snackBarTxt: 'error_phone'.tr(),
                          onChanged: () => bloc.add(ChangeEvent()),
                          onTap: () => (),
                          onSubmitted: () => bloc.focusPhone.unfocus(),
                        ),
                        const SizedBox(height: 30),
                        MyButton(
                          enable: bloc.suffixDone,
                          text: 'save'.tr(),
                          function: () => bloc.add(SaveEvent(context: context)),
                          disabledAction: DisabledAction(text: 'error_phone'.tr(), context: context),
                        ),
                      ],
                    ),
                  ),
                ),

                // #loading_screen
                if (state is ProfileEditLoading)
                  myIsLoading(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
