import 'package:bloc/bloc.dart';

class AuthButtonCubit extends Cubit<bool> {
  AuthButtonCubit() : super(false);

// use this method to trigger loading indicator or verify otp button
// in otp verification screen, this also acts as preventing mutliple clicks until response is arrived
  setAuthVerifying({bool isVerifying = true}) {
    emit(isVerifying);
  }
}
