import 'package:intl/intl.dart';

moneyFormatter(double numberFormat) {
  final NumberFormat usCurrency = NumberFormat('###,###', 'uz_UZ');
  return usCurrency.format(numberFormat);
}

moneyFormatterWidthDollor(double numberFormat) {
  final NumberFormat usCurrency = NumberFormat("#,##0.###");
  return usCurrency.format(numberFormat);
}

moneyFormatterWidthDollorNum(num numberFormat) {
  final NumberFormat usCurrency = NumberFormat("##,#0.00");
  return usCurrency.format(numberFormat);
}
