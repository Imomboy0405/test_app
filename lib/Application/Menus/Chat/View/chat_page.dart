import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_detail_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ChatPage extends StatelessWidget {
  static const id = '/chat_page';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBloc bloc = locator<ChatBloc>()..add(ChatGetUsersEvent());
    // final double width = MediaQuery.of(context).size.width;
    bloc.mainBloc = locator<MainBloc>();
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: bloc,
      builder: (context, state) {

        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: bloc.mainBloc.userModel!.role == 'doctor' ? null : MyAppBar(titleText: 'chat'.tr()),
            body: bloc.mainBloc.userModel!.role == 'doctor'
                ? bloc.newUsers.isNotEmpty
                    ? Stack(
                      children: [
                        DefaultTabController(
                            length: 2,
                            initialIndex: 0,
                            child: Builder(builder: (context) {
                              return Column(
                                children: [
                                  Container(
                                    color: AppColors.pink,
                                    child: TabBar(
                                      controller: DefaultTabController.of(context),
                                      tabAlignment: TabAlignment.fill,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      dividerColor: AppColors.transparent,
                                      indicatorColor: AppColors.whiteConst,
                                      labelColor: AppColors.whiteConst,
                                      unselectedLabelColor: AppColors.whiteConst.withOpacity(.5),
                                      labelStyle: AppTextStyles.style3(context),
                                      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                                      tabs: [
                                        Tab(
                                          text: 'your_patients'.tr(),
                                        ),
                                        Tab(
                                          text: 'new_patients'.tr(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: DefaultTabController.of(context),
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        buildUsers(context, bloc, bloc.doctorUsers, true),
                                        buildUsers(context, bloc, bloc.newUsers, false),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        
                        if (state is ChatLoadingState)
                          myIsLoading(context)
                      ],
                    )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            buildShimmer(false, true),
                            const SizedBox(height: 10),
                            buildShimmer(false, true),
                            const SizedBox(height: 10),
                            buildShimmer(false, true),
                            const SizedBox(height: 10),
                            buildShimmer(false, true),
                          ],
                        ),
                      )
                : const ChatDetailPage(),
          ),
        );
      },
    );
  }

  Container buildUsers(BuildContext context, ChatBloc bloc, List<UserModel> list, bool chat) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height - 162,
      color: AppColors.transparent,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(width * .02, width * .005, width * .02, width * .005),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              key: key,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => bloc.add(ChatPressGroupEvent(userModel: list[index], context: context, chat: chat)),
                  child: Container(
                    height: width * .2,
                    padding: EdgeInsets.all(width * .01),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withOpacity(.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // #profile_button
                        InkWell(
                          onTap: () => bloc.add(ChatPushInfoEvent(userModel: list[index], context: context)),
                          borderRadius: BorderRadius.circular(33),
                          child: Hero(
                            tag: list[index].uid!,
                            child: Container(
                              width: width * .12,
                              height: width * .12,
                              decoration: BoxDecoration(
                                color: AppColors.transparentPurple.withOpacity(.2),
                                borderRadius: BorderRadius.circular(width * .06),
                              ),
                              child: Icon(
                                CupertinoIcons.profile_circled,
                                color: AppColors.whiteConst,
                                size: width * .1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * .02),

                        // #texts
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // #full_name
                              Flexible(
                                child: Text(
                                  list[index].displayName ?? 'null',
                                  style: AppTextStyles.style3(context).copyWith(color: AppColors.whiteConst),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),

                              // #email
                              Flexible(
                                child: Text(
                                  '${'email'.tr()}: ${list[index].email!}',
                                  style: AppTextStyles.style9(context).copyWith(color: AppColors.whiteConst),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),

                              // #recent_message
                              if (chat)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        list[index].groups.first.recentMessage?.message?.replaceAll('\n', ' ') ?? 'msg_not_found'.tr(),
                                        style: AppTextStyles.style9(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width * .02),
                                      child: Text(
                                        formatDate(list[index].groups.first.recentMessage?.sentAt?.toDate()),
                                        style: AppTextStyles.style9(context),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Flexible(
                                  child: Text(
                                    '${'id'.tr()}: ${list[index].uid!}',
                                    style: AppTextStyles.style9(context),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

String formatDate(DateTime? dateTime) {
  if (dateTime != null) {
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return dateTime.toString().substring(11, 16);
    } else {
      return dateTime.toString().substring(0, 10);
    }
  } else {
    return '';
  }
}

Builder myTab({required title, required index, required currentIndex}) {
  return Builder(builder: (context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: currentIndex == index ? AppColors.whiteConst : AppColors.purple),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(title,
          style:
              currentIndex == index ? AppTextStyles.style3(context).copyWith(color: AppColors.whiteConst) : AppTextStyles.style3(context)),
    );
  });
}
