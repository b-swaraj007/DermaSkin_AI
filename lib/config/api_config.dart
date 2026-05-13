class APIConfig {
  // ⚠️ Replace with your actual keys
  // from console.faceplusplus.com
  static const String facePlusPlusKey = 
      'Qw57MU0onUh_GEreMsyQU4XBSLGeGRlL';
  static const String facePlusPlusSecret = 
      'Krho02Jr9OJNQszZGUf23W-jDXfxeNl8';

  // Face++ skin analyze endpoint
  static const String skinAnalyzeUrl =
      'https://api-us.faceplusplus.com'
      '/facepp/v1/skinanalyze';

  // Request timeout
  static const Duration timeout = 
      Duration(seconds: 30);
}