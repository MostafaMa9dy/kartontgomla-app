  import 'dart:io';
  import 'package:cirilla/constants/styles.dart';
  import 'package:cirilla/mixins/mixins.dart';
  import 'package:cirilla/types/types.dart';
  import 'package:cirilla/utils/app_localization.dart';
  import 'package:cirilla/utils/convert_data.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'validate_field.dart';
  import 'package:dio/dio.dart'; // أضف هذا السطر في أعلى الملف

  class AddressFieldFile extends StatefulWidget {
    final String? value;
    final ValueChanged<String> onChanged;
    final bool borderFields;
    final Map<String, dynamic> field;

    const AddressFieldFile({
      Key? key,
      this.value,
      this.borderFields = false,
      required this.onChanged,
      required this.field,
    }) : super(key: key);

    @override
    State<AddressFieldFile> createState() => _AddressFieldFileState();
  }

  class _AddressFieldFileState extends State<AddressFieldFile> with Utility {
    final _txtInputText = TextEditingController();
    bool _isUploading = false;
    final ImagePicker _picker = ImagePicker();
    String? _imagePreview;  //sasa

    @override
    void initState() {
      getText();
      _txtInputText.addListener(_onChanged);
      super.initState();
    }

    @override
    void dispose() {
      _txtInputText.dispose();
      super.dispose();
    }

    @override
    void didUpdateWidget(covariant AddressFieldFile oldWidget) {
      super.didUpdateWidget(oldWidget);

      if (widget.value != oldWidget.value) {
        getText();
        setState(() {});
      }
    }


    void getText() {
      String defaultValue = get(widget.field, ['default'], '');

      String val = widget.value ?? defaultValue;

      _txtInputText.text = val;

      if (val.isNotEmpty && val.startsWith("http")) {
        _imagePreview = val;
      } else {
        _imagePreview = null;
      }
    }


    /// Save data in current state
    _onChanged() {
      if (_txtInputText.text != widget.value) {
        widget.onChanged(_txtInputText.text);
      }
    }

    void clearValue() {
      setState(() {
        _txtInputText.clear();
        _imagePreview = null;
      });

      widget.onChanged("");   // ⭐ مهم جدًا
    }



    // ---------------------------------------------------------
    // دالة اختيار الصورة ورفعها
    // ---------------------------------------------------------
    Future<void> pickAndUploadImage(BuildContext context) async {

      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("التصوير بالكاميرا"),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),

                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("اختيار من المعرض"),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),

              ],
            ),
          );
        },
      );

      if (source == null) return;

      try {

        final XFile? image = await _picker.pickImage(
          source: source,
          imageQuality: 70,      // ⭐ ضغط الصورة
          maxWidth: 1200,
        );

        if (image == null) return;
        setState(() {
          _imagePreview = image.path;   // preview local
          _isUploading = true;
        });


        String? imageUrl = await _uploadImageToWordPress(File(image.path));

        if (imageUrl != null) {
          setState(() {
            _txtInputText.text = imageUrl;
            _imagePreview = imageUrl;
          });

          widget.onChanged(imageUrl);   // ⭐ مهم جدًا
        }


      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("حدث خطأ أثناء اختيار الصورة")),
        );

      } finally {

        setState(() {
          _isUploading = false;
        });

      }
    }

    // ---------------------------------------------------------
    // دالة الرفع الحقيقية إلى موقعك
    // ---------------------------------------------------------
    Future<String?> _uploadImageToWordPress(File file) async {
      try {

        String fileName = file.path.split('/').last;

        Dio dio = Dio();

        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });

        final response = await dio.post(
          "https://kartontgomla.com/wp-json/app/v1/upload",
          data: formData,
          options: Options(
            headers: {
              "Accept": "application/json",
            },
            sendTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
          ),
        );

        if (response.statusCode == 200) {
          return response.data["url"];
        }

      } catch (e) {
        debugPrint("UPLOAD ERROR = $e");
      }

      return null;
    }

    @override
    Widget build(BuildContext context) {
      ThemeData theme = Theme.of(context);
      TranslateType translate = AppLocalizations.of(context)!.translate;

      String label = get(widget.field, ['label'], 'صورة المحل');
      String placeholder = get(widget.field, ['placeholder'], 'اضغط لرفع صورة');
      bool requiredInput = ConvertData.toBoolValue(widget.field["required"]) ?? false;
      List validate = ConvertData.toListValue(widget.field["validate"]);

      String? labelText = requiredInput ? '$label *' : label;

      // تحديد الأيقونة الجانبية (إما أيقونة تحميل، أو زر مسح، أو أيقونة رفع)
      Widget suffixWidget;
      if (_isUploading) {
        suffixWidget = const Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      } else if (_txtInputText.text.isNotEmpty) {
        suffixWidget = IconButton(
          iconSize: 16,
          icon: const Icon(Icons.close),
          onPressed: clearValue,
        );
      } else {
        suffixWidget = const Icon(Icons.upload_file, size: 20);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          TextFormField(
            controller: _txtInputText,
            readOnly: true,
            validator: (String? value) =>
                validateField(
                  translate: translate,
                  validate: validate,
                  requiredInput: requiredInput,
                  value: value,
                ),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: _isUploading
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
                  : const Icon(Icons.photo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: () {
              if (!_isUploading) {
                pickAndUploadImage(context);
              }
            },
          ),

          if (_imagePreview != null && _imagePreview!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _imagePreview!.startsWith("http")
                      ? Image.network(
                    _imagePreview!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (c, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (c, e, s) {
                      return const SizedBox(
                        height: 150,
                        child: Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  )
                      : Image.file(
                    File(_imagePreview!),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),


                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => pickAndUploadImage(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),


                if (_isUploading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ]
          ,
        ],
      );
    }
  }