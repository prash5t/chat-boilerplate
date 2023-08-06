import 'package:bloc/bloc.dart';

class DeleteConversationCubit extends Cubit<DeleteConversationState> {
  DeleteConversationCubit() : super(DeleteConversationState(false, ''));

  setConversationDeleting(
      {bool isDeleting = true, required String idOfBotToDelete}) {
    emit(DeleteConversationState(isDeleting, idOfBotToDelete));
  }
}

class DeleteConversationState {
  final bool isDeleting;
  final String idOfBotToDelete;

  DeleteConversationState(this.isDeleting, this.idOfBotToDelete);
}
