class VariationModel {
  final List<Map<String, dynamic>> variations;
  final List<AttributeModel> attributes;

  const VariationModel({
    required this.attributes,
    required this.variations,
  });
}


class AttributeModel {
  final int id;
  final String name;
  final String slug;
  final String type;
  final String layout;
  final List<TermModel> terms;

  const AttributeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.layout,
    required this.terms,
  });
}

class TermModel {
  final int id;
  final String name;
  final String slug;
  final String? value;
  final String? imageProduct;

  const TermModel({
    required this.id,
    required this.name,
    required this.slug,
    this.value,
    this.imageProduct,
  });
}
