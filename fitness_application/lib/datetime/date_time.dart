// return todays date in the format yyyymmdd
String getTodayDateYMD() {
  final now = DateTime.now();
  final year = now.year.toString().padLeft(4, '0');
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return '$year$month$day';
}
//convert string yyyymmdd to DateTime object
DateTime parseYMDToDateTime(String ymd) {
  final year = int.parse(ymd.substring(0, 4));
  final month = int.parse(ymd.substring(4, 6));
  final day = int.parse(ymd.substring(6, 8));
  return DateTime(year, month, day);
}
//convert DateTime object to string yyyymmdd  
String formatDateTimeToYMD(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year$month$day';
}