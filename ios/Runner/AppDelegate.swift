import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Đăng ký PlatformView
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "GlassTabBarPlugin")!
    registrar.register(
      GlassTabBarFactory(messenger: registrar.messenger()),
      withId: "glass_tab_bar"
    )

    let buttonRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "GlassButtonPlugin")!
    buttonRegistrar.register(
      GlassButtonFactory(messenger: buttonRegistrar.messenger()),
      withId: "glass_button"
    )

    let iconButtonRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "GlassIconButtonPlugin")!
    iconButtonRegistrar.register(
      GlassIconButtonFactory(messenger: iconButtonRegistrar.messenger()),
      withId: "glass_icon_button"
    )
  }
}
