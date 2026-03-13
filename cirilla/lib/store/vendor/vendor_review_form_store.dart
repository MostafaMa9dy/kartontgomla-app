import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/vendor_review.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'vendor_review_form_store.g.dart';

class VendorReviewFormStore = VendorReviewFormStoreBase with _$VendorReviewFormStore;

abstract class VendorReviewFormStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  // Constructor: ------------------------------------------------------------------------------------------------------
  VendorReviewFormStoreBase(this._requestHelper, { this.key, required Map<String, dynamic> initForm }) {
    _initForm = ObservableMap<String, dynamic>.of(initForm);
  }

  // Store variables: --------------------------------------------------------------------------------------------------

  @observable
  ObservableList<VendorReviewField> _storeReviewForm = ObservableList<VendorReviewField>.of([]);

  @observable
  ObservableMap<String, dynamic> _form = ObservableMap<String, dynamic>.of({});

  @observable
  bool _loadingStoreForm = false;

  @observable
  bool _loadingSubmitStoreReview = false;

  @observable
  ObservableMap<String, dynamic> _initForm = ObservableMap<String, dynamic>.of({});

  // Computed:----------------------------------------------------------------------------------------------------------

  @computed
  ObservableList<VendorReviewField> get storeReviewFrom => _storeReviewForm;

  @computed
  ObservableMap<String, dynamic> get form => _form;

  @computed
  bool get loadingStoreForm => _loadingStoreForm;

  @computed
  bool get loadingSubmitStoreReview => _loadingSubmitStoreReview;

  // Actions: ----------------------------------------------------------------------------------------------------------

  Future<Map<String, dynamic>> writeStoreReview() async {
    try {
      _loadingSubmitStoreReview = true;
      Map<String, dynamic> res = await _requestHelper.writeStoresReview(data: _form);
      _loadingSubmitStoreReview = false;
    Map<String, dynamic> dataForm = initFormReview(_storeReviewForm, _initForm);
    _form = ObservableMap<String, dynamic>.of(dataForm);
      return res;
    } on DioException {
      _loadingSubmitStoreReview = false;
      rethrow;
    }
  }

  Future<void> storesReviewForm() async {
    try {
      _loadingStoreForm = true;
      List<VendorReviewField> data = await _requestHelper.storesReviewForm();
      _storeReviewForm = ObservableList<VendorReviewField>.of(data.where((i) => i.context == "edit" && i.input != "hidden").toList());

      Map<String, dynamic> dataForm = initFormReview(data, _initForm);

      _form = ObservableMap<String, dynamic>.of(dataForm);
      _loadingStoreForm = false;
    } on DioException {
      _loadingStoreForm = false;
      rethrow;
    }
  }

  void changeForm(String key, dynamic value)  {
    _form = ObservableMap<String, dynamic>.of({
      ...form,
      key: value
    });
  }

  void updateInitForm(Map<String, dynamic> initForm) {
    Map<String, dynamic> dataForm = initFormReview(_storeReviewForm, initForm);
    _form = ObservableMap<String, dynamic>.of(dataForm);

    _initForm = ObservableMap<String, dynamic>.of(initForm);
  }

  // Disposers: --------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
