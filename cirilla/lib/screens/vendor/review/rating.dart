import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/cirilla_rating.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RatingInput extends StatelessWidget {
  final String? name;
  final List<VendorReviewFieldItem> items;
  final List<int>? value;
  final ValueChanged<List> onChange;

  const RatingInput({
    super.key,
    this.name,
    this.value,
    required this.items,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Table(
      border: const TableBorder.symmetric(outside: BorderSide.none, inside: BorderSide.none),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(items.length, (int i) {
        VendorReviewFieldItem item = items[i];
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: itemPaddingLarge),
              child: Text(item.name, style: theme.textTheme.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CirillaRating.select(
                defaultRating: value?.elementAtOrNull(i) ?? 5,
                onFinishRating: (int newValue) {
                  List<int> newData = List.generate(items.length, (visit) {
                    if (visit == i) {
                      return newValue;
                    }
                    return value?[visit] is int ? value![visit] : 5;
                  }).toList();
                  if (listEquals(newData, value ?? []) == false) {
                    onChange(newData);
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
