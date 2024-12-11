import Flutter
import UIKit
import GoogleMaps

GMSServices.provideAPIKey("MAPS_API_KEY")

 if let apiKey = loadAPIKeyFromEnv() {
      GMSServices.provideAPIKey(apiKey)
    } else {
      // 如果没有加载到密钥，则使用备用密钥
      GMSServices.provideAPIKey("your_fallback_api_key")
    }
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
