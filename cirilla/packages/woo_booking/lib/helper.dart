import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'model/record.dart';

/// Filter date is enable or disable.
///
bool activeDayAppointment({
  required DateTime day,
  required Map<String, dynamic> bookableData,
  required List<RecordBooking> activeRecords,

  /// The [defaultDateAvailable] is All dates are... field in plugin setting.
  required bool defaultDateAvailable,
  required String minDateUnit,
  required int minDateValue,
  required String maxDateUnit,
  required int maxDateValue,
  required DateTime now,
  required List<String> restrictedDays,
  required bool hasRestrictedDay,
  required bool hasResources,
}) {
  
  if (defaultDateAvailable) {
    if (isSameDay(day, now) || day.isAfter(now)) {
      DateTime minTime = now;
      if (minDateValue > 0) {
        switch (minDateUnit) {
          case "day":
            minTime = now.add(Duration(days: minDateValue));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "week":
            minTime = now.add(Duration(days: minDateValue * 7));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "month":
            minTime = getNextMonth(minDateValue, now);
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      if (maxDateValue > 0) {
        DateTime maxTime = now;
        switch (maxDateUnit) {
          case "day":
            maxTime = now.add(Duration(days: maxDateValue));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "week":
            maxTime = now.add(Duration(days: maxDateValue * 7));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "month":
            maxTime = getNextMonth(maxDateValue, now.add(Duration(days: maxDateValue)));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      if (hasRestrictedDay && restrictedDays.isNotEmpty) {
        return _checkRestrictedDay(day, restrictedDays);
      }

      // Mark the days that are fully booked.
      if (activeRecords.isNotEmpty) {
        for (var i = 0; i < activeRecords.length; i++) {
          DateTime? date = activeRecords[i].date!;
          bool isActive = day.year == date.year && day.month == date.month && day.day == date.day;
          if (isActive) {
            return true;
          }
        }
      } else {
        return hasResources;
      }
    }
    return false;
  } else {
    List<dynamic> availabilityRules =
        (get(bookableData, ['availability_rules'], []) as List<dynamic>).first;
    bool bookable = false;
    if (availabilityRules.isNotEmpty) {
      DateTime minTime = now;
      if (minDateValue > 0) {
        switch (minDateUnit) {
          case "day":
            minTime = now.add(Duration(days: minDateValue));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "week":
            minTime = now.add(Duration(days: minDateValue * 7));
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          case "month":
            minTime = getNextMonth(minDateValue, now);
            if (day.isBefore(minTime) && day.day != minTime.day) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      if (maxDateValue > 0) {
        DateTime maxTime = now;
        switch (maxDateUnit) {
          case "day":
            maxTime = now.add(Duration(days: maxDateValue));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "week":
            maxTime = now.add(Duration(days: maxDateValue * 7));
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          case "month":
            maxTime = getNextMonth(maxDateValue, now);
            if (day.isAfter(maxTime)) {
              return false;
            }
            break;
          default:
            break;
        }
      }
      bookable = get(
          availabilityRules.first,
          [
            'range',
            (day.year.toString()),
            (day.month.toString()),
            (day.day.toString())
          ],
          false);
    }
    if (bookable) {
      if (hasRestrictedDay && restrictedDays.isNotEmpty) {
        return _checkRestrictedDay(day, restrictedDays);
      }
      return bookable;
    }
    return bookable;
  }
}

_checkRestrictedDay(
  DateTime date,
  List<String> restrictedDays,
) {
  List<String> days = restrictedDays;
  // Value 7 is Sunday.
  if (days.contains("0")) {
    days.add("7");
  }
  if (days.contains(date.weekday.toString())) {
    return true;
  }
  return false;
}

/// Get the next month.
///
/// Problem: If the day of current month is not in before month
/// (Ex: current is 2022/01/30, result will be 2022/03/02).
///
/// But not affect booking function.
DateTime getNextMonth(int addTime, DateTime now) {
  int year = now.year;
  int month = (now.month + addTime) % 12;
  int added = (now.month + addTime) ~/ 12;
  if (month != 0) {
    if (added > 0) {
      return DateTime(year + added, month, now.day);
    } else {
      return DateTime(year, month, now.day);
    }
  } else {
    year = year + (added - 1);
    if (added > 1) {
      return DateTime(year, now.month, now.day);
    } else {
      return DateTime(year, now.month + addTime, now.day);
    }
  }
}

/// Get the before month.
///
DateTime getBeforeMonth(int subTime, DateTime now) {
  if (now.month > subTime) {
    return DateTime(now.year, now.month - subTime);
  } else {
    if (subTime < 12) {
      return DateTime(now.year - 1, 12 + (now.month - subTime));
    } else {
      return getBeforeMonth(
          subTime % 12, DateTime(now.year - (subTime ~/ 12), now.month));
    }
  }
}

/// Get available custom months
///
List<DateTime> getCustomMonthsAvailable(DateTime start, DateTime end) {
  List<DateTime> result = [];
  DateTime startTime = start;
  DateTime endTime = end;
  // If isn't first day of the month, remove this month.
  if (start.day != 1) {
    startTime = getNextMonth(1, start);
  }
  // If day of end is not last day of the month, remove this month.
  if (end.month == end.add(const Duration(days: 1)).month) {
    endTime = getBeforeMonth(1, end);
  }

  if (endTime.year == startTime.year && endTime.month == startTime.month) {
    result.add(startTime);
  } else {
    int monthDif = endTime.month - startTime.month;
    int yearDif = endTime.year - startTime.year;
    if (yearDif == 0) {
      for (int i = 0; i <= monthDif; i++) {
        result.add(getNextMonth(i, startTime));
      }
    } else {
      int totalMonth = yearDif * 12 + monthDif;
      for (int i = 0; i <= totalMonth; i++) {
        result.add(getNextMonth(i, startTime));
      }
    }
  }
  return result;
}

dynamic get(dynamic data, List<dynamic> paths, [defaultValue]) {
  if (data == null || (paths.isNotEmpty && !(data is Map || data is List))) {
    return defaultValue;
  }
  if (paths.isEmpty) return data ?? defaultValue;
  List<dynamic> newPaths = List.of(paths);
  String? key = newPaths.removeAt(0);
  return get(data[key], newPaths, defaultValue);
}

/// Convert String to int
int stringToInt([dynamic value = '0', int initValue = 0]) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? initValue;
  }
  return initValue;
}

double stringToDouble(dynamic value, [double defaultValue = 0]) {
  if (value == null || value == "") {
    return defaultValue;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is double) {
    return value;
  }

  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

bool isSameMonth(DateTime a, DateTime b) {
  return (a.year == b.year && a.month == b.month);
}

DateTime getFutureDate(DateTime time, String unit, int addedValue) {
  DateTime result = time;
  switch (unit) {
    case 'month':
      result = getNextMonth(addedValue, time);
      return result;
    case 'week':
      result = time.add(Duration(days: 7 * addedValue));
      return result;
    case 'day':
      result = time.add(Duration(days: addedValue));
      return result;
    case 'hour':
      result = time.add(Duration(hours: addedValue));
      return result;
    default:
      return result;
  }
}

Map<String, dynamic> convertWeekToDateTime(Map<String, dynamic> data) {
  Map<String, dynamic> dataNew = data;
  String year = '${nowBookingTime.year}';
  String from = get(data, ['from'], '1');
  String to = get(data, ['to'], '1');
  if (from.length < 23) {
    int fromW = ((int.parse(from) - 1) * 7) + 1;
    Map<String, int> ymdFrom = convertDaysToYearMonthDay(fromW);

    int toW = (int.parse(to) * 7);
    Map<String, int> ymdTo = convertDaysToYearMonthDay(toW);

    dataNew['from'] = dateFormat.parse("$year-${ymdFrom['month']}-${ymdFrom['day']}}").toString();

    dataNew['to'] = dateFormat.parse("$year-${ymdTo['month']}-${ymdTo['day']}").toString();
  }
  return dataNew;
}

DateTime fromAndTo(Map<String, dynamic> data, {bool isFrom = true, bool customDate = false}) {
  String fromData = get(data, ['from'], '2022-10-02');
  String toData = get(data, ['to'], '2022-10-02');

  if (customDate) {
    String fromDate = get(data, ['from_date'], '1');
    String toDate = get(data, ['to_date'], '1');
    DateTime fromDateTime = DateFormat('yyyy-MM-dd hh:mm').parse('$fromDate $fromData').add(Duration(days: 1));
    DateTime toDateTime = DateFormat('yyyy-MM-dd hh:mm').parse('$toDate $toData').add(Duration(days: 1));
    if (isFrom) {
      return fromDateTime;
    }
    return toDateTime;
  } else {
    DateTime from = dateFormat.parse(fromData);
    DateTime to = dateFormat.parse(toData).add(Duration(days: 1));
    if (isFrom) {
      return from;
    }
    return to;
  }
}

bool isCheckCW(DateTime date, Map<String, dynamic> item, {bool isRange = false}) {
  if (isRange) {
    return date.isAfter(fromAndTo(item, customDate: true)) &&
        date.isBefore(fromAndTo(item, isFrom: false, customDate: true));
  }
  return date.isAfter(fromAndTo(item)) && date.isBefore(fromAndTo(item, isFrom: false));
}

bool isCheckMD(DateTime date, Map<String, dynamic> item, {bool isDay = false}) {
  String from = get(item, ['from'], '1');
  String to = get(item, ['to'], '1');
  int weekday = date.weekday;
  if (isDay) {
    return weekday >= int.parse(from) && weekday <= int.parse(to);
  }
  return date.month >= int.parse(from) && date.month <= int.parse(to);
}

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
final DateTime defaultTime = DateTime(1999);
final DateTime nowBookingTime = DateTime.now();
bool resource({
  required DateTime date,
  List<dynamic> availability = const [],
  final List<int> resourceIds = const [],
}) {
  if (resourceIds.isNotEmpty && availability.isNotEmpty) {
    
    availability.sort((a, b) {
      final ascending = a['priority'].compareTo(b['priority']);
      return ascending;
    });

    for (var item in availability) {
      String type = get(item, ['type'], '');
      String bookable = get(item, ['bookable'], '');
      switch (bookable) {
        case 'no':
          switch (type) {
            case 'custom':
              if (isCheckCW(date, item)) {
                return false;
              }
              break;
            case 'months':
              if (isCheckMD(date, item)) {
                return false;
              }
              break;
            case 'weeks':
              convertWeekToDateTime(item);
              if (isCheckCW(date, item)) {
                return false;
              }
              break;
            case 'days':
              if (isCheckMD(date, item, isDay: true)) {
                return false;
              }
              break;
            case 'custom:daterange':
              if (isCheckCW(date, item,isRange: true)) {
                return false;
              }
              break;
            default:
              break;
          }
          break;
        case 'yes':
          switch (type) {
            case 'custom':
              if (isCheckCW(date, item)) {
                return true;
              }
              break;
            case 'months':
              if (isCheckMD(date, item)) {
                return true;
              }
              break;
            case 'weeks':
              convertWeekToDateTime(item);
              if (isCheckCW(date, item)) {
                return true;
              }
              break;
            case 'days':
              if (isCheckMD(date, item, isDay: true)) {
                return true;
              }
              break;
            case 'custom:daterange':
              if (isCheckCW(date, item,isRange: true)) {
                return true;
              }
              break;
            default:
              break;
          }
          break;
        default:
          break;
      }
    }
  }
  return true;
}

/// Convert Days to Year,Month,Day Format
int daysInMonth(int year, int month) {
  List<int> monthLength = [
    31, // January
    (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28, // February
    31, // March
    30, // April
    31, // May
    30, // June
    31, // July
    31, // August
    30, // September
    31, // October
    30, // November
    31, // December
  ];
  return monthLength[month - 1];
}

Map<String, int> convertDaysToYearMonthDay(int days) {
  int year = DateTime.now().year; // Epoch time starts at 1970
  int month = 1;

  while (days >= 365) {
    if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
      if (days >= 366) {
        days -= 366;
        year += 1;
      }
    } else {
      days -= 365;
      year += 1;
    }
  }

  while (days > daysInMonth(year, month)) {
    days -= daysInMonth(year, month);
    month += 1;
  }

  return {
    'year': year,
    'month': month,
    'day': days,
  };
}
