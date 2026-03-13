import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/query.dart';
import 'package:mobx/mobx.dart';

part 'vendor_review_list_store.g.dart';

class VendorReviewListStore = VendorReviewListStoreBase with _$VendorReviewListStore;

abstract class VendorReviewListStoreBase with Store {

  // Request helper instance
  final RequestHelper _requestHelper;

  // Constructor: ------------------------------------------------------------------------------------------------------
  VendorReviewListStoreBase(
      this._requestHelper, {
        int? perPage,
        int? storeId,
      }) {
    if (storeId != null) _storeId = storeId;
    if (perPage != null) _perPage = perPage;
  }

  // Store variables: --------------------------------------------------------------------------------------------------
  static ObservableFuture<List<VendorReview>> emptyProductReviewResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<VendorReview>?> fetchReviewsFuture = emptyProductReviewResponse;

  @observable
  ObservableList<VendorReview> _reviews = ObservableList<VendorReview>.of([]);

  @observable
  bool success = false;

  @observable
  int _perPage = 10;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  @observable
  int? _storeId;

  // Computed:----------------------------------------------------------------------------------------------------------
  @computed
  bool get loading => fetchReviewsFuture.status == FutureStatus.pending;


  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<VendorReview> get reviews => _reviews;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  int? get storeId => _storeId;

  // Actions: ----------------------------------------------------------------------------------------------------------
  @action
  Future<List<VendorReview>> getStoreReviews() async {
    final qs = {
      "page": _nextPage,
      "per_page": _perPage,
      "store_id": storeId,
    };

    final future = _requestHelper.getStoreReviews(queryParameters: preQueryParameters(qs));

    fetchReviewsFuture = ObservableFuture(future);

    return future.then((reviews) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _reviews = ObservableList<VendorReview>.of(reviews!);
      } else {
        // Add reviews when load more page
        _reviews.addAll(ObservableList<VendorReview>.of(reviews!));
      }

      // Check if can load more item
      if (reviews.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
      return _reviews;
    }).catchError((error) {
      throw error;
    });
  }
  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    _reviews.clear();
    return getStoreReviews();
  }

  // Disposers: --------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
