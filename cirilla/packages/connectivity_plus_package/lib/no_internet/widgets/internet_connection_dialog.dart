import 'package:connectivity_plus_package/constants/constants.dart';
import 'package:flutter/material.dart';


class InternetConnectionDialog extends StatelessWidget {
  const InternetConnectionDialog({
    super.key,
    this.suggestReopen = false,
    required this.onTap,
    required this.internetConnected,
    this.title,
    this.subTitle1,
    this.subTitle2,
    this.connectedTitle,
    this.letTitle,
  });
  final bool suggestReopen;
  final Function() onTap;
  final ValueNotifier<bool> internetConnected;
  final String? title;
  final String? subTitle1;
  final String? subTitle2;
  final String? connectedTitle;
  final String? letTitle;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: SizedBox(
        height: 300,
        child: ValueListenableBuilder<bool>(
          valueListenable: internetConnected,
          builder: (context, value, _) {
            if (!value) {
              return Column(
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
                  Expanded(
                    child: Text(
                      suggestReopen ? '$subTitle1' : '$subTitle2',
                      style: theme.textTheme.bodyMedium?.copyWith(color: ColorBlock.gray10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorBlock.red,
                      ),
                      child: Center(
                        child: Text(
                          "OK",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: ColorBlock.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Column(
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
                      'assets/images/internet.png',
                      width: 50,
                      fit: BoxFit.fitWidth,
                      color: ColorBlock.greenBase,
                      package: "connectivity_plus_package",
                    ),
                  ),
                ),
                Text(
                  '$connectedTitle',
                  style: theme.textTheme.bodyLarge?.copyWith(color: ColorBlock.greenBase, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '$letTitle',
                  style: theme.textTheme.bodyMedium?.copyWith(color: ColorBlock.gray10),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorBlock.greenBase,
                    ),
                    child: Center(
                      child: Text(
                        "OK",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: ColorBlock.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
