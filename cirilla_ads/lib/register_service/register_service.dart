/// Export the scanner service used in the app
///
/// There are two scanner services:
///
/// 1. Test scanner service: Used for testing
/// 2. Flutter barcode scanner service: Used to scan QR code or barcode
///
/// For testing, export the test scanner service:
///
/// ```dart
///  export 'scanner/test_scanner_service.dart';
/// ```
///
/// or export the flutter barcode scanner service: used to scan QR code or barcode
///
///
/// ```dart
/// export 'scanner/flutter_barcode_scanner_service.dart';
/// ```
/// Note: Only export one of the services,
/// also with flutter_barcode_scanner_service you need to uncomment the flutter_barcode_scanner dependency to pubspec.yaml
export 'scanner/test_scanner_service.dart';

/// Export the connectivity service used in the app
///
/// There are two connectivity services:
///
/// 1. Placeholder connectivity service: Used for placeholder and testing
/// 2. Connectivity plus service: Used to check the internet connection
///
/// For testing, export the placeholder connectivity service:
///
/// ```dart
/// export 'connectivity/placeholder_connectivity_service.dart';
/// ```
///
/// or export the connectivity plus service: used to check the internet connection
///
/// ```dart
/// export 'connectivity/connectivity_plus_service.dart';
/// ```
///
/// Note: Only export one of the services, also with connectivity_plus_service you need to uncomment the connectivity_plus dependency to pubspec.yaml
export 'connectivity/placeholder_connectivity_service.dart';

/// Export the Appsflyer used in the app
///
/// There are two Appsflyer:
///
/// 1. Test Appsflyer: Used for testing
/// 2. Flutter Appsflyer: Used to Dynamic Link
///
/// For testing, export the test Appsflyer:
///
/// ```dart
///  export 'appsflyer/test_appsflyer.dart';
/// ```
///
/// or export the flutter Appsflyer service: Used to Dynamic Link
///
///
/// ```dart
/// export 'appsflyer/appsflyer_service.dart';
/// ```
/// Note: Only export one of the services,
/// also with appsflyer_service you need to uncomment the appsflyer_sdk dependency to pubspec.yaml
export 'appsflyer/test_appsflyer.dart';
