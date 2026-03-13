import 'package:cirilla/register_service/register_service.dart' as service;

// ignore: constant_identifier_names
enum ScanModeType { QR, BARCODE, DEFAULT }

abstract class ScannerService {
  Future<String> scan({ScanModeType? scanMode});
}

class Scanner {
  static ScannerService create() {
    return service.ScannerService();
  }
}
