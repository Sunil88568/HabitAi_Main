// <<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// =======
// >>>>>>> 4e74444032fe00d1b74968b3216ab253a048319f
// import 'package:kioski/utils/appUtils.dart';

class DateTimeUtils {
//get time stamp of length 13...
  static int get getCurrentTimeStamp => DateTime.now().millisecondsSinceEpoch;
  static int getTimeStamp(DateTime date) => date.millisecondsSinceEpoch;
// convert timeStamp to format string ....
  static String stampToPattern(int timeStamp, String pattern) =>
      dateTimeToPattern(stampToDateTime(timeStamp), pattern);
// convert time stamp to dateTime .....
  static DateTime stampToDateTime(int timeStamp) =>
      DateTime.fromMillisecondsSinceEpoch(timeStamp);
// convert string to dateTime .... returns DateTime
  static DateTime patternToDateTime(String value, String? pattern) =>

      pattern != null ? DateFormat(pattern).parse(value) : DateTime.parse(value).toLocal();
// convert dateTime to string pattern .... returns String
  static String dateTimeToPattern(DateTime dTime, String pattern) =>
      DateFormat(pattern).format(dTime);


  static String getChatTimeFormat(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    // AppUtils.log('currentTime :: ${now.toUtc().toLocal()}');
    // AppUtils.log('chatTime :: ${timestamp.toLocal()}');

    if (difference.inSeconds < 60) {
      return 'a sec ago';
    } else if (difference.inMinutes == 1) {
      return 'a min ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours == 1) {
      return '1 hr ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      switch (timestamp.weekday) {
        case DateTime.monday:
          return 'Monday';
        case DateTime.tuesday:
          return 'Tuesday';
        case DateTime.wednesday:
          return 'Wednesday';
        case DateTime.thursday:
          return 'Thursday';
        case DateTime.friday:
          return 'Friday';
        case DateTime.saturday:
          return 'Saturday';
        case DateTime.sunday:
          return 'Sunday';
        default:
          return '';
      }
    } else {
      final isCurrentYear = timestamp.year == now.year;
      final formattedTime = DateFormat('hh:mma').format(timestamp);
      final formattedDate = DateFormat('dd MMM').format(timestamp);
      final formattedYear = DateFormat('yyyy').format(timestamp);

      if (isCurrentYear) {
        return '$formattedTime $formattedDate';
      } else {
        return '$formattedTime $formattedDate $formattedYear';
      }
    }
  }




}



class DateTimePattern {
  static const String dd_MM_yyyy_HHmm = 'dd-MM-yyyy HH:mm'; //08-12-2023 12:00
  static const String EEEEc_MMM_ddc_yyyy = 'EEEE, MMM dd, yyyy'; //Sunday, Feb 18, 2024
  static const String yyyy_MM_ddTHH_mm_ss = 'yyyy-MM-ddTHH:mm:ss';
  static const String yyyy_MM_ddTHH_mm_ssZ = "yyyy-MM-ddTHH:mm:ss.SSS'Z'";
  static const String yyyy_MM = "yyyy-MM'";
  static const String MM_yyyy = "MM-yyyy'";
//2024-03-26T02:21:49Z
  static const String ddMMMyyyy_hhmma =
      'dd MMM yyyy, hh:mm a'; //08-12-2023 12:00
  static const String dd_MMM_yyyy_hhmma = 'dd-MMM-yyyy hh:mm a'; //08-12-2023 12:00
  static const String ddMMyyyy = 'dd-MM-yyyy'; //08-12-2023
  static const String ddcMMcyyyy = 'dd/MM/yyyy'; //08-12-2023
  static const String ddMMMyyyy = 'dd-MMM-yyyy'; //08-12-2023
  static const String dd_MMM_yyyy = 'dd-MMM-yyyy'; //08-12-2023
  static const String HHmm = 'HH:mm'; //12:00
  static const String hhmm_a = 'hh:mm a'; //12:00
  static const String hhmma = 'hh:mma'; //12:00
  static const String yyyyMMdd = 'yyyy-MM-dd'; //12:00
}
// ' 12 Dec 2024, 12:30 PM'
// Extension
extension StampToPatternExtension on int {
  String get dd_MM_yyyy_HHmm =>
      DateTimeUtils.stampToPattern(this, DateTimePattern.dd_MM_yyyy_HHmm);
  String get ddMMMyyyy_hhmma =>
      DateTimeUtils.stampToPattern(this, DateTimePattern.ddMMMyyyy_hhmma);
  String get ddMMyyyy =>
      DateTimeUtils.stampToPattern(this, DateTimePattern.ddMMyyyy);
  String get yyyyMMdd =>
      DateTimeUtils.stampToPattern(this, DateTimePattern.yyyyMMdd);
  String get dd_MMM_yyyy =>
      DateTimeUtils.stampToPattern(this, DateTimePattern.dd_MMM_yyyy);
  String get HHmm => DateTimeUtils.stampToPattern(this, DateTimePattern.HHmm);
  String get hhmma => DateTimeUtils.stampToPattern(this, DateTimePattern.hhmma); }
