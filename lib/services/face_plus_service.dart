import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import '../config/api_config.dart';

class FacePlusService {
  static FacePlusService? _instance;
  static FacePlusService get instance {
    _instance ??= FacePlusService._();
    return _instance!;
  }
  FacePlusService._();

  // ════════════════════════════════════════
  // MAIN FUNCTION
  // Send face image to Face++ and get
  // all skin parameters back
  // ════════════════════════════════════════
  Future<FacePlusResult?> analyzeSkin(
    CameraImage cameraImage,
  ) async {
    try {
      debugPrint('DermaScan: Sending to Face++ API...');

      // Step 1: Convert CameraImage to JPEG bytes
      final jpegBytes = _convertToJpeg(cameraImage);
      if (jpegBytes == null) {
        debugPrint('DermaScan: Image conversion failed');
        return null;
      }

      // Step 2: Build multipart request
      // Face++ requires multipart form data
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(APIConfig.skinAnalyzeUrl),
      );

      // Add API credentials
      request.fields['api_key'] =
          APIConfig.facePlusPlusKey;
      request.fields['api_secret'] =
          APIConfig.facePlusPlusSecret;

      // Add face image
      request.files.add(
        http.MultipartFile.fromBytes(
          'image_file',
          jpegBytes,
          filename: 'face_scan.jpg',
        ),
      );

      // Step 3: Send request with timeout
      final streamedResponse = await request.send()
          .timeout(APIConfig.timeout);
      final response = await http.Response
          .fromStream(streamedResponse);

      debugPrint(
        'DermaScan: Face++ response: '
        '${response.statusCode}'
      );

      // Step 4: Parse response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint(
          'DermaScan: Face++ raw response: '
          '${response.body}'
        );
        return FacePlusResult.fromJson(json);
      } else {
        debugPrint(
          'DermaScan: Face++ error: ${response.body}'
        );
        return null;
      }
    } catch (e) {
      debugPrint('DermaScan: Face++ exception: $e');
      return null;
    }
  }

  // ════════════════════════════════════════
  // Convert CameraImage → JPEG bytes
  // Face++ needs JPEG format
  // ════════════════════════════════════════
  Uint8List? _convertToJpeg(CameraImage cameraImage) {
    try {
      img.Image? image;

      if (cameraImage.format.group ==
          ImageFormatGroup.yuv420) {
        image = _convertYUV420(cameraImage);
      } else if (cameraImage.format.group ==
          ImageFormatGroup.bgra8888) {
        image = _convertBGRA8888(cameraImage);
      } else if (cameraImage.format.group ==
          ImageFormatGroup.nv21) {
        image = _convertNV21(cameraImage);
      }

      if (image == null) return null;

      // Rotate image correctly
      // Front camera images are usually rotated
      image = img.copyRotate(image, angle: -90);

      // Flip horizontally for front camera
      image = img.flipHorizontal(image);

      // Resize to reasonable size for API
      // Face++ works well with 800px width
      if (image.width > 800) {
        image = img.copyResize(image, width: 800);
      }

      // Encode as JPEG with good quality
      return Uint8List.fromList(
        img.encodeJpg(image, quality: 90)
      );
    } catch (e) {
      debugPrint(
        'DermaScan: JPEG conversion error: $e'
      );
      return null;
    }
  }

  img.Image _convertYUV420(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final result = img.Image(
      width: width, height: height
    );
    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride =
        image.planes[1].bytesPerPixel ?? 1;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvIndex =
            uvPixelStride * (x / 2).floor() +
            uvRowStride * (y / 2).floor();
        final yValue = yPlane[y * width + x];
        final uValue = uPlane[uvIndex];
        final vValue = vPlane[uvIndex];

        int r = (yValue + 1.370705 * (vValue - 128))
            .round().clamp(0, 255);
        int g = (yValue - 0.698001 * (vValue - 128) -
            0.337633 * (uValue - 128))
            .round().clamp(0, 255);
        int b = (yValue + 1.732446 * (uValue - 128))
            .round().clamp(0, 255);

        result.setPixelRgb(x, y, r, g, b);
      }
    }
    return result;
  }

  img.Image _convertBGRA8888(CameraImage image) {
    return img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  img.Image _convertNV21(CameraImage image) {
    // NV21 is similar to YUV420 but UV planes 
    // are swapped
    final width = image.width;
    final height = image.height;
    final result = img.Image(
      width: width, height: height
    );
    final yPlane = image.planes[0].bytes;
    final vuPlane = image.planes[1].bytes;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yValue = yPlane[y * width + x];
        final uvIndex = (y ~/ 2) *
            image.planes[1].bytesPerRow +
            (x ~/ 2) * 2;

        // NV21: V comes before U
        final vValue = vuPlane[uvIndex];
        final uValue = vuPlane[uvIndex + 1];

        int r = (yValue + 1.370705 * (vValue - 128))
            .round().clamp(0, 255);
        int g = (yValue - 0.698001 * (vValue - 128) -
            0.337633 * (uValue - 128))
            .round().clamp(0, 255);
        int b = (yValue + 1.732446 * (uValue - 128))
            .round().clamp(0, 255);

        result.setPixelRgb(x, y, r, g, b);
      }
    }
    return result;
  }
}

