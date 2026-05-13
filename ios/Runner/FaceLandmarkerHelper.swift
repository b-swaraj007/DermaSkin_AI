import Foundation
import MediaPipeTasksVision
import UIKit

typealias LandmarkResult = ([[String: Double]], Int, Int)

class FaceLandmarkerHelper: NSObject {
    private var faceLandmarker: FaceLandmarker?
    var onResult: ((LandmarkResult) -> Void)?
    var onError: ((String) -> Void)?

    func setup() {
        guard let modelPath = Bundle.main.path(forResource: "face_landmarker", ofType: "task") else {
            onError?("Model file not found in bundle")
            return
        }
        do {
            let options = FaceLandmarkerOptions()
            options.baseOptions.modelAssetPath = modelPath
            options.runningMode = .liveStream
            options.numFaces = 1
            options.minFaceDetectionConfidence = 0.5
            options.minFacePresenceConfidence = 0.5
            options.minTrackingConfidence = 0.5
            options.faceLandmarkerLiveStreamDelegate = self
            faceLandmarker = try FaceLandmarker(options: options)
        } catch {
            onError?("FaceLandmarker init failed: \(error.localizedDescription)")
        }
    }

    func detectAsync(imageData: Data, timestamp: Int, isFrontCamera: Bool) {
        guard let uiImage = UIImage(data: imageData),
              let cgImage = uiImage.cgImage else { return }

        var image: MPImage
        do {
            image = try MPImage(uiImage: UIImage(cgImage: cgImage))
        } catch { return }

        try? faceLandmarker?.detectAsync(image: image, timestampInMilliseconds: timestamp)
    }

    func close() {
        faceLandmarker = nil
    }
}

extension FaceLandmarkerHelper: FaceLandmarkerLiveStreamDelegate {
    func faceLandmarker(_ faceLandmarker: FaceLandmarker,
                        didFinishDetection result: FaceLandmarkerResult?,
                        timestampInMilliseconds: Int,
                        error: Error?) {
        if let error = error {
            onError?(error.localizedDescription)
            return
        }
        guard let result = result,
              let landmarks = result.faceLandmarks.first else {
            onResult?(([], 0, 0))
            return
        }
        let mapped = landmarks.map { lm in
            ["x": Double(lm.x), "y": Double(lm.y), "z": Double(lm.z)]
        }
        onResult?((mapped, 0, 0))
    }
}
