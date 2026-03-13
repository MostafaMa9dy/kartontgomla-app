import 'package:cirilla/register_service/scanner/scanner.dart' as scanner;

class ScannerService implements scanner.ScannerService {
  scanner.ScanModeType scanMode = scanner.ScanModeType.DEFAULT;

  @override
  Future<String> scan({scanner.ScanModeType? scanMode}) async {
    return 'acb123456';
  }
}
