import UIKit
import Flutter
// import workmanager
// This is required for calling FlutterLocalNotificationsPlugin.setPluginRegistrantCallback method.
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

     // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}

    GeneratedPluginRegistrant.register(with: self)
    // TODO: For debugging we are setting it 15mins, later update it as req 
    // let fetchInterval: TimeInterval = 15 * 60 // 15 minutes in seconds
    // UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(fetchInterval)) 

    // // In AppDelegate.application method
    // WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")

      if #available(iOS 10.0, *){
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
