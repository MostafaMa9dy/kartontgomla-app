import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CartButtonAdditional extends StatefulWidget {
  const CartButtonAdditional({super.key});
  @override
  State<CartButtonAdditional> createState() => CartButtonAdditionalState();
}

class CartButtonAdditionalState extends State<CartButtonAdditional> with NavigationMixin {
  late CartStore _cartStore;
  bool enableKey = false;
  late AuthStore _authStore;
  late SettingStore _settingStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<AuthStore>(context).cartStore..getCart(false);
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
  }

  void onPressed(Map<String, dynamic>? buttonAction) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    CartData? cartData = _cartStore.cartData;

    User? user = _authStore.user;
    bool isLogin = _authStore.isLogin;

    String? subTotalPrice = _cartStore.subTotalPrice;

    String cartSubTotal = '${translate('cart_sub_total')}: $subTotalPrice\n';
    String? totalPrice = _cartStore.totalPrice;

    String cartTotal = '${translate('cart_total')}: $totalPrice\n';

    String line = "=============\n";

    dynamic dataString = _cartStore.dataToString.values.join();

    String content = '$dataString$cartSubTotal$cartTotal$line';

    navigate(
      context,
      buttonAction,
      {
        "cart": Uri.encodeComponent(content),
        "name": isLogin ? "${user?.userNiceName}\n" : "",
        "phone": isLogin ? "${cartData?.billingAddress?['phone']}\n" : "",
        "email": isLogin ? "${user?.userEmail}\n" : "",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        String themeModeKey = _settingStore.themeModeKey;
        ThemeData theme = Theme.of(context);

        Data? screenCart = get(_settingStore.data?.screens, ['cart'], null);

        WidgetConfig? widgetConfig = screenCart != null ? get(screenCart.widgets, ['cartPage']) : null;

        Map<String, dynamic>? fields = widgetConfig?.fields;

        Map<String, dynamic>? buttonTitle = get(fields, ['buttonTitle'], null);

        String title = get(buttonTitle, ['text'], '');

        if (title == '') {
          return const SizedBox();
        }

        Map<String, dynamic>? buttonAction = get(fields, ['buttonAction'], null);

        Map<String, dynamic>? buttonBackground = get(fields, ['buttonBackground'], null);

        Color background = ConvertData.fromRGBA(get(buttonBackground, [themeModeKey], null), Colors.transparent);

        TextStyle styleTitle = ConvertData.toTextStyle(buttonTitle, themeModeKey);

        TextStyle? styleTextButton = theme.textTheme.bodyLarge?.merge(styleTitle);

        String textTitle = ConvertData.textFromConfigs(title, _settingStore.languageKey);

        bool buttonEnableIcon = get(fields, ['buttonEnableIcon'], false);
        bool enableIconLeft = get(fields, ['buttonEnableIconLeft'], true);

        Map icon = get(fields, ['buttonIcon'], {});

        bool autoIconItem = get(fields, ['autoIconItem'], false);
        double iconSize = ConvertData.stringToDouble(get(fields, ['buttonIconSizeItem'], 14), 14);
        Color iconColor = ConvertData.fromRGBA(get(fields, ['buttonIconColorItem', themeModeKey], null), Colors.white);

        Widget iconWidget = CirillaIconBuilder(
          data: icon,
          size: autoIconItem ? iconSize : styleTextButton?.fontSize,
          color: autoIconItem ? iconColor : styleTextButton?.color,
        );

        return Padding(
          padding: const EdgeInsets.only(top: itemPaddingExtraLarge),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: styleTitle.color,
              backgroundColor: background,
              textStyle: styleTextButton,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () => onPressed(buttonAction),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (buttonEnableIcon && enableIconLeft) ...[
                  iconWidget,
                  const SizedBox(width: 8),
                ],
                Text(textTitle),
                if (buttonEnableIcon && !enableIconLeft) ...[
                  const SizedBox(width: 8),
                  iconWidget,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
