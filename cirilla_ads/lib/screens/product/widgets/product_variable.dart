import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/product/variable/attribute_variable.dart';
import 'package:cirilla/screens/product/variable/loading_variable.dart';
import 'package:cirilla/store/product/variation_store.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProductVariable extends StatelessWidget with LoadingMixin {
  final Product? product;
  final VariationStore? store;
  final TextAlign alignTitle;
  final bool productShowOutOfStock;
  final Size imageAttriSize;

  const ProductVariable({
    Key? key,
    this.product,
    this.store,
    this.alignTitle = TextAlign.start,
    this.productShowOutOfStock = false,
    this.imageAttriSize = const Size(38, 38),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (store!.data == null) {
        if (store!.loading) {
          return LoadingVariable(
            product: product,
            alignTitle: alignTitle,
            imageAttriSize: imageAttriSize,
          );
        } else {
          return const SizedBox();
        }
      }
      // This product is currently out of stock and unavailable.
      List<dynamic> dataVariations = store!.data!['variations'];
      if (dataVariations.isEmpty) {
        return Container();
      }

      Map<String, String> labels = store!.data!['attribute_labels'] ?? {};

      return Stack(
        children: [
          ListView.separated(
            itemBuilder: (_, int index) {
              return AttributeVariable(
                id: labels.keys.elementAt(index),
                label: labels[labels.keys.elementAt(index)],
                store: store,
                alignTitle: alignTitle,
                productShowOutOfStock: productShowOutOfStock,
                imageAttriSize: imageAttriSize,
              );
            },
            separatorBuilder: (_, int index) {
              return const SizedBox(height: 24);
            },
            itemCount: labels.keys.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 0,
            end: 0,
            child: InkWell(
              onTap: store!.clear,
              child: Text(
                AppLocalizations.of(context)!.translate('product_clear_all'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      );
    });
  }
}
