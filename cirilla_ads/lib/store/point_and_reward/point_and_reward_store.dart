import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'point_and_reward_store.g.dart';

class PointAndRewardStore = PointAndRewardStoreBase with _$PointAndRewardStore;

abstract class PointAndRewardStoreBase with Store {
  late RequestHelper _requestHelper;
  final String? key;

  // Constructor: ------------------------------------------------------------------------------------------------------

  PointAndRewardStoreBase(RequestHelper requestHelper, {int? perPage, this.key,}) {
    _requestHelper = requestHelper;
    if(perPage != null){
      _perPage = perPage;
    }
    _reaction();
  }

  // store variables:-----------------------------------------------------------


  @observable
  ObservableList<PointRewardEvent> _pointRewardEvents = ObservableList<PointRewardEvent>.of([]);

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  bool _loadingListEvent = false;


  @observable
  bool _canLoadMore = true;

  @observable
  PointReward? _pointReward;

  @computed
  bool get canLoadMore => _canLoadMore;


  @computed
  ObservableList<PointRewardEvent> get pointRewardEvents => _pointRewardEvents;

  @computed
  bool get loadingListEvent => _loadingListEvent;


  @computed
  PointReward? get pointReward => _pointReward;

  @action
  Future<void> getPoints() async {
    Map<String, dynamic> query = {
      'app-builder-decode': true,
      'page': _nextPage,
      'per_page': _perPage,
    };

    try {
      _loadingListEvent = true;
      PointReward pointReward = await _requestHelper.getPointReward(
        queryParameters: query,
      );
      List<PointRewardEvent> events = pointReward.events ?? [];

      List<PointRewardEvent> newEvents = [..._pointRewardEvents];
      if (_nextPage <= 1) {
        if(events.isNotEmpty){
          newEvents = events;
        }
      } else {
        if(events.isNotEmpty){
          newEvents.addAll(events);
        }
      }
      _loadingListEvent = false;
      _pointRewardEvents = ObservableList<PointRewardEvent>.of(newEvents);
      _pointReward = pointReward;
      // Check if can load more item

      if (events.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
    } on DioException {
      _loadingListEvent = false;
    }
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getPoints();
  }

  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}