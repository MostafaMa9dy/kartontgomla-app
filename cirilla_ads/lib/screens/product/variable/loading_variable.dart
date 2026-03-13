import 'package:cirilla/models/models.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingVariable extends StatelessWidget {
  final Product? product;
  final TextAlign alignTitle;
  final Size imageAttriSize;

  const LoadingVariable({
    super.key,
    this.product,
    this.alignTitle = TextAlign.start,
    this.imageAttriSize = const Size(38, 38),
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Map<String, dynamic>> attrs = (product?.attributes ?? <Map<String, dynamic>>[])
        .where((Map<String, dynamic> item) =>
            ConvertData.toBoolValue(item["visible"]) == true && ConvertData.toBoolValue(item["variation"]) == true)
        .toList();

    return ListView.separated(
      itemBuilder: (_, int index) {
        Map<String, dynamic> item = attrs[index];
        List labelList = ['Image'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: Text("${item["name"] ?? ""}:", style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: labelList.contains(item["name"]) ? imageAttriSize.height : 34,
              child: ListView.separated(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CirillaShimmer(
                    child: Container(
                      height: labelList.contains(item["name"]) ? imageAttriSize.height : 34,
                      width: labelList.contains(item["name"]) ? imageAttriSize.width : 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(width: 1, color: theme.dividerColor),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, int index) {
        return const SizedBox(height: 28);
      },
      itemCount: attrs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
    );
  }
}
