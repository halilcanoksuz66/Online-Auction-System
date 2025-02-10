import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return '';
  }
  final DateTime dateTime = timestamp.toDate();
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(dateTime);
}
