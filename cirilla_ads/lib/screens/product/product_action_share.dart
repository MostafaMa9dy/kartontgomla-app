import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

Future<void> productActionShare({
  Map<String, dynamic>? fields,
  required BuildContext context,
  String? name,
  required String permalink,
}) async {
  shareLink(
    permalink: permalink,
    name: name,
    context: context,
  );
}
