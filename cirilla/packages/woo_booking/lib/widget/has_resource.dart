import 'package:flutter/material.dart';
import 'package:woo_booking/helper.dart';

import 'item_resource.dart';

final DateTime defaultTime = DateTime(1999);
final DateTime nowBookingTime = DateTime.now();

class HasResource extends StatefulWidget {
  final List<int> resourceIds;
  final List<Map<String, dynamic>> resourceProduct;
  final Function(List<dynamic> availability, int id)? onChange;
  final String? resourceLabel;
  const HasResource({
    Key? key,
    required this.resourceIds,
    required this.resourceProduct,
    this.onChange,
    this.resourceLabel,
  });
  State<HasResource> createState() => HasResourceState();
}

class HasResourceState extends State<HasResource> {
  Map<String, dynamic> isSelected = {};

  Widget buildViewModal({required String title, Widget? child}) {
    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(maxHeight: height / 2, minHeight: height / 3),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          Flexible(child: SingleChildScrollView(child: child))
        ],
      ),
    );
  }

  void onClickResource() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return buildViewModal(
          title: 'Has Resources',
          child: Column(
            children: widget.resourceProduct.map((data) {
              return ItemResource(
                data: data,
                onTap: (value) {
                  setState(() {
                    isSelected = value;
                  });
                  widget.onChange!(isSelected['availability'], isSelected['id']);
                  Navigator.pop(context);
                },
                value: '${isSelected['id'] ?? widget.resourceProduct[0]['id']}',
              );
            }).toList(),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.resourceIds.isNotEmpty && widget.resourceProduct.isNotEmpty) {
      String? type = widget.resourceLabel != '' ? widget.resourceLabel : 'Has Resources';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$type:", style: theme.textTheme.bodyMedium),
              const SizedBox(height: 5),
              InkWell(
                onTap: onClickResource,
                child: Container(
                  padding: EdgeInsets.only(left: 4, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${isSelected['name'] ?? get(widget.resourceProduct[0], ['name'], '')}'),
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }
}
