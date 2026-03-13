import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'upload_avatar_store.g.dart';

class UploadAvatarStore = UploadAvatarStoreBase with _$UploadAvatarStore;

const String avatarPrefix = "avatar_appcheap";
abstract class UploadAvatarStoreBase with Store {
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  UploadAvatarStoreBase(
    this._requestHelper,
    this._authStore,
  ) {
    _reaction();
  }

  // store variables:---------------------------------------------------------------------------------------------------
  static ObservableFuture<List<MediaModel>> emptyPostResponse = ObservableFuture.value([]);

  // observables:-------------------------------------------------------------------------------------------------------
  @observable
  ObservableFuture<List<MediaModel>?> fetchProductsFuture = emptyPostResponse;

  @observable
  ObservableList<MediaModel> _medias = ObservableList<MediaModel>.of([]);

  @observable
  bool _isLoading = false;

  @observable
  bool _isLoadingListAvatar = false;

  @observable
  bool _isLoadingRemoveAvatar = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  bool _canLoadMore = true;

  // computed:----------------------------------------------------------------------------------------------------------
  @computed
  bool get isLoading => _isLoading;

  @computed
  bool get isLoadingListAvatar => _isLoadingListAvatar;

  @computed
  bool get isLoadingRemoveAvatar => _isLoadingRemoveAvatar;

  @computed
  ObservableList<MediaModel> get medias => _medias;

  @computed
  int get perPage => _perPage;

  @computed
  bool get canLoadMore => _canLoadMore;

  // actions:----------------------------------------------------------------------------------------------------------
  @action
  Future<void> uploadAvatar({String? filePath, int? mediaId}) async {
    _isLoading = true;
    try {
      User? newUser = _authStore.user;
      FormData formData = FormData.fromMap({
        if (mediaId != null) 'media_id': mediaId,
        if (mediaId == null)
          'avatar': await MultipartFile.fromFile(
            filePath!,
            filename: "${avatarPrefix}_${newUser?.displayName}_${newUser?.id}_${filePath.split('/').last}",
          ),
        'user_id': newUser?.id,
      });
      final response = await _requestHelper.uploadAvatar(
        data: formData,
        queryParameters: {
          'app-builder-decode': true,
          'time': DateTime.now().millisecondsSinceEpoch,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_authStore.token}',
          },
        ),
      );
      User user = User(
        id: newUser!.id,
        roles: newUser.roles,
        displayName: newUser.displayName,
        avatar: response["data"]["avatar_url"],
        socialAvatar: newUser.socialAvatar,
        firstName: newUser.firstName,
        lastName: newUser.lastName,
        userEmail: newUser.userEmail,
        userLogin: newUser.userLogin,
        loginType: newUser.loginType,
        options: newUser.options,
        userNiceName: newUser.userNiceName,
        url: newUser.url,
      );
      _authStore.setUser(user);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }

  @action
  Future<List<MediaModel>> getListMediaByUser() async {
    _isLoadingListAvatar = true;
    try {
      final future = _requestHelper.getListMedia(
        queryParameters: {
          "search": avatarPrefix,
          "page": _nextPage,
          "per_page": _perPage,
        },
        data: {
          "author": _authStore.user?.id,
        }
      );
      fetchProductsFuture = ObservableFuture(future);
      return future.then((medias) {
        // Replace state in the first time or refresh
        if (_nextPage <= 1) {
          _medias = ObservableList<MediaModel>.of(medias ?? []);
        } else {
          // Add products when load more page
          _medias.addAll(ObservableList<MediaModel>.of(medias ?? []));
        }

        // Check if can load more item
        if (medias != null && medias.length >= _perPage) {
          _nextPage++;
        } else {
          _canLoadMore = false;
        }
        _isLoadingListAvatar = false;
        return medias ?? <MediaModel>[];
      }).catchError((error) {
        avoidPrint('Error loading media list: $error');
        _isLoadingListAvatar = false;
        _canLoadMore = false;
        // Return empty list instead of throwing error
        return <MediaModel>[];
      });
    } catch (e) {
      avoidPrint('Error in getListMediaByUser: $e');
      _isLoadingListAvatar = false;
      _canLoadMore = false;
      // Return empty list instead of rethrowing
      return <MediaModel>[];
    }
  }

  /// Delete multiple media
  Future<void> deleteMultiMedia({List<dynamic> mediaSelected = const []}) async {
    _isLoadingRemoveAvatar = true;
    try {
      // Delete  media from your call api
      int j = -1;
      await Future.doWhile(() async {
        j++;
        if (j < mediaSelected.length && mediaSelected[j] is MediaModel) {
          await _requestHelper.deleteMedia(
            id: mediaSelected[j].id,
            queryParameters: {
              'force': true,
              'app-builder-decode': true,
            },
            options: Options(
              headers: {
                'Authorization': 'Bearer ${_authStore.token}',
              },
            ),
          );

          return true;
        }
        return false;
      });
      _isLoadingRemoveAvatar = false;
      await refresh();
    } catch (e) {
      _isLoadingRemoveAvatar = false;
      rethrow;
    }
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getListMediaByUser();
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