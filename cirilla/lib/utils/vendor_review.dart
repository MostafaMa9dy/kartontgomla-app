import 'package:cirilla/models/models.dart';

Map<String, dynamic> initFormReview(List<VendorReviewField> fields, Map<String, dynamic> initValues) {
  Map<String, dynamic> data = Map<String, dynamic>.of(initValues);

  for(VendorReviewField field in fields) {
    if (field.context == "edit") {
      String input = field.input;

      dynamic initValue;
      switch(input) {
        case "rating":
          initValue = field.items?.map((item) => item.value).toList().cast<int>() ?? (field.value is List<int> ? field.value: <int>[]);
          break;
        case "hidden":
          String type = field.type;
          switch(type) {
            case "array":
              if (field.items?.isNotEmpty == true) {
                initValue = field.items!.map((item) => item.value).toList();
              } else {
                initValue = field.value is List ? field.value: [];
              }
              break;
            case "integer":
              if (field.value is int) {
                initValue = field.value;
              }
              break;
            case "string":
              initValue =  field.value is String ? field.value : "";
              break;
          }
          break;
        default:
          initValue =  field.value is String ? field.value : "";
      }

      if (initValue != null) {
        data[field.id] = initValue;
      }
    }
  }

  return data;
}


