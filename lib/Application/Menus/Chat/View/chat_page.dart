import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_detail_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ChatPage extends StatelessWidget {
  static const id = '/chat_page';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBloc bloc = locator<ChatBloc>();
    final double width = MediaQuery.of(context).size.width;
    bloc.mainBloc = locator<MainBloc>();
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: bloc,
      builder: (context, state) {
        if (bloc.mainBloc.userModel!.uId == 'DBXkfBuedvagFrLIY1BgrNioH3u2' && bloc.users.isEmpty) {
          bloc.add(ChatGetUsersEvent());
        }
        return Scaffold(
          backgroundColor: AppColors.transparent,
          resizeToAvoidBottomInset: true,

          appBar: MyAppBar(titleText: 'chat'.tr()),
          body: bloc.mainBloc.userModel!.uId == 'DBXkfBuedvagFrLIY1BgrNioH3u2'
              ? bloc.users.isNotEmpty ? Container(
                  height: MediaQuery.of(context).size.height - 162,
                  color: AppColors.transparent,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: bloc.users.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(width * .02, 0, width * .02, width * .01),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          key: key,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => bloc.add(ChatPushDetailEvent(userModel: bloc.users[index], context: context)),
                              child: Container(
                                height: width * .2,
                                padding: EdgeInsets.all(width * .01),
                                decoration: BoxDecoration(
                                  color: AppColors.pink.withOpacity(.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    // #profile_button
                                    InkWell(
                                      onTap: () => bloc.add(ChatPushInfoEvent(userModel: bloc.users[index], context: context)),
                                      borderRadius: BorderRadius.circular(33),
                                      child: Hero(
                                        tag: bloc.users[index].uId!,
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
                                          Text(
                                            bloc.users[index].fullName!,
                                            style: AppTextStyles.style3(context).copyWith(color: AppColors.whiteConst),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),

                                          // #email_id
                                          Text(
                                            '${'email'.tr()}: ${bloc.users[index].email!}\n${'id'.tr()}: ${bloc.users[index].uId!}',
                                            style: AppTextStyles.style9(context).copyWith(color: AppColors.whiteConst),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
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
                ) : Padding(
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
        );
      },
    );
  }
}
