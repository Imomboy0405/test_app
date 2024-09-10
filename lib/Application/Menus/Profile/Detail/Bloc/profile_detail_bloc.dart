import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/firestore_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';

part 'profile_detail_event.dart';
part 'profile_detail_state.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  List<int> currentIndexes = List.filled(5, 0);
  List<Map<String, dynamic>> values = List.filled(5, {});
  final ProfileBloc profileBloc;
  bool initial = true;

  ScrollController controller = ScrollController();
  final keyCheckBox = GlobalKey(debugLabel: 'showCheckBox');
  bool showCheckBox = false;
  bool firstCheckBox = false;
  final keyNextButton = GlobalKey(debugLabel: 'showNextButton');
  bool firstNextButton = false;
  bool showBMI = false;
  final keyBMI = GlobalKey(debugLabel: 'showBMi');
  bool showSaveButton = false;
  final keySaveButton = GlobalKey(debugLabel: 'showSave');

  final player = AudioPlayer();

  ProfileDetailBloc({required this.profileBloc}) : super(ProfileDetailLoadingState()) {
    on<UpdateDetailPageEvent>(updateDetail);
    on<UpdateDetailExpansionPanelEvent>(updateExpansionPanel);
    on<DetailLoadingEvent>(loadingPage);
    on<DetailPopEvent>(popInvoiced);
    on<ShowCaseEvent>(showCase);
    on<InitialDataEvent>(initialData);
  }

  Future<void> initialData(InitialDataEvent event, Emitter<ProfileDetailState> emit) async {
    emit(ProfileDetailLoadingState());
    if (initial) {
      if (!profileBloc.mainBloc.showCaseModel.profileDetail) {
        showCheckBox = true;
        firstCheckBox = true;
      }
    }
    values = await FirestoreService.loadSeed(profileBloc.mainBloc.userModel!.uid!);

    if (profileBloc.userDetailList.isEmpty) {
      final list = await RTDBService.loadSeed();
      profileBloc.userDetailList = list.map((map) => UserDetailModel.fromJson(map)).toList();
    } else {
      // profileBloc.userDetailList = profileBloc.userDetailList.map((map) => map.copyWith()).toList();
    }
    emitDetail(emit);
  }

  Future<void> showCase(ShowCaseEvent event, Emitter<ProfileDetailState> emit) async {
    if (showCheckBox) {
      showCheckBox = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keyCheckBox]));
    } else if (event.tapCheckBox) {
      firstNextButton = true;
      currentIndexes = List.from(currentIndexes);
      currentIndexes[0] = -1;
      emitDetail(emit);
    } else if (firstNextButton) {
      firstNextButton = false;
      await Future.delayed(const Duration(milliseconds: 600));
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keyNextButton]));
      emitDetail(emit);
    } else if (event.tapNextButton) {
      profileBloc.add(NextEvent(index: 4, context: event.context));
      showBMI = true;
    } else if (showBMI) {
      showBMI = false;
      await Future.delayed(const Duration(milliseconds: 300));
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keyBMI]));
      emitDetail(emit);
    } else if (event.tapBMI) {
      showSaveButton = true;
      emitDetail(emit);
    } else if (showSaveButton) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keySaveButton]));
      showSaveButton = false;
    } else if (event.tapSave) {
      profileBloc.add(NextEvent(index: 0, context: event.context));
      currentIndexes[0] = 0;
      profileBloc.mainBloc.showCaseModel.profileDetail = true;
      await DBService.saveShowCase(profileBloc.mainBloc.showCaseModel);
    }
  }

  void emitDetail(Emitter<ProfileDetailState> emit) => emit(ProfileDetailInitialState(currentIndexes: currentIndexes, values: values));

  void loadingPage(DetailLoadingEvent event, Emitter<ProfileDetailState> emit) => emit(ProfileDetailLoadingState());

  void popInvoiced(DetailPopEvent event, Emitter<ProfileDetailState> emit) => profileBloc.currentTab = 0;

  void updateExpansionPanel(UpdateDetailExpansionPanelEvent event, Emitter<ProfileDetailState> emit) {
    currentIndexes = List.from(currentIndexes);
    currentIndexes[event.tabIndex] = event.pressSaveButton
        ? currentIndexes[event.tabIndex] = event.value
        : currentIndexes[event.tabIndex] == event.value
            ? -1
            : event.value;
    emitDetail(emit);
  }

  void updateDetail(UpdateDetailPageEvent event, Emitter<ProfileDetailState> emit) {
    if (profileBloc.mainBloc.sound) player.play(AssetSource('sounds/sound_button.wav'));
    values = List.from(values);
    values[profileBloc.currentTab] = {...values[profileBloc.currentTab], event.id: event.value};
    emitDetail(emit);
  }
}
