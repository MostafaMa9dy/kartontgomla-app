// Core
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';

// Flutter library
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Packages and Dependencies or helper functions
import 'package:flutter_mobx/flutter_mobx.dart';



// Common
import 'package:provider/provider.dart';

import 'widgets/point_reward_event_item.dart';

class PointAndRewardPage extends StatelessWidget with AppBarMixin{
  static const routeName = '/profile/pointAndReward';

  const PointAndRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool isLogin = Provider.of<AuthStore>(context).isLogin;
        if (!isLogin) {
          return const Scaffold(
            body: Center(
              child: Text("You must login"),
            ),
          );
        }

        return Provider(
          create: (_) => PointAndRewardStore(
            Provider.of<RequestHelper>(context),
          ),
          child: const PointBody(),
        );
      },
    );
  }
}

class PointBody extends StatefulWidget {
  const PointBody({Key? key}) : super(key: key);

  @override
  State<PointBody> createState() => _PointBodyState();
}

class _PointBodyState extends State<PointBody> with AppBarMixin, LoadingMixin{
  late AppStore _appStore;
  late PointAndRewardStore _pointAndRewardStore;
  final ScrollController _controller = ScrollController();

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
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || _pointAndRewardStore.loadingListEvent || !_pointAndRewardStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _pointAndRewardStore.getPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('point')),
      body: Observer(builder: (context) {
        List<PointRewardEvent> pointRewardEvents = _pointAndRewardStore.pointRewardEvents;
        bool loading = _pointAndRewardStore.loadingListEvent;

        bool isShimmer = pointRewardEvents.isEmpty && loading;
        List<PointRewardEvent> loadingProduct = List.generate(10, (index) => PointRewardEvent()).toList();

        List<PointRewardEvent> data = isShimmer ? loadingProduct : pointRewardEvents;

        return CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _pointAndRewardStore.refresh,
              builder: buildAppRefreshIndicator,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      '${_pointAndRewardStore.pointReward?.pointsBalance ?? 0} ${_pointAndRewardStore.pointReward?.pointsLabel ?? 'Points'}',
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(translate('current_point_balance'), style: theme.textTheme.bodySmall),
                    const SizedBox(height: 32),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        double padBottom = index < data.length - 1 ? 16 : 0;
                        return Padding(
                          padding: EdgeInsets.only(bottom: padBottom),
                          child: PointRewardEventItem(item: data[index], loading: isShimmer),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (loading)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: _pointAndRewardStore.canLoadMore),
              ),
          ],
        );
      },),
    );
  }
}