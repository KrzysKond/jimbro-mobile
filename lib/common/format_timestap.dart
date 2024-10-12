import 'package:intl/intl.dart';

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  if (now.year == timestamp.year && now.month == timestamp.month && now.day == timestamp.day) {
    return DateFormat('hh:mm a').format(timestamp);
  } else {
    return DateFormat('EEEE, hh:mm a').format(timestamp);
  }
}