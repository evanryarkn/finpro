import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime) {
    return DateFormat('yMMMd').format(dateTime);
  }
}
