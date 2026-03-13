// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VendorReviewListStore on VendorReviewListStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'VendorReviewListStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'VendorReviewListStoreBase.nextPage'))
          .value;
  Computed<ObservableList<VendorReview>>? _$reviewsComputed;

  @override
  ObservableList<VendorReview> get reviews => (_$reviewsComputed ??=
          Computed<ObservableList<VendorReview>>(() => super.reviews,
              name: 'VendorReviewListStoreBase.reviews'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'VendorReviewListStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'VendorReviewListStoreBase.perPage'))
      .value;
  Computed<int?>? _$storeIdComputed;

  @override
  int? get storeId => (_$storeIdComputed ??= Computed<int?>(() => super.storeId,
          name: 'VendorReviewListStoreBase.storeId'))
      .value;

  late final _$fetchReviewsFutureAtom = Atom(
      name: 'VendorReviewListStoreBase.fetchReviewsFuture', context: context);

  @override
  ObservableFuture<List<VendorReview>?> get fetchReviewsFuture {
    _$fetchReviewsFutureAtom.reportRead();
    return super.fetchReviewsFuture;
  }

  @override
  set fetchReviewsFuture(ObservableFuture<List<VendorReview>?> value) {
    _$fetchReviewsFutureAtom.reportWrite(value, super.fetchReviewsFuture, () {
      super.fetchReviewsFuture = value;
    });
  }

  late final _$_reviewsAtom =
      Atom(name: 'VendorReviewListStoreBase._reviews', context: context);

  @override
  ObservableList<VendorReview> get _reviews {
    _$_reviewsAtom.reportRead();
    return super._reviews;
  }

  @override
  set _reviews(ObservableList<VendorReview> value) {
    _$_reviewsAtom.reportWrite(value, super._reviews, () {
      super._reviews = value;
    });
  }

  late final _$successAtom =
      Atom(name: 'VendorReviewListStoreBase.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'VendorReviewListStoreBase._perPage', context: context);

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

  late final _$_nextPageAtom =
      Atom(name: 'VendorReviewListStoreBase._nextPage', context: context);

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

  late final _$_canLoadMoreAtom =
      Atom(name: 'VendorReviewListStoreBase._canLoadMore', context: context);

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

  late final _$_storeIdAtom =
      Atom(name: 'VendorReviewListStoreBase._storeId', context: context);

  @override
  int? get _storeId {
    _$_storeIdAtom.reportRead();
    return super._storeId;
  }

  @override
  set _storeId(int? value) {
    _$_storeIdAtom.reportWrite(value, super._storeId, () {
      super._storeId = value;
    });
  }

  late final _$getStoreReviewsAsyncAction = AsyncAction(
      'VendorReviewListStoreBase.getStoreReviews',
      context: context);

  @override
  Future<List<VendorReview>> getStoreReviews() {
    return _$getStoreReviewsAsyncAction.run(() => super.getStoreReviews());
  }

  late final _$VendorReviewListStoreBaseActionController =
      ActionController(name: 'VendorReviewListStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$VendorReviewListStoreBaseActionController
        .startAction(name: 'VendorReviewListStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$VendorReviewListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchReviewsFuture: ${fetchReviewsFuture},
success: ${success},
loading: ${loading},
nextPage: ${nextPage},
reviews: ${reviews},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
storeId: ${storeId}
    ''';
  }
}
