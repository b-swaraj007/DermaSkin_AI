import Flutter
import UIKit

class MediaPipePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var helper = FaceLandmarkerHelper()
    private var frameTimestamp = 0

    static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.skinapp/mediapipe",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "com.skinapp/mediapipe_events",
            binaryMessenger: registrar.messenger()
        )
        let instance = MediaPipePlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            helper.onResult = { [weak self] (landmarks, w, h) in
                DispatchQueue.main.async {
                    if landmarks.isEmpty {
                        self?.eventSink?(["detected": false])
                    } else {
                        self?.eventSink?([
                            "detected": true,
                            "landmarks": landmarks,
                            "imageWidth": w,
                            "imageHeight": h
                        ])
                    }
                }
            }
            helper.onError = { [weak self] error in
                self?.eventSink?(FlutterError(code: "MEDIAPIPE_ERROR", message: error, details: nil))
            }
            helper.setup()
            result(true)

        case "processFrame":
            guard let args = call.arguments as? [String: Any],
                  let bytes = args["bytes"] as? FlutterStandardTypedData,
                  let isFront = args["isFrontCamera"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing args", details: nil))
                return
            }
            frameTimestamp += 33
            helper.detectAsync(imageData: bytes.data, timestamp: frameTimestamp, isFrontCamera: isFront)
            result(nil)

        case "dispose":
            helper.close()
            result(true)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
