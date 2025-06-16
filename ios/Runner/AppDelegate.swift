import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  )  -> Bool {
    GeneratedPluginRegistrant.register(with: self)
//      FirebaseApp.configure()
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                  application.registerForRemoteNotifications()
                }
              } else {
                print("Notification permission denied.")
              }
            }
            

            // Set up Firebase Messaging delegate
            UNUserNotificationCenter.current().delegate = self
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

