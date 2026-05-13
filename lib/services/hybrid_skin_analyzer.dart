import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'face_plus_service.dart';
import 'skin_analyzer.dart'; // for elasticity only

class HybridSkinAnalyzer {
  static HybridSkinAnalyzer? _instance;
  static HybridSkinAnalyzer get instance {
    _instance ??= HybridSkinAnalyzer._();
    return _instance!;
  }
  HybridSkinAnalyzer._();

  final _facePlusService = FacePlusService.instance;
  final _skinAnalyzer = SkinAnalyzer.instance;

  // Best frame captured during scan
  // (front facing, best quality)
  CameraImage? _bestFrame;
  Face? _bestFace;

  void setBestFrame(CameraImage frame, Face face) {
    _bestFrame = frame;
    _bestFace = face;
  }

  void clear() {
    _bestFrame = null;
    _bestFace = null;
  }

  // ════════════════════════════════════════
  // MASTER ANALYSIS FUNCTION
  // Combines Face++ + ML Kit results
  // ════════════════════════════════════════
  Future<Map<String, SkinParameterResult>>
      analyzeAll() async {

    if (_bestFrame == null || _bestFace == null) {
      debugPrint('DermaScan: No frame available');
      return _buildErrorResults();
    }

    debugPrint(
      'DermaScan: Starting hybrid analysis...'
    );

    // Run Face++ API and ML Kit in parallel
    final results = await Future.wait([
      _facePlusService.analyzeSkin(_bestFrame!),
      _skinAnalyzer.analyzeElasticityPublic(
        _bestFace!
      ),
    ]);

    final facePlusResult =
        results[0] as FacePlusResult?;
    final elasticityResult =
        results[1] as SkinParameterResult;

    // If Face++ failed, fall back to pure math
    if (facePlusResult == null) {
      debugPrint(
        'DermaScan: Face++ failed, '
        'using fallback math analysis'
      );
      return await _skinAnalyzer.analyzeAll();
    }

    debugPrint('DermaScan: Face++ success ✅');

    // Inject ML Kit elasticity into Face++ result
    facePlusResult.elasticityScore =
        elasticityResult.score;

    // Build final results map
    return _buildResultsFromFacePlus(
      facePlusResult, elasticityResult
    );
  }

  // ════════════════════════════════════════
  // Map FacePlusResult → SkinParameterResult
  // for each of your 9 parameters
  // ════════════════════════════════════════
  Map<String, SkinParameterResult>
      _buildResultsFromFacePlus(
    FacePlusResult fp,
    SkinParameterResult elasticity,
  ) {
    return {

      // Parameter 1: Skin Type & Moisture
      'skin_type_moisture': SkinParameterResult(
        parameter: 'Skin Type & Moisture',
        score: fp.moistureScore,
        severity: _moistureSeverity(fp.moistureScore),
        detail: '${fp.skinTypeLabel} skin • '
            '${fp.moistureScore.toInt()}% hydrated',
        rawData: {
          'skin_type': fp.skinTypeLabel,
          'moisture': fp.moistureScore,
          'oily_prob': fp.skinTypeOily,
          'dry_prob': fp.skinTypeDry,
        },
      ),

      // Parameter 2: Wrinkles & Fine Lines
      'wrinkles': SkinParameterResult(
        parameter: 'Wrinkles & Fine Lines',
        score: fp.wrinkleScore,
        severity: _wrinkleSeverity(fp.wrinkleScore),
        detail: _wrinkleDetail(fp.wrinkleScore),
        rawData: {
          'wrinkle_raw': fp.wrinkle,
          'wrinkle_score': fp.wrinkleScore,
        },
      ),

      // Parameter 3: Pigmentation & Spots
      'pigmentation': SkinParameterResult(
        parameter: 'Pigmentation & Spots',
        score: fp.pigmentationScore,
        severity: _pigmentSeverity(
          fp.pigmentationScore
        ),
        detail: _pigmentDetail(fp.pigmentationScore),
        rawData: {
          'stain_raw': fp.stain,
          'dark_circle': fp.darkCircle,
          'pigmentation_score': fp.pigmentationScore,
        },
      ),

      // Parameter 4: Pore Size & Congestion
      'pores': SkinParameterResult(
        parameter: 'Pore Size & Congestion',
        score: fp.poreScore,
        severity: _poreSeverity(fp.poreScore),
        detail: _poreDetail(fp.poreScore,
            fp.poresForehead,
            fp.poresLeftCheek,
            fp.poresRightCheek),
        rawData: {
          'pores_forehead': fp.poresForehead,
          'pores_left': fp.poresLeftCheek,
          'pores_right': fp.poresRightCheek,
          'pore_score': fp.poreScore,
        },
      ),

      // Parameter 5: Redness & Sensitivity
      'redness': SkinParameterResult(
        parameter: 'Redness & Sensitivity',
        score: fp.rednessScore,
        severity: _rednessSeverity(fp.rednessScore),
        detail: _rednessDetail(fp.rednessScore),
        rawData: {
          'redness_raw': fp.redness,
          'redness_score': fp.rednessScore,
        },
      ),

      // Parameter 6: UV Damage
      'uv_damage': SkinParameterResult(
        parameter: 'UV Damage',
        score: fp.uvDamageScore,
        severity: _uvSeverity(fp.uvDamageScore),
        detail: _uvDetail(fp.uvDamageScore),
        rawData: {
          'uv_score': fp.uvDamageScore,
          'stain': fp.stain,
          'dark_circle': fp.darkCircle,
        },
      ),

      // Parameter 7: Skin Texture & Smoothness
      'texture': SkinParameterResult(
        parameter: 'Skin Texture & Smoothness',
        score: fp.textureScore,
        severity: _textureSeverity(fp.textureScore),
        detail: _textureDetail(fp.textureScore),
        rawData: {
          'texture_score': fp.textureScore,
          'acne_raw': fp.acne,
        },
      ),

      // Parameter 8: Elasticity & Firmness
      // ← This comes from ML Kit, not Face++
      'elasticity': elasticity,

      // Parameter 9: True Skin Age
      'skin_age': SkinParameterResult(
        parameter: 'True Skin Age',
        score: fp.skinAgeScore,
        severity: _ageSeverity(fp.skinAge),
        detail: 'Estimated skin age: '
            '${fp.skinAge.toInt()} years',
        rawData: {
          'estimated_age': fp.skinAge,
          'age_score': fp.skinAgeScore,
        },
      ),
    };
  }

