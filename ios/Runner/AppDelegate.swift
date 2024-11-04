import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let browserChannel = FlutterMethodChannel(name: "com.example.untitled/open_browser", binaryMessenger: controller.binaryMessenger)

        browserChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "openBrowser" {
                if let args = call.arguments as? [String: Any],
                   let url = args["url"] as? String,
                   let urlObj = URL(string: url) {
                    UIApplication.shared.open(urlObj, options: [:], completionHandler: nil)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_URL", message: "URL is null or invalid", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

