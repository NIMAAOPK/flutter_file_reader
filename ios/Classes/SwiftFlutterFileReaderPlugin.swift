import Flutter
import UIKit

let channelName = "flutter_file_reader.io.method"

public class SwiftFlutterFileReaderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterFileReaderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(FileReaderFactory.init(messenger: registrar.messenger()), withId: "plugins.file_reader/view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
