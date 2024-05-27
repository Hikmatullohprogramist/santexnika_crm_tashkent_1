import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  if (date == null) {
    return ''; // Handle null case or return default value
  }
  return DateFormat("yyyy-MM-dd").format(date);
}

String formatDateWithHours(DateTime date) {
  if (date == null || date == "") {
    return ''; // Handle null case or return default value
  }
  return DateFormat("yyyy-MM-dd HH:mm").format(date);
}

String formatDateWithSlesh(DateTime date) {
  if (date == null) {
    return ''; // Handle null case or return default value
  }
  return DateFormat("yyyy/MM/dd").format(date);
}