  // Error fallback if everything fails
  Map<String, SkinParameterResult> _buildErrorResults() {
    final params = [
      'Skin Type & Moisture',
      'Wrinkles & Fine Lines',
      'Pigmentation & Spots',
      'Pore Size & Congestion',
      'Redness & Sensitivity',
      'UV Damage',
      'Skin Texture & Smoothness',
      'Elasticity & Firmness',
      'True Skin Age',
    ];
    return {
      for (final p in params)
        p.toLowerCase().replaceAll(' ', '_'):
            SkinParameterResult.error(p)
    };
  }

  // ════════════════════════════════════════
  // Severity label functions
  // ════════════════════════════════════════
  String _moistureSeverity(double s) =>
      s >= 70 ? 'Good' : s >= 50 ? 'Moderate' : 'Low';

  String _wrinkleSeverity(double s) =>
      s >= 80 ? 'None' : s >= 60 ? 'Mild' :
      s >= 40 ? 'Moderate' : 'Deep';

  String _pigmentSeverity(double s) =>
      s >= 80 ? 'Clear' : s >= 60 ? 'Mild' :
      s >= 40 ? 'Moderate' : 'High';

  String _poreSeverity(double s) =>
      s >= 75 ? 'Minimal' : s >= 55 ? 'Moderate' :
      s >= 35 ? 'Congested' : 'Severely Congested';

  String _rednessSeverity(double s) =>
      s >= 80 ? 'Healthy' : s >= 60 ? 'Mild' :
      s >= 40 ? 'Moderate' : 'High';

  String _uvSeverity(double s) =>
      s >= 80 ? 'Low' : s >= 60 ? 'Moderate' :
      s >= 40 ? 'High' : 'Severe';

  String _textureSeverity(double s) =>
      s >= 80 ? 'Smooth' : s >= 60 ? 'Good' :
      s >= 40 ? 'Uneven' : 'Rough';

  String _ageSeverity(double age) =>
      age < 25 ? 'Young' : age < 35 ? 'Healthy' :
      age < 45 ? 'Moderate' : 'Mature';

  // Detail text functions
  String _wrinkleDetail(double s) =>
      s >= 80 ? 'No visible lines detected' :
      s >= 60 ? 'Mild visible lines' :
      s >= 40 ? 'Moderate lines present' :
      'Deep lines detected';

  String _pigmentDetail(double s) =>
      s >= 80 ? 'Even skin tone detected' :
      s >= 60 ? 'Mild uneven tone' :
      s >= 40 ? 'Moderate sun spots present' :
      'Significant pigmentation detected';

  String _poreDetail(double s, double fore,
      double left, double right) {
    final worst = [fore, left, right].reduce(
      (a, b) => a > b ? a : b
    );
    if (s >= 75) return 'Minimal pore visibility';
    if (s >= 55) return 'Moderate pore congestion';
    if (worst == fore) {
      return 'Congested pores — forehead zone';
    }
    return 'Congested pores — cheek zone';
  }

  String _rednessDetail(double s) =>
      s >= 80 ? 'Low sensitivity detected' :
      s >= 60 ? 'Mild redness detected' :
      s >= 40 ? 'Moderate redness present' :
      'High redness — possible sensitivity';

  String _uvDetail(double s) =>
      s >= 80 ? 'Minimal UV exposure detected' :
      s >= 60 ? 'Moderate sun exposure markers' :
      s >= 40 ? 'Significant UV damage detected' :
      'Severe UV damage — protection critical';

  String _textureDetail(double s) =>
      s >= 80 ? 'Good surface uniformity' :
      s >= 60 ? 'Slightly uneven texture' :
      s >= 40 ? 'Rough texture detected' :
      'Very uneven skin surface';
}