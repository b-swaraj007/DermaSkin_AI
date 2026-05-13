package com.mycompany.dermascanai

import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Rect
import android.graphics.YuvImage
import android.os.Handler
import android.os.Looper
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MediaPipePlugin(private val context: Context) :
    MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var faceLandmarkerHelper: FaceLandmarkerHelper? = null
    private var eventSink: EventChannel.EventSink? = null
    private var frameTimestamp = 0L

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                setupLandmarker()
                result.success(true)
            }
            "processFrame" -> {
                val bytes = call.argument<ByteArray>("bytes") ?: return result.error("NO_DATA", "No frame bytes", null)
                val isFront = call.argument<Boolean>("isFrontCamera") ?: true
                val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                if (bitmap == null) {
                    result.error("DECODE_FAIL", "Could not decode frame bytes", null)
                    return
                }
                frameTimestamp += 33
                faceLandmarkerHelper?.detectAsync(bitmap, frameTimestamp, isFront)
                result.success(null)
            }
            "processYuvFrame" -> {
                val yuvBytes = call.argument<ByteArray>("yuvBytes") ?: return result.error("NO_DATA", "No YUV bytes", null)
                val width = call.argument<Int>("width") ?: return result.error("NO_DATA", "No width", null)
                val height = call.argument<Int>("height") ?: return result.error("NO_DATA", "No height", null)
                val isFront = call.argument<Boolean>("isFrontCamera") ?: true

                val jpegBytes = try {
                    convertYuvToJpeg(yuvBytes, width, height)
                } catch (e: Exception) {
                    result.error("YUV_CONVERT_FAIL", "YUV→JPEG conversion failed: ${e.message}", null)
                    return
                }

                if (jpegBytes == null) {
                    result.error("YUV_CONVERT_FAIL", "YUV→JPEG returned null", null)
                    return
                }

                val bitmap = BitmapFactory.decodeByteArray(jpegBytes, 0, jpegBytes.size)
                if (bitmap == null) {
                    result.error("DECODE_FAIL", "Could not decode converted JPEG", null)
                    return
                }

                frameTimestamp += 33
                faceLandmarkerHelper?.detectAsync(bitmap, frameTimestamp, isFront)
                result.success(jpegBytes)
            }
            "dispose" -> {
                faceLandmarkerHelper?.close()
                faceLandmarkerHelper = null
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun setupLandmarker() {
        faceLandmarkerHelper = FaceLandmarkerHelper(
            context = context,
            onResult = { landmarkerResult, width, height ->
                Handler(Looper.getMainLooper()).post {
                    sendLandmarksToFlutter(landmarkerResult, width, height)
                }
            },
            onError = { error ->
                Handler(Looper.getMainLooper()).post {
                    eventSink?.error("MEDIAPIPE_ERROR", error, null)
                }
            }
        )
        faceLandmarkerHelper?.setup()
    }

    /**
     * Convert NV21 / YUV420 byte array to JPEG using Android's native [YuvImage].
     */
    private fun convertYuvToJpeg(nv21Bytes: ByteArray, width: Int, height: Int): ByteArray? {
        val yuvImage = YuvImage(nv21Bytes, ImageFormat.NV21, width, height, null)
        val out = ByteArrayOutputStream()
        yuvImage.compressToJpeg(Rect(0, 0, width, height), 85, out)
        return out.toByteArray()
    }

    private fun sendLandmarksToFlutter(result: FaceLandmarkerResult, width: Int, height: Int) {
        if (result.faceLandmarks().isEmpty()) {
            eventSink?.success(mapOf("detected" to false))
            return
        }

        val landmarks = result.faceLandmarks()[0].map { lm ->
            mapOf("x" to lm.x().toDouble(), "y" to lm.y().toDouble(), "z" to lm.z().toDouble())
        }

        eventSink?.success(
            mapOf(
                "detected" to true,
                "landmarks" to landmarks,
                "imageWidth" to width,
                "imageHeight" to height
            )
        )
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
