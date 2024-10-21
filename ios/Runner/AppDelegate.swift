import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // action isolate 에서 모든 통신을 사용하기 위해 필요
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      // 플러그인 등록
      // Flutter 엔진이 앱에 필요한 프러그인을 초기화하고 사용할 수 있도록 설정
      GeneratedPluginRegistrant.register(with: registry)
    }

    // 푸시 알림을 처리하기 위함
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
