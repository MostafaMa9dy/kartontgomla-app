import 'dart:convert';

import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html_form/flutter_html_form.dart';

Map<String, String?> _formatData(Map<String, dynamic> data) {
  Map<String, String?> value = {};
  for (var key in data.keys.toList()) {
    dynamic dataKey = data[key];

    String? valueKey;

    if (dataKey is String?) {
      valueKey = dataKey;
    } else if (dataKey is OptionValueModel) {
      if (dataKey.toValue() is List) {
        valueKey = jsonEncode(dataKey.toValue());
      } else if (dataKey.toValue() is String?) {
        valueKey = dataKey.toValue();
      }
    }
    value = {
      ...value,
      key: valueKey,
    };
  }
  return value;
}

class FormWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const FormWidget({
    super.key,
    this.widgetConfig,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget>
    with Utility, ContainerMixin, SnackMixin, LoadingMixin, NavigationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = {};

  bool _loading = false;

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void onSubmit(Map<String, dynamic>? action) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      await navigate(context, action, _formatData(_data));
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AuthStore authStore = Provider.of<AuthStore>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    // Fields
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    String form = ConvertData.textFromConfigs(fields["form"], settingStore.languageKey);
    Map<String, dynamic>? action = fields["action"] is Map<String, dynamic> ? fields["action"] : null;

    String html = unescape("<form>${fromContactFrom7(form)}</form>");

    Map<String, dynamic> user = authStore.isLogin ? authStore.user?.toJson() ?? {} : {};
    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: CirillaHtml(
        html: html,
        style: {
          "html": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
        },
        extensions: [
          FormExtension(formKey: _formKey),
          const LabelExtension(),
          InputExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
            user: user,
            submitLoading: _loading,
            submitLoadingWidget: entryLoading(context, color: theme.colorScheme.onPrimary),
            submitOnPressed: () => onSubmit(action),
          ),
          TextareaExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
            user: user,
          ),
          SelectExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
          ),
          CheckboxExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
          ),
          RadioExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
          ),
          AcceptanceExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
          ),
          QuizExtension(
            data: _data,
            onChange: (String key, dynamic value) {
              setState(() {
                _data = {..._data, key: value};
              });
            },
          ),
          ConditionalExtension(data: _data),
        ],
      ),
    );
  }
}