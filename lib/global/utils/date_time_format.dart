import 'package:intl/intl.dart';

String dateFormat(String date) {
  // check if date is null or empty
  if (date.isEmpty) {
    return "";
  }
  return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
}

String dateTimeFormat(String date) {
  return DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(date));
}
