import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/register_service/scanner/scanner.dart' as scanner_service;

class IconScan extends StatefulWidget {
  final Color? color;

  const IconScan({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  State<IconScan> createState() => _IconScanState();
}

class _IconScanState extends State<IconScan> {
  late SettingStore _settingStore;
  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  void onPressedScannerIcon(BuildContext context) async {
    String option = await _getOptionScanner(context);
    if (option.isNotEmpty) {
      await scanner_service.Scanner.create()
          .scan(scanMode: (option == "qrcode") ? scanner_service.ScanModeType.QR : scanner_service.ScanModeType.BARCODE)
          .then((value) async {
        if (value.isNotEmpty && value != '-1' && context.mounted) {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return ProductScreen(
                store: _settingStore,
                args: {'barcode': value},
              );
            },
          ));
        }
      });
    }
  }

  Future<String> _getOptionScanner(BuildContext context) async {
    if (FocusScope.of(context).hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    String option = "";
    final action = CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            option = "barcode";
            Navigator.pop(context);
          },
          child: const Text("Barcode"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            option = "qrcode";
            Navigator.pop(context);
          },
          child: const Text("QR Code"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    await showCupertinoModalPopup(context: context, builder: (context) => action);
    return option;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isWeb ? () => onPressedScannerIcon(context) : null,
      child: Icon(
        Icons.qr_code_scanner_outlined,
        size: 25,
        color: widget.color,
      ),
    );
  }
}
