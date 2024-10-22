import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/firestore_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/util_service.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  var maskFormatter =
      MaskTextInputFormatter(mask: '+998 (##) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  final TextEditingController phoneController = TextEditingController();
  final FocusNode focusPhone = FocusNode();
  bool suffixDone = false;

  ProfileEditBloc() : super(const ProfileEditInitial(suffixDone: false)) {
    on<ChangeEvent>(change);
    on<SaveEvent>(save);
    on<InitialEvent>((event, emit) {
      if (event.phone != null) {
        phoneController.text = event.phone!;
        suffixDone = true;
      }
      emit(ProfileEditInitial(suffixDone: suffixDone));
    });
  }

  void change(ChangeEvent event, Emitter<ProfileEditState> emit) {
    if (phoneController.text.length == 19) {
      suffixDone = true;
    } else {
      suffixDone = false;
    }
    emit(ProfileEditInitial(suffixDone: suffixDone));
  }

  Future<void> save(SaveEvent event, Emitter<ProfileEditState> emit) async {
    emit(const ProfileEditLoading());
    focusPhone.unfocus();
    try {
      final String phone = '+${phoneController.text.replaceAll(' ', '').replaceAll(RegExp(r'[^0-9]'), '')}';
      await FirestoreService.updateUser(locator<ProfileBloc>().mainBloc.userModel!.copyWith(phoneNumber: phone));
      locator<ProfileBloc>().phoneNumber = phone;
      locator<ProfileBloc>().mainBloc.userModel?.phoneNumber = phone;
      await DBService.saveUser(locator<ProfileBloc>().mainBloc.userModel!);
      if (event.context.mounted) {
        Navigator.pop(event.context);
        if (event.context.mounted) Utils.mySnackBar(txt: 'Yangilandi', context: event.context, bottom: false);
      }
    } catch (e) {
      if (event.context.mounted) Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
    }
  }
}
