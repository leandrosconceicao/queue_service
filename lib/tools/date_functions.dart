import 'package:intl/intl.dart';

class FormatDate {
  static String standard(String date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(date).toLocal());
  }

  static String advpl(String date) {
    return DateFormat('yyyyddMM').format(DateTime.parse(date).toLocal());
  }

  static String setData(String date) {
    final d1 = date.split('/');
    return '${d1[2]}${d1[1]}${d1[0]}';
  }

  static DateTime toDateTime(String date) {
    return DateTime.parse(date);
  }
}