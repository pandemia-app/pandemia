import UIKit
import Flutter
import GoogleMaps
import Firebase
import background_locator
import sqflite
import geocoding
import flutter_local_notifications

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyAX8bDIMgseRdGxcv5XNGeU8n9mhwLWMVk")
    GeneratedPluginRegistrant.register(with: self)
    BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
    
    if !hasPlugin("com.tekartik.sqflite") {
        SqflitePlugin
            .register(with: registrar(forPlugin: "com.tekartik.sqflite")!)
    }
    
    if !hasPlugin("com.baseflow.geocoding") {
        GeocodingPlugin
            .register(with: registrar(forPlugin: "com.baseflow.geocoding")!)
    }
    
    if !hasPlugin("com.dexterous.flutterlocalnotifications") {
        FlutterLocalNotificationsPlugin
            .register(with: registrar(forPlugin: "com.dexterous.flutterlocalnotifications")!)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
