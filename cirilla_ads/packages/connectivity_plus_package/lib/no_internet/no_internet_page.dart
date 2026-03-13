import 'package:connectivity_plus_package/constants/constants.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  static const routeName = '/no_internet';
  final String? title;
  final String? subTitle1;
  final String? subTitle2;
  const NoInternetPage({
    super.key,
    this.suggestReopen = false,
    this.title,
    this.subTitle1,
    this.subTitle2,
  });

  final bool suggestReopen;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1), spreadRadius: 5),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/global_refresh.png',
                width: 50,
                fit: BoxFit.fitWidth,
                package: "connectivity_plus_package",
              ),
            ),
          ),
          Text(
            '$title',
            style: theme.textTheme.bodyLarge?.copyWith(color: ColorBlock.redDark, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              suggestReopen ? '$subTitle1' : '$subTitle2',
              style: theme.textTheme.bodyMedium?.copyWith(color: ColorBlock.gray10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
