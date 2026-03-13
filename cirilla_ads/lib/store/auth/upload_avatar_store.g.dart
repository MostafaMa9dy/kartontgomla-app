// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_avatar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UploadAvatarStore on UploadAvatarStoreBase, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'UploadAvatarStoreBase.isLoading'))
          .value;
  Computed<bool>? _$isLoadingListAvatarComputed;

  @override
  bool get isLoadingListAvatar => (_$isLoadingListAvatarComputed ??=
          Computed<bool>(() => super.isLoadingListAvatar,
              name: 'UploadAvatarStoreBase.isLoadingListAvatar'))
      .value;
  Computed<bool>? _$isLoadingRemoveAvatarComputed;

  @override
  bool get isLoadingRemoveAvatar => (_$isLoadingRemoveAvatarComputed ??=
          Computed<bool>(() => super.isLoadingRemoveAvatar,
              name: 'UploadAvatarStoreBase.isLoadingRemoveAvatar'))
      .value;
  Computed<ObservableList<MediaModel>>? _$mediasComputed;

  @override
  ObservableList<MediaModel> get medias => (_$mediasComputed ??=
          Computed<ObservableList<MediaModel>>(() => super.medias,
              name: 'UploadAvatarStoreBase.medias'))
      .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'UploadAvatarStoreBase.perPage'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'UploadAvatarStoreBase.canLoadMore'))
          .value;

  late final _$fetchProductsFutureAtom =
      Atom(name: 'UploadAvatarStoreBase.fetchProductsFuture', context: context);

  @override
  ObservableFuture<List<MediaModel>?> get fetchProductsFuture {
    _$fetchProductsFutureAtom.reportRead();
    return super.fetchProductsFuture;
  }

  @override
  set fetchProductsFuture(ObservableFuture<List<MediaModel>?> value) {
    _$fetchProductsFutureAtom.reportWrite(value, super.fetchProductsFuture, () {
      super.fetchProductsFuture = value;
    });
  }

  late final _$_mediasAtom =
      Atom(name: 'UploadAvatarStoreBase._medias', context: context);

  @override
  ObservableList<MediaModel> get _medias {
    _$_mediasAtom.reportRead();
    return super._medias;
  }

  @override
  set _medias(ObservableList<MediaModel> value) {
    _$_mediasAtom.reportWrite(value, super._medias, () {
      super._medias = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: 'UploadAvatarStoreBase._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_isLoadingListAvatarAtom = Atom(
      name: 'UploadAvatarStoreBase._isLoadingListAvatar', context: context);

  @override
  bool get _isLoadingListAvatar {
    _$_isLoadingListAvatarAtom.reportRead();
    return super._isLoadingListAvatar;
  }

  @override
  set _isLoadingListAvatar(bool value) {
    _$_isLoadingListAvatarAtom.reportWrite(value, super._isLoadingListAvatar,
        () {
      super._isLoadingListAvatar = value;
    });
  }

  late final _$_isLoadingRemoveAvatarAtom = Atom(
      name: 'UploadAvatarStoreBase._isLoadingRemoveAvatar', context: context);

  @override
  bool get _isLoadingRemoveAvatar {
    _$_isLoadingRemoveAvatarAtom.reportRead();
    return super._isLoadingRemoveAvatar;
  }

  @override
  set _isLoadingRemoveAvatar(bool value) {
    _$_isLoadingRemoveAvatarAtom
        .reportWrite(value, super._isLoadingRemoveAvatar, () {
      super._isLoadingRemoveAvatar = value;
    });
  }

  late final _$_nextPageAtom =
      Atom(name: 'UploadAvatarStoreBase._nextPage', context: context);

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
      Atom(name: 'UploadAvatarStoreBase._perPage', context: context);

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

  late final _$_canLoadMoreAtom =
      Atom(name: 'UploadAvatarStoreBase._canLoadMore', context: context);

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

  late final _$uploadAvatarAsyncAction =
      AsyncAction('UploadAvatarStoreBase.uploadAvatar', context: context);

  @override
  Future<void> uploadAvatar({String? filePath, int? mediaId}) {
    return _$uploadAvatarAsyncAction
        .run(() => super.uploadAvatar(filePath: filePath, mediaId: mediaId));
  }

  late final _$getListMediaByUserAsyncAction =
      AsyncAction('UploadAvatarStoreBase.getListMediaByUser', context: context);

  @override
  Future<List<MediaModel>> getListMediaByUser() {
    return _$getListMediaByUserAsyncAction
        .run(() => super.getListMediaByUser());
  }

  late final _$UploadAvatarStoreBaseActionController =
      ActionController(name: 'UploadAvatarStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$UploadAvatarStoreBaseActionController.startAction(
        name: 'UploadAvatarStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$UploadAvatarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchProductsFuture: ${fetchProductsFuture},
isLoading: ${isLoading},
isLoadingListAvatar: ${isLoadingListAvatar},
isLoadingRemoveAvatar: ${isLoadingRemoveAvatar},
medias: ${medias},
perPage: ${perPage},
canLoadMore: ${canLoadMore}
    ''';
  }
}
