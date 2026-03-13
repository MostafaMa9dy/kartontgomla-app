import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'convert_data.dart';
import 'model.dart';
import 'widgets/attribute.dart';

class FlutterWpcLinkedVariationContainer extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String baseURL;
  final Map<String, dynamic>? query;

  const FlutterWpcLinkedVariationContainer({
    Key? key,
    this.data,
    required this.baseURL,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? id = data?["id"] is int ? data!["id"] : null;
    dynamic metaLinkedVariation = data?["meta_data"] is List
        ? (data!["meta_data"] as List)
            .firstWhere((e) => e["key"] == "_wcp_linked_variations_ids", orElse: () => {"value": []})
        : null;

    List ids = metaLinkedVariation is Map && metaLinkedVariation["value"] is List ? metaLinkedVariation["value"] : [];

    if (data != null && id != null && ids.isNotEmpty) {
      return _ViewVariation(
        data: data!,
        ids: ids,
        baseURL: baseURL,
        query: query,
      );
    }

    return Container();
  }
}

class _ViewVariation extends StatefulWidget {
  final Map<String, dynamic> data;
  final List ids;
  final String baseURL;
  final Map<String, dynamic>? query;

  const _ViewVariation({
    required this.data,
    required this.ids,
    required this.baseURL,
    this.query,
  });

  @override
  State<_ViewVariation> createState() => _ViewVariationState();
}

