import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Welcome/SignUp/Bloc/sign_up_bloc.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class SignUpPage extends StatelessWidget {
  static const id = '/sign_up_page';

  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
        SignUpBloc bloc = context.read<SignUpBloc>();
        return Stack(
          children: [
            Container(
              decoration: myGradient(),
              child: Scaffold(
                backgroundColor: AppColors.transparent,
                appBar: AppBar(
                  elevation: 0,
                  toolbarHeight: 91,
                  backgroundColor: AppColors.transparent,
                  surfaceTintColor: AppColors.purpleAccent,

                  // #flag
                  actions: [
                    MyFlagButton(
                      currentLang: bloc.selectedLang,
                      onChanged: ({required BuildContext context, required Language lang}) =>
                          bloc.add(SelectLanguageEvent(lang: lang, context: context)),
                    )
                  ],

                  // #test_app
                  title: Text('Test App', style: AppTextStyles.style0_1(context)),
                  leadingWidth: 60,
                ),
                body: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 122,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Stack(
                        children: [
                          if (state is! SignUpVerifyState)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // #sign_up_for_free
                              Text('sign_up_for_free'.tr(), textAlign: TextAlign.center, style: AppTextStyles.style11(context)),

                              // #email
                              MyTextField(
                                disabled: bloc.googleOrFacebook,
                                controller: bloc.emailController,
                                errorState: state is SignUpErrorState,
                                suffixIc: bloc.emailSuffix,
                                keyboard: TextInputType.emailAddress,
                                focus: bloc.focusEmail,
                                errorTxt: 'invalid_email'.tr(),
                                context1: context,
                                icon: Icons.mail,
                                hintTxt: 'aaabbbccc@dddd.eee',
                                labelTxt: 'email_address'.tr(),
                                snackBarTxt: 'fill_email'.tr(),
                                onChanged: () => bloc.add(SignUpChangeEvent()),
                                onTap: () => bloc.add(SignUpChangeEvent()),
                                onSubmitted: () => bloc.add(OnSubmittedEvent()),
                              ),

                              // #full_name
                              MyTextField(
                                controller: bloc.fullNameController,
                                errorState: state is SignUpErrorState,
                                suffixIc: bloc.fullNameSuffix,
                                keyboard: TextInputType.name,
                                focus: bloc.focusFullName,
                                errorTxt: 'invalid_full_name'.tr(),
                                context1: context,
                                icon: Icons.person,
                                hintTxt: 'example_full_name'.tr(),
                                labelTxt: 'full_name'.tr(),
                                snackBarTxt: 'fill_full_name'.tr(),
                                onChanged: () => bloc.add(SignUpChangeEvent()),
                                onTap: () => bloc.add(SignUpChangeEvent()),
                                onSubmitted: () => bloc.add(OnSubmittedEvent(fullName: true)),
                              ),

                              // #password
                              MyTextField(
                                controller: bloc.passwordController,
                                errorState: state is SignUpErrorState,
                                suffixIc: bloc.passwordSuffix,
                                keyboard: TextInputType.visiblePassword,
                                focus: bloc.focusPassword,
                                errorTxt: 'invalid_password'.tr(),
                                context1: context,
                                icon: Icons.lock,
                                hintTxt: '123abc',
                                labelTxt: 'password'.tr(),
                                snackBarTxt: 'fill_password'.tr(),
                                obscure: bloc.obscurePassword,
                                onChanged: () => bloc.add(SignUpChangeEvent()),
                                onTap: () => bloc.add(SignUpChangeEvent()),
                                onSubmitted: () => bloc.add(OnSubmittedEvent(password: true)),
                                onTapEye: () => bloc.add(PasswordEyeEvent()),
                              ),

                              // #repeat_password
                              MyTextField(
                                controller: bloc.rePasswordController,
                                errorState: state is SignUpErrorState,
                                suffixIc: bloc.rePasswordSuffix,
                                keyboard: TextInputType.visiblePassword,
                                focus: bloc.focusRePassword,
                                errorTxt: 'invalid_password'.tr(),
                                context1: context,
                                icon: Icons.lock,
                                hintTxt: '123abc',
                                labelTxt: 're_password'.tr(),
                                snackBarTxt: 'fill_re_password'.tr(),
                                obscure: bloc.obscureRePassword,
                                actionDone: true,
                                onChanged: () => bloc.add(SignUpChangeEvent()),
                                onTap: () => bloc.add(SignUpChangeEvent()),
                                onSubmitted: () => bloc.add(OnSubmittedEvent(rePassword: true)),
                                onTapEye: () => bloc.add(RePasswordEyeEvent()),
                              ),

                              // #sign_up
                              MyButton(
                                disabledAction: DisabledAction(context: context, text: 'fill_all_forms'.tr()),
                                text: 'sign_up'.tr(),
                                enable: (bloc.emailSuffix || bloc.googleOrFacebook) &&
                                    bloc.fullNameSuffix &&
                                    bloc.passwordSuffix &&
                                    bloc.rePasswordSuffix,
                                function: () => context.read<SignUpBloc>().add(SignUpButtonEvent(context: context)),
                              ),

                              // #or_continue_with
                              Text(
                                'or_continue_with'.tr(),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.style2(context),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // #facebook
                                  myTextButton(
                                    onPressed: () => context
                                        .read<SignUpBloc>()
                                        .add(FaceBookEvent(width: MediaQuery.of(context).size.width, context: context)),
                                    context: context,
                                    assetIc: 'facebook',
                                    txt: 'Facebook',
                                  ),

                                  // #or
                                  Text('or'.tr(), style: AppTextStyles.style2(context)),

                                  // #google
                                  myTextButton(
                                    onPressed: () => context
                                        .read<SignUpBloc>()
                                        .add(GoogleEvent(width: MediaQuery.of(context).size.width, context: context)),
                                    context: context,
                                    assetIc: 'google',
                                    txt: 'Google',
                                  ),
                                ],
                              ),

                              // #sing_in
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'already_account'.tr(),
                                      style: AppTextStyles.style2(context),
                                    ),
                                    TextSpan(
                                      text: 'log_in'.tr(),
                                      style: AppTextStyles.style9(context),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => context.read<SignUpBloc>().add(SignInEvent(context: context)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // #verify_state
                          if (state is SignUpVerifyState)
                            Container(
                              alignment: Alignment.center,
                              color: AppColors.transparent,
                              child: Column(
                                children: [
                                  const SizedBox(height: 100),
                                  // #verify_email
                                  Text('verify_email'.tr(), textAlign: TextAlign.center, style: AppTextStyles.style1(context)),
                                  const SizedBox(height: 50),

                                  // #confirm
                                  MyButton(
                                    disabledAction: DisabledAction(text: 'fill_sms'.tr(), context: context),
                                    enable: true,
                                    text: 'confirm'.tr(),
                                    function: () => context.read<SignUpBloc>().add(SignUpConfirmEvent(context: context)),
                                  ),
                                  const SizedBox(height: 20),

                                  // #cancel
                                  MyButton(
                                    enable: true,
                                    text: 'cancel'.tr(),
                                    function: () => context.read<SignUpBloc>().add(SignUpCancelEvent()),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // #is_loading
            if (state is SignUpLoadingState) myIsLoading(context),
          ],
        );
      }),
    );
  }
}
