import 'package:cirilla/register_service/scanner/scanner.dart' as scanner;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart' as service;

/// The service used to scan QR code or barcode
/// and depends on the flutter_barcode_scanner package. You need to uncomment the flutter_barcode_scanner dependency to pubspec.yaml
///
class ScannerService implements scanner.ScannerService {
  scanner.ScanModeType scanMode = scanner.ScanModeType.DEFAULT;

  @override
  Future<String> scan({scanner.ScanModeType? scanMode}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes =
          await service.FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, getScanMode(scanMode));
    } catch (_) {
      barcodeScanRes = '';
    }
    return barcodeScanRes;
  }

  service.ScanMode getScanMode(scanner.ScanModeType? scanMode) {
    switch (scanMode) {
      case scanner.ScanModeType.QR:
        return service.ScanMode.QR;
      case scanner.ScanModeType.BARCODE:
        return service.ScanMode.BARCODE;
      default:
        return service.ScanMode.DEFAULT;
    }
  }
}
