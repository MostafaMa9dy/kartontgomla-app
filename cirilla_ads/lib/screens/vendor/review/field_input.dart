import 'package:flutter/material.dart';

import 'package:cirilla/models/models.dart';

import 'rating.dart';
import 'textarea.dart';
import 'text.dart';

class ReviewFieldInput extends StatelessWidget {
  final dynamic value;
  final VendorReviewField field;
  final ValueChanged<dynamic> onChange;

  const ReviewFieldInput({super.key, required this.value, required this.field, required this.onChange});

  @override
  Widget build(BuildContext context) {
    switch (field.input) {
      case "rating":
        return RatingInput(
          name: field.name,
          items: field.items ?? <VendorReviewFieldItem>[],
          value: value is List<int> ? value : null,
          onChange: onChange,
        );
      case "textarea":
        return TextareaInput(
          name: field.name,
          value: value is String ? value : null,
          onChanged: onChange,
        );
      default:
        return TextInput(
          name: field.name,
          value: value is String ? value : null,
          onChanged: onChange,
        );
    }
  }

}
