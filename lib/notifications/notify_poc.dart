import 'dart:io';
import 'package:chatbot/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

///FYI: below is sample function that does a HTTP Get request on invokation by background worker
@pragma('vm:entry-point')
void notifyPOC() async {
  Workmanager().executeTask((taskName, inputData) async {
    print("background worker invoked");

    //fyi: invokedFrequency to be useful to know how many times it got executed
    // helpful for debugging/development phase
    int? invokedFrequency;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    invokedFrequency = prefs.getInt("invoked_frequency");
    prefs.setInt("invoked_frequency",
        invokedFrequency == null ? 1 : invokedFrequency + 1);

    await http.get(Uri.parse("http://aprashantz1.pythonanywhere.com/"));
    return Future.value(true);
  });
}

void initializeWorkManager() {
  Workmanager().initialize(notifyPOC, isInDebugMode: true);
  if (Platform.isIOS) {
    Workmanager().registerOneOffTask(
        AppConstants.notifyScreenStatusFromBackground, "simpleTask",
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresCharging: false,
        ));
  } else {
    Workmanager().registerPeriodicTask(
        AppConstants.notifyScreenStatusFromBackground, "simpleTask",
        frequency: Duration(minutes: 15),
        constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false));
  }
}
