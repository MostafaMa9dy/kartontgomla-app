import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

void showError(BuildContext context, dynamic e, {OnTap? onLinkTap, SnackBarAction? action}) {
  String? message = '';

  if (e.runtimeType == String) {
    message = e;
  } else if (e is DioException) {
    message = e.response != null && e.response?.data != null ? e.response?.data['message'] : e.message;
  }

  final snackBar = SnackBar(
    content: Builder(
      builder: (BuildContext context) => Html(
        data: "<div>$message</div>",
        style: {
          "div": Style(color: Colors.white),
          "a": Style(color: Colors.white, fontWeight: FontWeight.bold),
        },
        onLinkTap: onLinkTap,
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.error,
    action: action,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccess(BuildContext context, String? e, {OnTap? onLinkTap, SnackBarAction? action}) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 700),
    content: Row(
      children: [
        Expanded(
          child: Builder(
            builder: (BuildContext context) => Html(
              data: "<div>$e</div>",
              style: {
                "div": Style(
                  color: Colors.white,
                ),
                "a": Style(color: Colors.white, fontWeight: FontWeight.bold),
              },
              onLinkTap: onLinkTap,
            ),
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: action.onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: action.textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    ),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

abstract class SnackMixin {
  void showError(BuildContext context, dynamic e, {OnTap? onLinkTap, SnackBarAction? action}) => showError(context, e, onLinkTap: onLinkTap, action: action);

  void showSuccess(BuildContext context, String? e, {OnTap? onLinkTap, SnackBarAction? action}) => showError(context, e, onLinkTap: onLinkTap, action: action);
}