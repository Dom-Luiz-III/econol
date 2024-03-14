import 'package:intl/intl.dart';

num parseNumber(String text) {
  NumberFormat numberFormat = NumberFormat('0.00', 'pt_BR');
  return numberFormat.parse(text);
}

String formatCurrency(num value) {
  NumberFormat numberFormat = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
  return numberFormat.format(value);
}
