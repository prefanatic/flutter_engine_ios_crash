import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let _ = CrashPlugin(registrar: registrar(forPlugin: "com.example.iosenginecrash"))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class CrashPlugin {
    private let engine: FlutterEngine
    
    init(registrar: FlutterPluginRegistrar) {
        
        self.engine = FlutterEngine(name: "CrashingEngine", project: nil, allowHeadlessExecution: true)
        
        let channel = FlutterMethodChannel(name: "com.example.iosenginecrash/crash", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { (call, result) in
            let array = call.arguments as! Array<Any>
            let handle = array[0] as! Int
            let callbackInformation = FlutterCallbackCache.lookupCallbackInformation(Int64(handle))
            
            // This is where the crash happens.
            self.engine.run(withEntrypoint: callbackInformation?.callbackName, libraryURI: callbackInformation?.callbackLibraryPath)
        }
    }
    
}
