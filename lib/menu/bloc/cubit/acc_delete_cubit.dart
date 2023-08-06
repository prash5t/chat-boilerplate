import 'package:bloc/bloc.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/menu/repo/menu_repo.dart';

class AccDeleteCubit extends Cubit<AccDeleteState> {
  AccDeleteCubit() : super(AccDeleteState.initial);

  MenuRepo menuRepo = locator<MenuRepo>();
  void deleteUserAccount() async {
    emit(AccDeleteState.deleting);
    final response = await menuRepo.deleteUserAccount();
    response.fold((l) {
      emit(AccDeleteState.deleted);
    }, (r) {
      emit(AccDeleteState.errorDeleting);
    });
  }
}

enum AccDeleteState { initial, deleting, deleted, errorDeleting }
