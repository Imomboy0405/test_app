import 'package:flutter/material.dart';
import 'package:test_app/Application/Menus/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_jsons.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ProfileDetailPage extends StatelessWidget {
  static const id = '/profile_detail_page';

  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = locator<ProfileBloc>();
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: MyAppBar(titleText: profileBloc.fullName),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Container(
              color: AppColors.purpleAccent,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                isScrollable: true,
                dividerColor: AppColors.transparent,
                indicatorColor: AppColors.whiteConst,
                labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                tabs: [
                  Tab(child: myTab(title: 'medical_history'.tr(), index: 0)),
                  Tab(child: myTab(title: 'medications_taken'.tr(), index: 1)),
                  Tab(child: myTab(title: 'surgical_interventions'.tr(), index: 2)),
                  Tab(child: myTab(title: 'hereditary_factors'.tr(), index: 3)),
                  Tab(child: myTab(title: 'anthropometry'.tr(), index: 4)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProfileDetailScreen(jsonData: medicalHistory),
                  ProfileDetailScreen(jsonData: medicationsToken),
                  ProfileDetailScreen(jsonData: surgicalInterventions),
                  ProfileDetailScreen(jsonData: hereditaryFactors),
                  ProfileDetailScreen(jsonData: medicalHistory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Builder myTab({required title, required index}) {
    return Builder(builder: (context) {
      return Text(
        title,
        style: DefaultTabController.of(context).index == index ? AppTextStyles.style19(context) : AppTextStyles.style23_0(context),
      );
    });
  }
}

class ProfileDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> jsonData;

  const ProfileDetailScreen({super.key, required this.jsonData});

  @override
  createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  int index = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: SingleChildScrollView(
        child: (widget.jsonData[0]['type'] == 'group')
            ? ExpansionPanelList(
                materialGapSize: 10,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (this.index == index) {
                      this.index = -1;
                    } else {
                      this.index = index;
                    }
                  });
                },
                animationDuration: const Duration(milliseconds: 700),
                children: widget.jsonData.map<ExpansionPanel>((item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(item['title'].toString().tr(), style: AppTextStyles.style19(context)),
                      );
                    },
                    isExpanded: index == item['index'],
                    canTapOnHeader: true,
                    backgroundColor: AppColors.purpleAccent,
                    body: Column(
                      children: item['entries'].map<Widget>((entry) => myProfileCheckBox(entry, context)).toList(),
                    ),
                  );
                }).toList(),
              )
            : Column(
                children: widget.jsonData.map<Widget>((item) => myProfileCheckBox(item, context)).toList(),
              ),
      ),
    );
  }

  Container myProfileCheckBox(entry, BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.purpleAccent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.whiteConst, width: .7)),
      child: Theme(
        data: ThemeData(
          checkboxTheme: const CheckboxThemeData(side: BorderSide(color: AppColors.whiteConst, width: 2)),
        ),
        child: CheckboxListTile(
          title: Text(entry['title'].toString().tr(), style: AppTextStyles.style19(context)),
          value: entry['value'] ?? false,
          activeColor: AppColors.whiteConst,
          contentPadding: EdgeInsets.zero,
          checkColor: AppColors.purple,
          onChanged: (value) {
            setState(() {
              entry['value'] = value;
            });
          },
        ),
      ),
    );
  }
}