// <<<<<<< HEAD

extension TimeOfDayExtn on TimeOfDay{
  String get HHmm {
    String hr = '$hour';
    String min = '$minute';
    if(hr.length == 1){
      hr = '0$hr';
    }
    if(min.length == 1){
      min = '0$min';
    }

    return '$hr:$min';

  }
}


// =======
// >>>>>>> 4e74444032fe00d1b74968b3216ab253a048319f
// Extension
extension DateTimeExtension on DateTime {
  int get timeStamp => DateTimeUtils.getTimeStamp(this);
  String get dd_MMM_yyyy =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.dd_MMM_yyyy);
  String get ddMMyyyy =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.ddMMyyyy);

  String get MM_yyyy =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.MM_yyyy);
// <<<<<<< HEAD
  String get MMs_dds_yy =>
      DateTimeUtils.dateTimeToPattern(this, 'MM/dd/yy');
  String get HHmm =>
      DateTimeUtils.dateTimeToPattern(this, 'HH:mm');
// =======
// >>>>>>> 4e74444032fe00d1b74968b3216ab253a048319f
  String get yyyy_MM  =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.yyyy_MM);

  String get yyyyMMdd  =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.yyyyMMdd);
  String get EEEEc_MMM_ddc_yyyy =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.EEEEc_MMM_ddc_yyyy);
  String get ddcMMcyyyy =>
      DateTimeUtils.dateTimeToPattern(this, DateTimePattern.ddcMMcyyyy);
}
// Extension
extension StringDateTimeExtension on String {

  int get timeStamp_from_dd_MMM_yyyy_hhmma => DateTimeUtils.patternToDateTime(this, DateTimePattern.dd_MMM_yyyy_hhmma)
      .timeStamp;

  int get timeStampChat => DateTimeUtils.patternToDateTime(this, DateTimePattern.yyyy_MM_ddTHH_mm_ssZ).timeStamp;

  String get hhmma_to_HHMM => DateTimeUtils.dateTimeToPattern(
      DateTimeUtils.patternToDateTime(this, DateTimePattern.hhmm_a),DateTimePattern.HHmm);

  int get timeStamp_from_dd_MMM_yyyy => DateTimeUtils.patternToDateTime(this, DateTimePattern.ddMMMyyyy).timeStamp;
  DateTime get yyyy_MM_ddTHH_mm_ss => DateTimeUtils.patternToDateTime(this,DateTimePattern.yyyy_MM_ddTHH_mm_ss);
  DateTime get ddMMyyyy => DateTimeUtils.patternToDateTime(this,DateTimePattern.ddMMyyyy);
  DateTime get yyyy_MM_ddTHH_mm_ssZ => DateTimeUtils.patternToDateTime(this,null);
  DateTime get yyyy_MM => DateTimeUtils.patternToDateTime(this,DateTimePattern.yyyy_MM);
  DateTime get MM_yyyy => DateTimeUtils.patternToDateTime(this,DateTimePattern.MM_yyyy);
  DateTime get yyyyMMdd => DateTimeUtils.patternToDateTime(this,DateTimePattern.yyyyMMdd);

  // String get getChatTime => DateTimeUtils.getChatTimeFormat(yyyy_MM_ddTHH_mm_ssZ);
  String get getChatTime => DateTimeUtils.getChatTimeFormat(yyyy_MM_ddTHH_mm_ssZ);




  bool get isDate { try {
    DateTimeUtils.patternToDateTime(this, DateTimePattern.dd_MMM_yyyy);
    return true; } catch (e) {
    return false; }
  }


  bool get isTime { try {
    DateTimeUtils.patternToDateTime(this, DateTimePattern.hhmma);
    return true; } catch (e) {
    return false; }
  }

}
