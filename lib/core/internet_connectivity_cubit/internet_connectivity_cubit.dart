import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectivityCubit extends Cubit<bool> {
  final InternetConnectionChecker connectionChecker;
  late StreamSubscription<InternetConnectionStatus> _subscription;
  InternetConnectivityCubit(this.connectionChecker) : super(true) {
    // for now stream is not required, so below invokation is commented
    // _subscribeToConnectivityChanges();
  }

// for stream
  // void _subscribeToConnectivityChanges() {
  //   _subscription = connectionChecker.onStatusChange.listen((status) {
  //     if (status == InternetConnectionStatus.connected) {
  //       emit(true);
  //     } else {
  //       emit(false);
  //     }
  //   });
  // }

// method when bool value is required and not stream
  Future<bool> isInternetConnected() async {
    bool isConnected = await connectionChecker.hasConnection;
    return isConnected;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
