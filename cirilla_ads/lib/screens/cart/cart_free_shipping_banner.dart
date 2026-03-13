import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FreeShippingBanner extends StatefulWidget {
  final VoidCallback onDismiss;

  const FreeShippingBanner({
    Key? key,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<FreeShippingBanner> createState() => _FreeShippingBannerState();
}

class _FreeShippingBannerState extends State<FreeShippingBanner>
    with TickerProviderStateMixin, Utility, NavigationMixin {
  // Constants
  static const Duration _animationDuration = Duration(milliseconds: 800);
  // static const double _dragThreshold = -10.0;
  static const double _progressHeight = 4.0;

  // Controllers and animations
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // State variables
  double _currentProgress = 0.0;
  CartStore? _cartStore;

  bool showFreeShippingBanner = true;

  @override
  void initState() {
    super.initState();
    _initializeCartStore();
    _initializeAnimations();
  }

  void _initializeCartStore() {
    _cartStore = Provider.of<AuthStore>(context, listen: false).cartStore;
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(FreeShippingBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProgress();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  // Data getters
  CartData? get _cartData => _cartStore?.cartData;

  String? get _currencyCode => get(_cartData?.totals, ['currency_code'], null);

  double get _totalPrice => ConvertData.stringToDouble(
        get(_cartData?.totals, ['total_price'], '0'),
        0.0,
      );

  double get _freeShippingThreshold => ConvertData.stringToDouble(
        get(_cartStore?.shippingSetting?.value, [], '0'),
        0.0,
      );

  bool get _isQualifiedForFreeShipping => _freeShippingThreshold > 0 && _totalPrice >= _freeShippingThreshold;

  double get _remainingAmount => (_freeShippingThreshold - _totalPrice).clamp(0.0, double.infinity);

  double get _progressValue =>
      _freeShippingThreshold > 0 ? (_totalPrice / _freeShippingThreshold).clamp(0.0, 1.0) : 0.0;

  void _updateProgress() {
    final newProgress = _progressValue;

    if (_currentProgress != newProgress) {
      _progressAnimation = Tween<double>(
        begin: _currentProgress,
        end: newProgress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));

      _currentProgress = newProgress;
      _progressController.forward(from: 0.0);
    }
  }

  // void _handleVerticalDrag(DragUpdateDetails details) {
  //   if (details.primaryDelta! < _dragThreshold) {
  //     showFreeShippingBanner = false;
  //     widget.onDismiss();
  //   }
  // }

  String _getFormattedRemainingAmount() {
    return convertCurrency(
          context,
          currency: _currencyCode,
          price: _remainingAmount.toString(),
        ) ??
        '0';
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        if (_cartStore?.loadingShippingZonesMethod == true) {
          showFreeShippingBanner = true;
        }
        if (!showFreeShippingBanner) return const SizedBox.shrink();
        // Update progress when widget builds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateProgress();
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerContent(translate),
            _buildProgressIndicator(),
          ],
        );
      },
    );
  }

  Widget _buildBannerContent(TranslateType translate) {
    return GestureDetector(
      // onVerticalDragUpdate: _handleVerticalDrag,
      child: Container(
        color: Colors.orange.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _isQualifiedForFreeShipping ? _buildQualifiedContent(translate) : _buildNotQualifiedContent(translate),
      ),
    );
  }

  Widget _buildNotQualifiedContent(TranslateType translate) {
    final remainingAmountFormatted = _getFormattedRemainingAmount();
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: translate("cart_want_free_shipping"),
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: translate("cart_add_more_items", {"price": remainingAmountFormatted}),
                  style: textTheme.titleSmall?.copyWith(
                    color: ColorBlock.orangeDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildAddMoreButton(translate),
      ],
    );
  }

  Widget _buildQualifiedContent(TranslateType translate) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: translate("cart_free_shipping_description"),
            style: textTheme.labelMedium?.copyWith(
              color: ColorBlock.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: translate("cart_free_shipping"),
                style: textTheme.titleSmall?.copyWith(
                  color: ColorBlock.orangeDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMoreButton(TranslateType translate) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () {
        navigate(context, {
          "type": "tab",
          "router": "/",
          "args": {"key": "screens_category"}
        });
      },
      child: Text(
        translate("cart_add_more"),
        style: textTheme.labelMedium?.copyWith(
          color: ColorBlock.blueBase,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return LinearProgressIndicator(
          minHeight: _progressHeight,
          value: _progressAnimation.value,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        );
      },
    );
  }
}