// ════════════════════════════════════════
// Face++ Response Model
// Maps API response to your 9 parameters
// ════════════════════════════════════════
class FacePlusResult {
  // Raw scores from Face++ (0-100)
  final double moisture;
  final double acne;
  final double darkCircle;
  final double skinAge;
  final double wrinkle;
  final double stain;         // pigmentation
  final double poresForehead;
  final double poresLeftCheek;
  final double poresRightCheek;
  final double redness;
  final double skinTypeOily;
  final double skinTypeNeutral;
  final double skinTypeDry;
  final double eyePouch;      // helps with elasticity

  FacePlusResult({
    required this.moisture,
    required this.acne,
    required this.darkCircle,
    required this.skinAge,
    required this.wrinkle,
    required this.stain,
    required this.poresForehead,
    required this.poresLeftCheek,
    required this.poresRightCheek,
    required this.redness,
    required this.skinTypeOily,
    required this.skinTypeNeutral,
    required this.skinTypeDry,
    required this.eyePouch,
  });

  factory FacePlusResult.fromJson(
    Map<String, dynamic> json
  ) {
    // Navigate to skin_status in response
    final skinStatus = json['result']
        ?['skin_status'] ?? {};
    final skinType = skinStatus['skin_type'] ?? {};

    return FacePlusResult(
      moisture: _parseDouble(
        skinStatus['moisture']
      ),
      acne: _parseDouble(
        skinStatus['acne']
      ),
      darkCircle: _parseDouble(
        skinStatus['dark_circle']
      ),
      skinAge: _parseDouble(
        skinStatus['skin_age']
      ),
      wrinkle: _parseDouble(
        skinStatus['wrinkle']
      ),
      stain: _parseDouble(
        skinStatus['stain']
      ),
      poresForehead: _parseDouble(
        skinStatus['pores_forehead']
      ),
      poresLeftCheek: _parseDouble(
        skinStatus['pores_left_cheek']
      ),
      poresRightCheek: _parseDouble(
        skinStatus['pores_right_cheek']
      ),
      redness: _parseDouble(
        skinStatus['redness']
      ),
      skinTypeOily: _parseDouble(
        skinType['oily']
      ) * 100,
      skinTypeNeutral: _parseDouble(
        skinType['neutral']
      ) * 100,
      skinTypeDry: _parseDouble(
        skinType['dry']
      ) * 100,
      eyePouch: _parseDouble(
        skinStatus['eye_pouch']
      ),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  // ════════════════════════════════════════
  // MAP Face++ data → your 9 parameters
  // ════════════════════════════════════════

  // Parameter 1: Skin Type & Moisture
  String get skinTypeLabel {
    if (skinTypeOily > skinTypeDry &&
        skinTypeOily > skinTypeNeutral) {
      return 'Oily';
    }
    if (skinTypeDry > skinTypeOily &&
        skinTypeDry > skinTypeNeutral) {
      return 'Dry';
    }
    if (skinTypeOily > 40 && skinTypeDry > 20) {
      return 'Combination';
    }
    return 'Normal';
  }

  double get moistureScore => moisture;

  // Parameter 2: Wrinkles
  // Face++ gives 0-100 where higher = more wrinkles
  // We invert so higher = better
  double get wrinkleScore => 100 - wrinkle;

  // Parameter 3: Pigmentation & Spots
  double get pigmentationScore => 100 - stain;

  // Parameter 4: Pore Size & Congestion
  double get poreScore {
    final avgPores = (poresForehead +
        poresLeftCheek + poresRightCheek) / 3;
    return 100 - avgPores;
  }

  // Parameter 5: Redness & Sensitivity
  double get rednessScore => 100 - redness;

  // Parameter 6: UV Damage
  // Face++ stain + dark_circle indicates UV damage
  double get uvDamageScore =>
      100 - ((stain * 0.6) + (darkCircle * 0.4));

  // Parameter 7: Skin Texture
  // Derived from combination of acne + stain + pores
  double get textureScore =>
      100 - ((acne * 0.4) + (stain * 0.3) +
      ((poresForehead + poresLeftCheek +
          poresRightCheek) / 3 * 0.3));

  // Parameter 8: Elasticity (NOT from Face++)
  // This comes from ML Kit geometry
  // Placeholder — will be filled by ML Kit result
  double elasticityScore = 70;

  // Parameter 9: Skin Age
  // Face++ directly gives skin age in years
  // We convert to a score (younger = higher score)
  double get skinAgeScore =>
      ((70 - skinAge) / 50 * 100).clamp(0, 100);

  // Overall skin health score
  // Weighted average of all parameters
  double get overallScore {
    return (moistureScore * 0.10) +
           (wrinkleScore * 0.15) +
           (pigmentationScore * 0.10) +
           (poreScore * 0.10) +
           (rednessScore * 0.10) +
           (uvDamageScore * 0.10) +
           (textureScore * 0.15) +
           (elasticityScore * 0.10) +
           (skinAgeScore * 0.10);
  }
}