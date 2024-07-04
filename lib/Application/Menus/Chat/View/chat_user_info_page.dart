import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/logic_service.dart';

class ChatUserInfoPage extends StatelessWidget {
  static const id = '/chat_user_info_page';

  const ChatUserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBloc bloc = locator<ChatBloc>();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: MyAppBar(
        titleText: bloc.user!.fullName!,
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
                    tag: bloc.user!.uId!,
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        color: AppColors.transparentPurple.withOpacity(.2),
                        borderRadius: BorderRadius.circular(33),
                      ),
                      child: Icon(
                        CupertinoIcons.profile_circled,
                        color: AppColors.purple,
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
                    userInfoChild(context: context, bloc: bloc, title: 'full_name'.tr(), child: bloc.user!.fullName!),
                    Divider(color: AppColors.black),
                    // #id
                    userInfoChild(context: context, bloc: bloc, title: 'id'.tr(), child: bloc.user!.uId!),
                    Divider(color: AppColors.black),
                    // #email
                    userInfoChild(context: context, bloc: bloc, title: 'email'.tr(), child: bloc.user!.email!),
                    Divider(color: AppColors.black),
                    // #created_date
                    userInfoChild(context: context, bloc: bloc, title: 'date_sign'.tr(), child: bloc.user!.createdTime!),
                  ],
                ),
              ),

              // #medical_info
              const SizedBox(height: 10),
              Center(
                child: Text(
                  bloc.user!.userDetailList.isEmpty ? 'medical_info_not_found'.tr() : 'medical_info'.tr(),
                  style: AppTextStyles.style0_1(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              if (bloc.user!.userDetailList.isNotEmpty)
                ListView.builder(
                  itemCount: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int tabIndex) {
                    final List list = bloc.user!.userDetailList[tabIndex];

                    // #check_not_selected_entries
                    if (list[0] is Entries && !LogicService.selectModelsFound(list)) return const SizedBox.shrink();
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
                                Text(
                                  tabTitles[tabIndex].tr(),
                                  style: AppTextStyles.style18_0(context),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(width: 5),
                                bloc.icons[tabIndex]
                              ],
                            ),
                          ),
                          if (list[0] is Entries) const SizedBox(height: 5),

                          ListView.builder(
                              itemCount: list.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                int j = 0;
                                var model = list[index];

                                // #entry_number_update
                                if (model is Entries && model.value is bool && model.value) i++;
                                return model is UserDetailModel
                                    // $check_not_selected_models_or_other_model
                                    ? LogicService.selectModelsFoundOrOtherModel(model)
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (index != 0 && tabIndex != 3) Divider(color: AppColors.black),
                                              if (tabIndex == 3 && index == 0) const SizedBox(height: 5),

                                              // #check_select_model_found_and_model_value_is_yes
                                              if ((model.title != null && tabIndex != 3) ||
                                                  (tabIndex == 3 && LogicService.selectModelFound(model)))
                                                Container(
                                                  padding: index != 0 && tabIndex != 3 ? const EdgeInsets.all(5) : null,
                                                  alignment: tabIndex != 3 ? Alignment.center : null,
                                                  child: Text(
                                                    // #hereditary_factors_or_other_title
                                                    '${model.title?.tr()}: ${tabIndex == 3 ? LogicService.selectedEntryTitles(model) : ''}',
                                                    style:
                                                        tabIndex == 3 ? AppTextStyles.style20_1(context) : AppTextStyles.style18(context),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: tabIndex != 3 ? TextAlign.center : TextAlign.left,
                                                  ),
                                                ),
                                              if (tabIndex != 3)
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: model.entries.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    Entries entry = model.entries[index];
                                                    if (entry.value is bool && entry.value) j++;
                                                    return entry.value is bool
                                                        ? entry.value
                                                            // #medical_history
                                                            ? Text(
                                                                '$j. ${entry.title.toString().tr()};',
                                                                style: AppTextStyles.style20_1(context),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              )
                                                            : const SizedBox.shrink()
                                                        // #anthropometry
                                                        : Text(
                                                            '${entry.title.tr()}: ${entry.value};',
                                                            style: AppTextStyles.style20_1(context),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          );
                                                  },
                                                ),
                                            ],
                                          )
                                        : const SizedBox.shrink()
                                    // #medications_token_and_surgical_interventions
                                    : model.value is bool && model.value
                                        ? Text(
                                            '$i. ${model.title.toString().tr()};',
                                            style: AppTextStyles.style20_1(context),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                        : const SizedBox.shrink();
                              }),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
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
        Text(
          child,
          style: AppTextStyles.style20_1(context),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
