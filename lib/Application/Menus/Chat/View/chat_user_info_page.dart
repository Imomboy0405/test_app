import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/logic_service.dart';

class ChatUserInfoPage extends StatelessWidget {
  static const id = '/chat_user_info_page';

  const ChatUserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBloc bloc = locator<ChatBloc>();

    return BlocBuilder<ChatBloc, ChatState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is! ChatLoadingState) {
          return Scaffold(
            backgroundColor: AppColors.black,
            appBar: MyAppBar(
              titleText: bloc.user!.displayName!,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: bloc.user!.uid!,
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              color: AppColors.purpleAccent,
                              borderRadius: BorderRadius.circular(33),
                            ),
                            child: const Icon(
                              CupertinoIcons.profile_circled,
                              color: AppColors.whiteConst,
                              size: 60,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // #user_info
                        Flexible(
                          child: Text(
                            'user_info'.tr(),
                            style: AppTextStyles.style0_1(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.purpleAccent,
                      ),
                      child: Column(
                        children: [
                          // #full_name
                          userInfoChild(context: context, bloc: bloc, title: 'full_name'.tr(), child: bloc.user!.displayName!),
                          Divider(color: AppColors.black),
                          // #id
                          userInfoChild(context: context, bloc: bloc, title: 'id'.tr(), child: bloc.user!.uid!),
                          Divider(color: AppColors.black),
                          // #email
                          userInfoChild(context: context, bloc: bloc, title: 'email'.tr(), child: bloc.user!.email!),
                          Divider(color: AppColors.black),
                          // #created_date
                          userInfoChild(
                              context: context, bloc: bloc, title: 'date_sign'.tr(), child: bloc.user!.createdAt!.toDate().toString()),
                        ],
                      ),
                    ),

                    // #medical_info
                    const SizedBox(height: 10),
                    FutureBuilder<Map<String, dynamic>>(
                      future: bloc.loadMedicalInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: Text(
                            'Tibbiy ma`lumot yuklanmoqda...',
                            style: AppTextStyles.style0_1(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Xatolik yuz berdi: ${snapshot.error}',
                            style: AppTextStyles.style0_1(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ));
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final values = snapshot.data!;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  values.isEmpty ? 'medical_info_not_found'.tr() : 'medical_info'.tr(),
                                  style: AppTextStyles.style0_1(context),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              if (values.isNotEmpty)
                              Flexible(
                                child: ListView.builder(
                                  itemCount: 5,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int tabIndex) {
                                    // #check_not_selected_entries
                                    if (!LogicService.selectModelsFound(bloc.userDetailList[tabIndex].entries, values)) {
                                      return const SizedBox.shrink();
                                    }
                                    int i = 0;
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.purpleAccent,
                                      ),
                                      child: Column(
                                        children: [
                                          // #tab_titles_text
                                          Container(
                                            width: double.infinity,
                                            color: AppColors.black,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    bloc.userDetailList[tabIndex].title?['ru'] ?? 'null',
                                                    style: AppTextStyles.style18_0(context),
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                bloc.icons[tabIndex]
                                              ],
                                            ),
                                          ),

                                          ListView.builder(
                                            itemCount: bloc.userDetailList[tabIndex].entries.length,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context, int index) {
                                              var model = bloc.userDetailList[tabIndex].entries[index];

                                              // #entry_number_update
                                              if (values[model.id] is bool && values[model.id]) i++;
                                              return values[model.id] is! bool
                                                  // $check_not_selected_models_or_other_model
                                                  ? LogicService.selectModelsFoundOrOtherModel(model, values)
                                                      ? Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            if (index != 0 && tabIndex != 3) Divider(color: AppColors.black),
                                                            if (tabIndex == 3 && index == 0) const SizedBox(height: 5),

                                                            // #check_select_model_found_and_model_value_is_yes
                                                            if ((model.title != null) ||
                                                                (LogicService.selectModelFound(model, values)))
                                                              Container(
                                                                padding: index != 0 && tabIndex != 3 ? const EdgeInsets.all(5) : null,
                                                                alignment: tabIndex != 3 ? Alignment.center : null,
                                                                child: Text(
                                                                  // #hereditary_factors_or_other_title
                                                                  '${model.title?['ru']}: ${tabIndex == 3 ? values[model.id] : ''}',
                                                                  style: tabIndex == 3
                                                                      ? AppTextStyles.style20_1(context)
                                                                      : AppTextStyles.style18(context),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                  textAlign: tabIndex != 3 ? TextAlign.center : TextAlign.left,
                                                                ),
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox.shrink()
                                                  // #medications_token_and_surgical_interventions
                                                  : values[model.id] is bool && values[model.id]
                                                      ? Text(
                                                          '$i. ${model.title?['ru']};',
                                                          style: AppTextStyles.style20_1(context),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        )
                                                      : const SizedBox.shrink();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                              child: Text(
                            'medical_info_not_found'.tr(),
                            style: AppTextStyles.style0_1(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.black,
          body: myIsLoading(context),
        );
      },
    );
  }

  Row userInfoChild({required BuildContext context, required ChatBloc bloc, required String title, required String child}) {
    return Row(
      children: [
        Text(
          '$title:  ',
          style: AppTextStyles.style20(context),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Flexible(
          child: Text(
            child,
            style: AppTextStyles.style20_1(context),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
