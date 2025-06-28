import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Currency formatter to be used in the app.
final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  return NumberFormat.simpleCurrency(locale: "en-US");
});
