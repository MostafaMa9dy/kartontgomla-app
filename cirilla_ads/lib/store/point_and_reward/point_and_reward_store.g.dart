// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_and_reward_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PointAndRewardStore on PointAndRewardStoreBase, Store {
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'PointAndRewardStoreBase.canLoadMore'))
          .value;
  Computed<ObservableList<PointRewardEvent>>? _$pointRewardEventsComputed;

  @override
  ObservableList<PointRewardEvent> get pointRewardEvents =>
      (_$pointRewardEventsComputed ??=
              Computed<ObservableList<PointRewardEvent>>(
                  () => super.pointRewardEvents,
                  name: 'PointAndRewardStoreBase.pointRewardEvents'))
          .value;
  Computed<bool>? _$loadingListEventComputed;

  @override
  bool get loadingListEvent => (_$loadingListEventComputed ??= Computed<bool>(
          () => super.loadingListEvent,
          name: 'PointAndRewardStoreBase.loadingListEvent'))
      .value;
  Computed<PointReward?>? _$pointRewardComputed;

  @override
  PointReward? get pointReward =>
      (_$pointRewardComputed ??= Computed<PointReward?>(() => super.pointReward,
              name: 'PointAndRewardStoreBase.pointReward'))
          .value;

  late final _$_pointRewardEventsAtom = Atom(
      name: 'PointAndRewardStoreBase._pointRewardEvents', context: context);

  @override
  ObservableList<PointRewardEvent> get _pointRewardEvents {
    _$_pointRewardEventsAtom.reportRead();
    return super._pointRewardEvents;
  }

  @override
  set _pointRewardEvents(ObservableList<PointRewardEvent> value) {
    _$_pointRewardEventsAtom.reportWrite(value, super._pointRewardEvents, () {
      super._pointRewardEvents = value;
    });
  }

  late final _$_nextPageAtom =
      Atom(name: 'PointAndRewardStoreBase._nextPage', context: context);

  @override
  int get _nextPage {
    _$_nextPageAtom.reportRead();
    return super._nextPage;
  }

  @override
  set _nextPage(int value) {
    _$_nextPageAtom.reportWrite(value, super._nextPage, () {
      super._nextPage = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'PointAndRewardStoreBase._perPage', context: context);

  @override
  int get _perPage {
    _$_perPageAtom.reportRead();
    return super._perPage;
  }

  @override
  set _perPage(int value) {
    _$_perPageAtom.reportWrite(value, super._perPage, () {
      super._perPage = value;
    });
  }

  late final _$_loadingListEventAtom =
      Atom(name: 'PointAndRewardStoreBase._loadingListEvent', context: context);

  @override
  bool get _loadingListEvent {
    _$_loadingListEventAtom.reportRead();
    return super._loadingListEvent;
  }

  @override
  set _loadingListEvent(bool value) {
    _$_loadingListEventAtom.reportWrite(value, super._loadingListEvent, () {
      super._loadingListEvent = value;
    });
  }

  late final _$_canLoadMoreAtom =
      Atom(name: 'PointAndRewardStoreBase._canLoadMore', context: context);

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  late final _$_pointRewardAtom =
      Atom(name: 'PointAndRewardStoreBase._pointReward', context: context);

  @override
  PointReward? get _pointReward {
    _$_pointRewardAtom.reportRead();
    return super._pointReward;
  }

  @override
  set _pointReward(PointReward? value) {
    _$_pointRewardAtom.reportWrite(value, super._pointReward, () {
      super._pointReward = value;
    });
  }

  late final _$getPointsAsyncAction =
      AsyncAction('PointAndRewardStoreBase.getPoints', context: context);

  @override
  Future<void> getPoints() {
    return _$getPointsAsyncAction.run(() => super.getPoints());
  }

  late final _$PointAndRewardStoreBaseActionController =
      ActionController(name: 'PointAndRewardStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$PointAndRewardStoreBaseActionController.startAction(
        name: 'PointAndRewardStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$PointAndRewardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canLoadMore: ${canLoadMore},
pointRewardEvents: ${pointRewardEvents},
loadingListEvent: ${loadingListEvent},
pointReward: ${pointReward}
    ''';
  }
}
