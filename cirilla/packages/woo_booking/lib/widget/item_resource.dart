import 'package:flutter/material.dart';

class ItemResource extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic> data)? onTap;
  final String? value;
  const ItemResource({
    super.key,
    required this.data,
    this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleStyle = theme.textTheme.titleSmall;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);
    bool isSelected = '${data['id']}' == value;
    return InkWell(
      onTap: () {
        onTap!(data);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${data['name']}', style: isSelected ? activeTitleStyle : titleStyle),
                ),
                isSelected ? Icon(Icons.check, size: 20, color: theme.primaryColor) : const SizedBox(),
              ],
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, thickness: 1),
          ],
        ),
      ),
    );
  }
}
