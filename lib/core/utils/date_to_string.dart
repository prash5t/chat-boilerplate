// method to return a meaningful date data
// example: 2hours ago, Just Now, 3days ago
import 'package:intl/intl.dart';

String dateToString(String? dateTimeInString) {
  if (dateTimeInString == null || dateTimeInString == "") return "";
  DateTime dateTime = DateTime.parse(dateTimeInString);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 4) {
    final days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  } else {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }
}
