class DateHelper {
  static const months = ['ЈАН', 'ФЕВ', 'МАР', 'АПР', 'МАЈ', 'ЈУН', 'ЈУЛ', 'АВГ', 'СЕП', 'ОКТ', 'НОЕ', 'ДЕК'];
  static const fullMonth = [
    'Јануари',
    'Февруари',
    'Март',
    'Април',
    'Мај',
    'Јуни',
    'Јули',
    'Август',
    'Септември',
    'Октомври',
    'Ноември',
    'Декември'
  ];

  static String getFormattedDate(int year, int month) {
    return "${months[month-1]} '${year % 100}";
  }

  static String getFormattedDateForTransaction(DateTime timestamp) {
    return "${timestamp.day} ${fullMonth[timestamp.month-1]} ${timestamp.year}";
  }
}