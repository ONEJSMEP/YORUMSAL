import 'package:intl/intl.dart';

class AppUtils {
  static String formatDate(DateTime date, {String format = 'dd MMMM yyyy'}) {
    return DateFormat(format, 'tr_TR').format(date); // Türkçe formatlama
  }
}