//Core
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/string_generate.dart';
// Flutter library
import 'package:flutter/material.dart';
// Packages and Dependencies or helper functions
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TextPoint extends StatelessWidget {
  final TextStyle? style;
  const TextPoint({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PointAndRewardStore(
        Provider.of<RequestHelper>(context),
      ),
      child: TextContent(style: style),
    );
  }
}

class TextContent extends StatefulWidget {
  final TextStyle? style;

  const TextContent({Key? key, this.style}) : super(key: key);

  @override
  State<TextContent> createState() => _TextContentState();
}

class _TextContentState extends State<TextContent> {
  late AppStore _appStore;
  late PointAndRewardStore _pointAndRewardStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    String? keyStore = StringGenerate.getPointKeyStore(
      'point_balance',
      userId: Provider.of<AuthStore>(context).user?.id,
    );
    if (_appStore.getStoreByKey(keyStore) == null) {
      PointAndRewardStore store = PointAndRewardStore(
        Provider.of<RequestHelper>(context),
        perPage: 10,
        key: keyStore,
      )..getPoints();

      _appStore.addStore(store);
      _pointAndRewardStore = store;
    } else {
      _pointAndRewardStore = _appStore.getStoreByKey(keyStore);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Text(
          '${_pointAndRewardStore.pointReward?.pointsBalance ?? 0} ${_pointAndRewardStore.pointReward?.pointsLabel ?? 'Points'}',
          style: widget.style,
        );
      },
    );
  }
}