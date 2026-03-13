import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'review_item.dart';
import 'write_review_form.dart';

class ReviewList extends StatelessWidget {
  final List<VendorReview> data;
  final bool loading;
  final int perPage;

  const ReviewList({
    Key? key,
    this.data = const <VendorReview>[],
    this.loading = false,
    this.perPage = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading && data.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(data.length, (int i) => const VendorReviewItem()),
      );
    }

    if (!loading && data.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.length, (int i) => VendorReviewItem( item: data[i])),
    );
  }
}

class BottomWriteReview extends StatelessWidget with TransitionMixin, SnackMixin {
  final Vendor vendor;
  final VendorReviewListStore vendorReviewStore;
  const BottomWriteReview({
    required this.vendor,
    required this.vendorReviewStore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<AuthStore>(context).isLogin;
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Container(
      height: 66,
      width: double.infinity,
      alignment: Alignment.center,
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          child: Text(translate('product_write_review')),
          onPressed: () {
            if (!isLogin) {
              showError(
                context,
                translate('you_must_login'),
                action: SnackBarAction(
                  label: translate('login_txt_login'),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginScreen.routeName, arguments: {
                      'showMessage': ({String? message}) {
                        avoidPrint('113');
                      },
                    });
                  },
                ),
              );
            } else {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => WriteReviewForm(vendor: vendor),
                  transitionsBuilder: slideTransition,
                ),
              ).then((value) async {
                if (value != 'pop' && value['refresh'] && context.mounted) {
                  String? message = get(value, ['res', 'message'], '');
                  showSuccess(context, '$message');
                  await vendorReviewStore.refresh();
                }
              });
            }
          },
        ),
      ),
    );
  }
}
