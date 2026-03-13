// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VendorReviewFormStore on VendorReviewFormStoreBase, Store {
  Computed<ObservableList<VendorReviewField>>? _$storeReviewFromComputed;

  @override
  ObservableList<VendorReviewField> get storeReviewFrom =>
      (_$storeReviewFromComputed ??=
              Computed<ObservableList<VendorReviewField>>(
                  () => super.storeReviewFrom,
                  name: 'VendorReviewFormStoreBase.storeReviewFrom'))
          .value;
  Computed<ObservableMap<String, dynamic>>? _$formComputed;

  @override
  ObservableMap<String, dynamic> get form => (_$formComputed ??=
          Computed<ObservableMap<String, dynamic>>(() => super.form,
              name: 'VendorReviewFormStoreBase.form'))
      .value;
  Computed<bool>? _$loadingStoreFormComputed;

  @override
  bool get loadingStoreForm => (_$loadingStoreFormComputed ??= Computed<bool>(
          () => super.loadingStoreForm,
          name: 'VendorReviewFormStoreBase.loadingStoreForm'))
      .value;
  Computed<bool>? _$loadingSubmitStoreReviewComputed;

  @override
  bool get loadingSubmitStoreReview => (_$loadingSubmitStoreReviewComputed ??=
          Computed<bool>(() => super.loadingSubmitStoreReview,
              name: 'VendorReviewFormStoreBase.loadingSubmitStoreReview'))
      .value;

  late final _$_storeReviewFormAtom = Atom(
      name: 'VendorReviewFormStoreBase._storeReviewForm', context: context);

  @override
  ObservableList<VendorReviewField> get _storeReviewForm {
    _$_storeReviewFormAtom.reportRead();
    return super._storeReviewForm;
  }

  @override
  set _storeReviewForm(ObservableList<VendorReviewField> value) {
    _$_storeReviewFormAtom.reportWrite(value, super._storeReviewForm, () {
      super._storeReviewForm = value;
    });
  }

  late final _$_formAtom =
      Atom(name: 'VendorReviewFormStoreBase._form', context: context);

  @override
  ObservableMap<String, dynamic> get _form {
    _$_formAtom.reportRead();
    return super._form;
  }

  @override
  set _form(ObservableMap<String, dynamic> value) {
    _$_formAtom.reportWrite(value, super._form, () {
      super._form = value;
    });
  }

  late final _$_loadingStoreFormAtom = Atom(
      name: 'VendorReviewFormStoreBase._loadingStoreForm', context: context);

  @override
  bool get _loadingStoreForm {
    _$_loadingStoreFormAtom.reportRead();
    return super._loadingStoreForm;
  }

  @override
  set _loadingStoreForm(bool value) {
    _$_loadingStoreFormAtom.reportWrite(value, super._loadingStoreForm, () {
      super._loadingStoreForm = value;
    });
  }

  late final _$_loadingSubmitStoreReviewAtom = Atom(
      name: 'VendorReviewFormStoreBase._loadingSubmitStoreReview',
      context: context);

  @override
  bool get _loadingSubmitStoreReview {
    _$_loadingSubmitStoreReviewAtom.reportRead();
    return super._loadingSubmitStoreReview;
  }

  @override
  set _loadingSubmitStoreReview(bool value) {
    _$_loadingSubmitStoreReviewAtom
        .reportWrite(value, super._loadingSubmitStoreReview, () {
      super._loadingSubmitStoreReview = value;
    });
  }

  late final _$_initFormAtom =
      Atom(name: 'VendorReviewFormStoreBase._initForm', context: context);

  @override
  ObservableMap<String, dynamic> get _initForm {
    _$_initFormAtom.reportRead();
    return super._initForm;
  }

  @override
  set _initForm(ObservableMap<String, dynamic> value) {
    _$_initFormAtom.reportWrite(value, super._initForm, () {
      super._initForm = value;
    });
  }

  @override
  String toString() {
    return '''
storeReviewFrom: ${storeReviewFrom},
form: ${form},
loadingStoreForm: ${loadingStoreForm},
loadingSubmitStoreReview: ${loadingSubmitStoreReview}
    ''';
  }
}
