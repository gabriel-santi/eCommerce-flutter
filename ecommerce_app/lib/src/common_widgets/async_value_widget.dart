import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
      {super.key, required this.value, required this.onData, this.onLoading});
  final AsyncValue<T> value;
  final Widget Function(T) onData;
  final Widget Function()? onLoading;

  @override
  Widget build(BuildContext context) {
    return value.when(
        data: onData,
        error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
        loading: () =>
            onLoading?.call() ?? Center(child: CircularProgressIndicator()));
  }
}
