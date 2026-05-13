import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/services/skin_analyzer.dart';

/// Lightweight wrapper around [SharedPreferences] for persisting skin-scan
/// history so the progress tracker can display historical data without a
/// backend.
///
/// Key layout:
///   `scan_<millis>`           → JSON-encoded results map (one per scan)
///   `latest_overall_score`    → double
///   `scan_count`              → int
///   `last_scan_date`          → int (millisecondsSinceEpoch)
class ScanStorage {
  ScanStorage._();
  static final ScanStorage instance = ScanStorage._();

  static const String _prefixScan = 'scan_';
  static const String _keyLatestScore = 'latest_overall_score';
  static const String _keyScanCount = 'scan_count';
  static const String _keyLastScanDate = 'last_scan_date';

  /// Persist a scan. Returns the storage key under which it was saved so
  /// callers can deep-link or delete later if needed.
  Future<String> saveScan({
    required Map<String, SkinParameterResult> results,
    required double overallScore,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final key = '$_prefixScan$ts';

      final encoded = jsonEncode({
        'timestamp': ts,
        'overallScore': overallScore,
        'results': {
          for (final entry in results.entries)
            entry.key: _resultToJson(entry.value),
        },
      });
      await prefs.setString(key, encoded);
      await prefs.setDouble(_keyLatestScore, overallScore);
      await prefs.setInt(_keyScanCount, (prefs.getInt(_keyScanCount) ?? 0) + 1);
      await prefs.setInt(_keyLastScanDate, ts);
      return key;
    } catch (e) {
      debugPrint('DermaScan: ScanStorage.saveScan failed — $e');
      return '';
    }
  }

  Future<double> getLatestOverallScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_keyLatestScore) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<int> getScanCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyScanCount) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<DateTime?> getLastScanDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ms = prefs.getInt(_keyLastScanDate);
      return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
    } catch (_) {
      return null;
    }
  }

  /// Return every saved scan, newest first. Each element is the decoded
  /// JSON payload (timestamp + overallScore + results).
  Future<List<Map<String, dynamic>>> getAllScans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_prefixScan));
      final scans = <Map<String, dynamic>>[];
      for (final k in keys) {
        final raw = prefs.getString(k);
        if (raw == null) continue;
        try {
          scans.add(Map<String, dynamic>.from(jsonDecode(raw) as Map));
        } catch (_) {/* skip corrupt entries */}
      }
      scans.sort((a, b) =>
          (b['timestamp'] as int? ?? 0).compareTo(a['timestamp'] as int? ?? 0));
      return scans;
    } catch (e) {
      debugPrint('DermaScan: ScanStorage.getAllScans failed — $e');
      return const [];
    }
  }

  Map<String, dynamic> _resultToJson(SkinParameterResult r) => {
        'parameter': r.parameter,
        'score': r.score,
        'severity': r.severity,
        'detail': r.detail,
      };
}
