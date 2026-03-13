import 'package:cirilla/register_service/register_service.dart' as service;
import 'package:flutter/material.dart';

class Connectivity extends StatelessWidget {
  final Widget child;
  const Connectivity({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return service.Connectivity(child: child);
  }
}
