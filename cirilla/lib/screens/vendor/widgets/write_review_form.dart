import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/screens/vendor/review/field_input.dart';

class WriteReviewForm extends StatefulWidget {
  final Vendor vendor;
  const WriteReviewForm({
    required this.vendor,
    Key? key,
  }) : super(key: key);

  @override
  State<WriteReviewForm> createState() => _WriteReviewFormState();
}

class _WriteReviewFormState extends State<WriteReviewForm> with AppBarMixin, LoadingMixin, TransitionMixin, SnackMixin {
  final _formKey = GlobalKey<FormState>();
  late VendorReviewFormStore _vendorReviewStore;
  late AuthStore _authStore;
  late AppStore _appStore;
  List<int> ratingNew = [];

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _appStore = Provider.of<AppStore>(context);

    int storeId = widget.vendor.id ?? 0;
    int userId = int.tryParse(_authStore.user?.id ?? "") ?? 0;

    Map<String, dynamic> initForm = {
      "wcfm_review_store_id": storeId,
      "wcfm_review_author_id": userId,
    };
    String keyStore = "vendor_review_form";
    if (_appStore.getStoreByKey(keyStore) == null) {
      VendorReviewFormStore store = VendorReviewFormStore(
        Provider.of<RequestHelper>(context),
        key: keyStore,
        initForm: initForm,
      )..storesReviewForm();

      _appStore.addStore(store);
      _vendorReviewStore = store;
    } else {
      _vendorReviewStore = _appStore.getStoreByKey(keyStore)..updateInitForm(initForm);
    }
    super.didChangeDependencies();
  }

  void onSubmit(BuildContext context) async {

    Map<String, dynamic> res = await _vendorReviewStore.writeStoreReview();

    bool status = get(res, ['status'], false);
    if (!status && context.mounted) {
      String? message = get(res, ['message'], '');
      showSuccess(context, '$message');
    }
    if (status && context.mounted) {
      Navigator.of(context).pop({
        'refresh': true,
        'res': res,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Widget body;

    return Observer(
      builder: (context) {
        bool loadingForm = _vendorReviewStore.loadingStoreForm;
        bool loadingSubmit = _vendorReviewStore.loadingSubmitStoreReview;
        List<VendorReviewField> fields = _vendorReviewStore.storeReviewFrom;
        Map<String, dynamic> data = _vendorReviewStore.form;

        if (loadingForm) {
          body = Center(
            child: buildLoadingOverlay(context),
          );
        } else {
          body = SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: theme.cardColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: paddingHorizontal.add(paddingVerticalMedium),
                          child: Row(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: theme.dividerColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CirillaCacheImage(
                                    widget.vendor.gravatar,
                                    width: 50,
                                    height: 50,
                                    // fit: fit,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(child: Text(widget.vendor.storeName ?? "", style: theme.textTheme.bodyMedium)),
                            ],
                          ),
                        ),
                        const Divider(height: 1, thickness: 1),
                      ],
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, int i) {
                      VendorReviewField field = fields[i];

                      return ReviewFieldInput(
                        value: data[field.id],
                        field: field,
                        onChange: (newValue) => _vendorReviewStore.changeForm(field.id, newValue),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: itemPaddingMedium),
                    itemCount: fields.length,
                    padding: const EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPaddingLarge),
                  ),
                ],
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: baseStyleAppBar(context, title: translate('product_write_review')),
            body: body,
            bottomNavigationBar: buildBtnSubmit(loadingSubmit, translate),
          ),
        );
      },
    );
  }

  Widget buildBtnSubmit(bool loadingSubmit, TranslateType translate) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: paddingHorizontal.copyWith(bottom: layoutPadding),
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!loadingSubmit && _formKey.currentState!.validate()) {
            onSubmit(context);
          }
        },
        child: loadingSubmit
            ? entryLoading(context, color: theme.colorScheme.onPrimary)
            : Text(translate('product_submit_review')),
      ),
    );
  }
}