class _ViewVariationState extends State<_ViewVariation> {
  bool _loading = true;
  List<Map<String, dynamic>> _products = [];
  Map<String, String> _selectedCurrent = {};
  Map<String, String> _selected = {};

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  void init() async {
    try {
      var uri = Uri.parse("${widget.baseURL}/wc/v3/products").replace(queryParameters: {
        "include": widget.ids.join(","),
        "status": "publish",
        if (widget.query?.isNotEmpty == true) ...widget.query!,
      });
      var response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        if (data is List) {
          Map<String, String> selected = getAttribute(widget.data);
          setState(() {
            _products = data.cast<Map<String, dynamic>>();
            _selected = selected;
            _selectedCurrent = selected;
          });
        }
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void onChangeTerm({required String key, required String value}) {
    Map<String, String> selected = {..._selected};
    if (selected.containsKey(key)) {
      selected.update(key, (v) => value);
    } else {
      selected.putIfAbsent(key, () => value);
    }

    setState(() {
      _selected = selected;
    });

    Map<String, dynamic> findProduct = _products.firstWhere((p) {
      Map<String, String> attributes = getAttribute(p);
      return selected.keys.every(
        (el) {
          String key = el.toLowerCase();
          return attributes[key] == null || attributes[key] == '' || attributes[key] == selected[el];
        },
      );
    }, orElse: () {
      return {};
    });

    if (findProduct["id"] != null && findProduct["id"] != widget.data["id"]) {
      Navigator.pushNamed(context, "/product/${findProduct["id"]}", arguments: {
        "id": findProduct["id"],
      }).then((_) {
        setState(() {
          _selected = _selectedCurrent;
        });
      });
    }
  }

  Map<String, String> getAttribute(dynamic item) {
    dynamic metaAttributes = item["meta_data"] is List
        ? (item["meta_data"] as List)
            .firstWhere((e) => e["key"] == "_wcp_linked_variations_attributes", orElse: () => {"value": []})
        : null;

    List attrs = metaAttributes is Map && metaAttributes["value"] is List ? metaAttributes["value"] : [];

    Map<String, String> attributes = {};

    if (item["attributes"] is List && item["attributes"].isNotEmpty) {
      for (var i = 0; i < item["attributes"].length; i++) {
        dynamic attr = item["attributes"][i];
        String slug = attr["slug"];
        List<String> options = (attr["options"] ?? []).cast<String>();

        List dataTerms = attrs.firstWhere((e) => e["slug"] == slug, orElse: () {
          return {
            "terms": [],
          };
        })["terms"];

        Map selectedTerm = dataTerms.firstWhere((e) => options.contains(e["name"]), orElse: () {
          return {
            "slug": "",
          };
        });

        attributes.addAll({slug: selectedTerm["slug"]});
      }
    }

    return attributes;
  }

  String? getUrlImage(Map<String, dynamic> product) {
    if (product["images"] is List && (product["images"] as List).isNotEmpty) {
      return product["images"][0] is Map && product["images"][0]["src"] is String ? product["images"][0]["src"] : null;
    }
    return null;
  }

  int countAttr(Map<String, String> attributes, Map<String, String> selected) {
    int count = 0;
    if (selected.length < attributes.length) {
      for(int i = 0; i < selected.keys.length; i++) {
        String key = selected.keys.elementAt(i);
        if (attributes.containsKey(key) && attributes[key] == selected[key]) {
          count++;
        }
      }
    } else {
      for(int i = 0; i < attributes.keys.length; i++) {
        String key = attributes.keys.elementAt(i);
        if (selected.containsKey(key) && selected[key] == attributes[key]) {
          count++;
        }
      }
    }
    return count;
  }

  String? getImageProduct(String slugAttribute, String slugTerm, Map<String, String> selected, List<Map<String, dynamic>> variations) {

    List<Map<String, dynamic>> dataImageAttribute = [];

    for(var v in variations) {
      Map<String, String> attributes = getAttribute(v);
      if (attributes.containsKey(slugAttribute) && attributes[slugAttribute] == slugTerm) {
        dataImageAttribute.add({
          'count': countAttr(attributes, selected),
          'url': getUrlImage(v),
        });
      }
    }

    if (dataImageAttribute.isEmpty) {
      return null;
    } if (dataImageAttribute.length == 1) {
      return dataImageAttribute[0]["url"];
    } else {
      dataImageAttribute.sort((p1, p2) {
        return (p2["count"] as int).compareTo(p1["count"]);
      });
      return dataImageAttribute.elementAtOrNull(0)?["url"];
    }
  }

  VariationModel convertData(List attrs, List<Map<String, dynamic>> variations, Map<String, String> selected) {
    List<AttributeModel> attributes = <AttributeModel>[];

    for (int i = 0; i < attrs.length; i++) {
      dynamic attr = attrs[i];

      int id = ConvertData.stringToInt(attr["id"]);
      String slug = attr["slug"] ?? "";
      String name = attr["name"] ?? "";
      String type = attr["type"] ?? 'button';
      String layout = attr["layout"] ?? "default";

      List<TermModel> terms = <TermModel>[];

      List termsAttrs = attr["terms"] is List ? attr["terms"] : [];

      for (int j = 0; j < termsAttrs.length; j++) {
        dynamic term = termsAttrs[j];

        int idTerm = ConvertData.stringToInt(term["id"]);
        String slugTerm = term["slug"];
        String nameTerm = term["name"];
        String valueTerm = term["value"] is String ? term["value"] : "";

        String? imageProduct = getImageProduct(slug, slugTerm, selected, variations);

        terms.add(TermModel(
          id: idTerm,
          name: nameTerm,
          slug: slugTerm,
          value: valueTerm,
          imageProduct: imageProduct,
        ));
      }

      attributes.add(AttributeModel(
        id: id,
        name: name,
        slug: slug,
        type: type,
        layout: layout,
        terms: terms,
      ));
    }

    return VariationModel(
      attributes: attributes,
      variations: variations.map((v) {
        Map<String, String> attributes = getAttribute(v);
        return {...v, "attributes": attributes};
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SpinKitThreeBounce(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      );
    }

    dynamic metaAttributes = widget.data["meta_data"] is List
        ? (widget.data["meta_data"] as List)
            .firstWhere((e) => e["key"] == "_wcp_linked_variations_attributes", orElse: () => {"value": []})
        : null;

    List attrs = metaAttributes is Map && metaAttributes["value"] is List ? metaAttributes["value"] : [];

    VariationModel data = convertData(attrs, _products, _selectedCurrent);

    return ListView.separated(
      itemBuilder: (_, int index) {
        return AttributeWidget(
          attribute: data.attributes[index],
          variations: data.variations,
          selected: _selected,
          onChangeTerm: (String key, String value) => onChangeTerm(key: key, value: value),
        );
      },
      separatorBuilder: (_, int index) {
        return const SizedBox(height: 24);
      },
      itemCount: data.attributes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 1),
    );
  }
}
