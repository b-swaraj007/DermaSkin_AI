package com.mycompany.dermascanai

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarker
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult

class FaceLandmarkerHelper(
    private val context: Context,
    private val onResult: (FaceLandmarkerResult, Int, Int) -> Unit,
    private val onError: (String) -> Unit
) {
    private var faceLandmarker: FaceLandmarker? = null

    fun setup() {
        try {
            val baseOptions = BaseOptions.builder()
                .setModelAssetPath("face_landmarker.task")
                .build()

            val options = FaceLandmarker.FaceLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setRunningMode(RunningMode.LIVE_STREAM)
                .setNumFaces(1)
                .setMinFaceDetectionConfidence(0.5f)
                .setMinFacePresenceConfidence(0.5f)
                .setMinTrackingConfidence(0.5f)
                .setOutputFaceBlendshapes(false)
                .setOutputFacialTransformationMatrixes(false)
                .setResultListener { result, input ->
                    onResult(result, input.width, input.height)
                }
                .setErrorListener { error ->
                    onError(error.message ?: "Unknown error")
                }
                .build()

            faceLandmarker = FaceLandmarker.createFromOptions(context, options)
        } catch (e: Exception) {
            onError("FaceLandmarker setup failed: ${e.message}")
        }
    }

    fun detectAsync(bitmap: Bitmap, frameTime: Long, isFrontCamera: Boolean) {
        val matrix = Matrix()
        if (isFrontCamera) matrix.postScale(-1f, 1f, bitmap.width / 2f, bitmap.height / 2f)
        val processedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        val mpImage = BitmapImageBuilder(processedBitmap).build()
        faceLandmarker?.detectAsync(mpImage, frameTime)
    }

    fun close() {
        faceLandmarker?.close()
        faceLandmarker = null
    }
}
