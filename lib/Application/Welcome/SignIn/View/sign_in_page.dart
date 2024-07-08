import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Welcome/SignIn/Bloc/sign_in_bloc.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class SignInPage extends StatelessWidget {
  static const id = '/sign_in_page';

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
        SignInBloc bloc = context.read<SignInBloc>();
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
                  surfaceTintColor: AppColors.purple,

                  // #flag
                  actions: [
                    MyFlagButton(
                      currentLang: bloc.selectedLang,
                      onChanged: ({required BuildContext context, required Language lang}) => bloc.add(SelectLanguageEvent(lang: lang, context: context)),
                    ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // #log_in_text
                          Text(
                            'log_to_acc'.tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.style11(context),
                          ),

                          // #email
                          MyTextField(
                            key: const Key('email'),
                            controller: bloc.emailController,
                            errorState: state is SignInErrorState,
                            suffixIc: bloc.emailSuffix,
                            keyboard: TextInputType.emailAddress,
                            focus: bloc.focusEmail,
                            errorTxt: 'invalid_email'.tr(),
                            context1: context,
                            icon: Icons.mail,
                            hintTxt: 'aaabbbccc@dddd.eee',
                            labelTxt: 'email_address'.tr(),
                            snackBarTxt: 'fill_email'.tr(),
                            onSubmitted: () => bloc.add(OnSubmittedEvent()),
                            onTap: () => bloc.add(SignInChangeEvent()),
                            onChanged: () => bloc.add(SignInChangeEvent()),
                          ),

                          // #password
                          MyTextField(
                            key: const Key('password'),
                            actionDone: true,
                            controller: bloc.passwordController,
                            errorState: state is SignInErrorState,
                            suffixIc: bloc.passwordSuffix,
                            keyboard: TextInputType.text,
                            focus: bloc.focusPassword,
                            errorTxt: 'invalid_password'.tr(),
                            context1: context,
                            icon: Icons.lock,
                            hintTxt: '123abc',
                            labelTxt: 'password'.tr(),
                            snackBarTxt: 'fill_password'.tr(),
                            obscure: bloc.obscure,
                            onChanged: () => bloc.add(SignInChangeEvent()),
                            onSubmitted: () => bloc.add(OnSubmittedEvent(password: true)),
                            onTapEye: () => bloc.add(EyeEvent()),
                            onTap: () => bloc.add(SignInChangeEvent()),
                          ),

                          // #buttons
                          Column(
                            children: [
                              // #remember_me
                              Row(
                                children: [
                                  Checkbox(
                                    onChanged: (v) => context.read<SignInBloc>().add(RememberMeEvent()),
                                    fillColor: WidgetStateProperty.all(AppColors.purple),
                                    side: const BorderSide(width: 0),
                                    value: bloc.rememberMe,
                                  ),
                                  myTextButton(
                                    context: context,
                                    assetIc: null,
                                    onPressed: () => context.read<SignInBloc>().add(RememberMeEvent()),
                                    txt: 'remember_me'.tr(),
                                  )
                                ],
                              ),

                              // #log_in
                              MyButton(
                                disabledAction: DisabledAction(context: context, text: 'fill_all_forms'.tr()),
                                function: () => context.read<SignInBloc>().add(SignInButtonEvent(context: context)),
                                enable: bloc.emailSuffix && bloc.passwordSuffix,
                                text: 'log_in'.tr(),
                              ),

                              // #forgot_the_password
                              myTextButton(
                                  context: context,
                                  txt: 'forgot'.tr(),
                                  assetIc: null,
                                  onPressed: () => context.read<SignInBloc>().add(ForgotPasswordEvent())),
                            ],
                          ),

                          // #or_continue_with
                          Text('or_continue_with'.tr(), textAlign: TextAlign.center, style: AppTextStyles.style2(context)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // #facebook
                              myTextButton(
                                  onPressed: () => context.read<SignInBloc>().add(FaceBookEvent(context: context)),
                                  context: context,
                                  assetIc: 'facebook',
                                  txt: 'Facebook'),

                              // #or
                              Text('or'.tr(), style: AppTextStyles.style2(context)),

                              // #google
                              myTextButton(
                                  onPressed: () => context
                                      .read<SignInBloc>()
                                      .add(GoogleEvent(width: MediaQuery.of(context).size.width, context: context)),
                                  context: context,
                                  assetIc: 'google',
                                  txt: 'Google'),
                            ],
                          ),

                          // #sing_up
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'dont_have_an_account'.tr(),
                                style: AppTextStyles.style2(context),
                              ),
                              TextSpan(
                                text: 'sign_up'.tr(),
                                style: AppTextStyles.style9(context),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.read<SignInBloc>().add(SignUpEvent(context: context)),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // #is_loading
            if (state is SignInLoadingState) myIsLoading(context),
          ],
        );
      }),
    );
  }
}
