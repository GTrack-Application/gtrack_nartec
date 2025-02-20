import 'package:intl/intl.dart';

String dateFormat(String date) {
  return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
}

String dateTimeFormat(String date) {
  return DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.parse(date));
}
