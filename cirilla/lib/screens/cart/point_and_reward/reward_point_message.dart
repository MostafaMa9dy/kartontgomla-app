// Flutter libraries
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../mixins/utility_mixin.dart';

// Packages and dependencies or helper functions

class CartRewardPointMessage extends StatelessWidget {
  final AuthStore authStore;
  final bool enablePointAndReward;
  const CartRewardPointMessage({
    Key? key,
    required this.authStore,
    this.enablePointAndReward = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    if (!enablePointAndReward) {
      return const SizedBox();
    }
    return Observer(
      builder: (context) {
        String? message = get(
          authStore.cartStore.cartData?.extensions,
          ['points-and-rewards', 'earn_points_message'],
          null,
        );
        if (message != null && message.isNotEmpty) {
          return Text(
            message,
            style: textTheme.titleMedium,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
