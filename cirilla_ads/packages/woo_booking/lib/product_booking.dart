library woo_booking;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:woo_booking/widget/calendar_header.dart';
import 'package:woo_booking/widget/counter.dart';
import 'package:woo_booking/widget/custom_duration.dart';
import 'package:woo_booking/widget/default_calendar.dart';
import 'package:woo_booking/helper.dart';
import 'package:woo_booking/model/record.dart';
import 'package:woo_booking/widget/months_available.dart';

import 'widget/list_time_stamp.dart';

import 'widget/has_resource.dart';

final DateTime defaultTime = DateTime(1999);
final DateTime nowBookingTime = DateTime.now();

enum WooBookingType { defaultBooking, customMonth, customDay, customHourMinute }

class ProductWooBooking extends StatefulWidget {
  /// Booking data.
  final Map<String, dynamic>? appointment;

  /// Return booking data.
  ///
  /// Result data is Map with bellow format:
  ///
  /// ```dart
  /// {
  ///   'wc_bookings_field_persons': '1', (nullable)
  ///   'date': '2022-10-20', (nullable)
  ///   'time': '10:59', (nullable)
  ///   'wc_bookings_field_duration': '2', (nullable)
  /// }
  ///
  /// ```
  final Function(Map<String, dynamic>)? onChanged;
  final String productId;

  /// Get slots for booking.
  ///
  final Future<Map<String, dynamic>> Function({Map<String, dynamic>? queryParameters, String? endPoint}) getSlots;

  /// Get product data.
  ///
  final Future<Map<String, dynamic>> Function({
    Map<String, dynamic>? queryParameters,
    required String productId,
    String? endPoint,
  }) getBookingProduct;

  /// Get bookable days.
  ///
  final Future<Map<String, dynamic>> Function({
    Map<String, dynamic>? queryParameters,
    required String endPoint,
  }) getBookableDays;

  /// Get bookable days for resource.
  ///
  final Future<List<Map<String, dynamic>>> Function({
    Map<String, dynamic>? queryParameters,
    required String endPoint,
  }) getBookableDaysResources;

  const ProductWooBooking({
    Key? key,
    this.appointment,
    this.onChanged,
    required this.productId,
    required this.getSlots,
    required this.getBookingProduct,
    required this.getBookableDays,
    required this.getBookableDaysResources,
  }) : super(key: key);

  @override
  State<ProductWooBooking> createState() => _ProductWooBookingState();
}

class _ProductWooBookingState extends State<ProductWooBooking> {
  PageController _pageController = PageController();
  Timer? _debounce;

  Map<String, dynamic> _bookableData = {};
  final List<RecordBooking> _activeRecords = [];

  bool _enableHeadingLeftArrow = false;

  /// The duration per booking.
  int _duration = 0;

  /// If [_hasRestrictedDays] is true, mode restricted day is on.
  bool _hasRestrictedDays = false;

  /// The unit of duration.
  String _durationUnit = "hour";

  /// The [_restrictedDays] is used when [_hasRestrictedDays] is true.
  final List<String> _restrictedDays = [];

  /// If value is true, all date can be booked without rules.
  bool _defaultDateAvailable = true;

  /// The [_minDateUnit] is Minimum block bookable field in plugin setting.
  String _minDateUnit = "day";

  /// The [_minDateValue] is Minimum block bookable field in plugin setting.
  int _minDateValue = 0;

  /// The [_maxDateUnit] is Maximum block bookable field in plugin setting.
  String _maxDateUnit = "day";

  /// The [_maxDateValue] is Maximum block bookable field in plugin setting.
  int _maxDateValue = 0;

  /// The [_customDuration] is Booking duration field in plugin setting.
  bool _customDuration = false;

  /// The [_maxDuration] is used when [_customDuration] is true.
  int _maxDuration = 0;

  /// The [_minDuration] is used when [_customDuration] is true.
  int _minDuration = 0;

  /// The [_customDurationValue] is used when [_customDuration] is true
  ///
  /// & unit duration is day or week or month.
  int _customDurationValue = 0;

  /// The [_startDateRange] is used when [_customDuration] is true
  ///
  /// & unit duration is day or week or month.
  DateTime? _startDateRange;

  /// The [_endDateRange] is used when [_customDuration] is true
  ///
  /// & unit duration is day or week or month.
  DateTime? _endDateRange;

  /// The[_monthsAvailable] is used when [_customDuration] is true & [_durationUnit] is month.
  final List<DateTime> _monthsAvailable = [];

  /// The [_currentMonthsAvailable] is sublist of [_monthsAvailable]
  List<DateTime> _currentMonthsAvailable = [];

  /// The [_availability] is available date range in plugin setting.
  List<dynamic> _availability = [];

  /// The [_hasPersons] is Person field in plugin setting.
  bool _hasPersons = false;

  /// The[_minPersons] is used when [_hasPersons] is true.
  int _minPersons = 0;

  /// The[_maxPerson] is used when [_hasPersons] is true.
  int _maxPerson = 0;

  /// The[_maxPerson] is used when [_hasPersons] is true.
  int _personsValue = 0;

  String? _resourceLabel;

  List<dynamic> availability = const [];

  int? resourceId;

  bool _enableRangePicker = false;

  List<int> _resourceIds = [];

  List<Map<String, dynamic>> _resourceProduct = [];

  static List<int> _toListInt(dynamic data) {
    if (data is List<dynamic>) {
      return data.map((e) => e as int).toList();
    }
    return [];
  }

  final List<RecordBooking> _timeStamps = [];
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(nowBookingTime);
  final ValueNotifier<DateTime> _pickedTime = ValueNotifier(defaultTime);
  final ValueNotifier<bool> _loadingCalendar = ValueNotifier(false);
  final ValueNotifier<bool> _loadingTimeStamp = ValueNotifier(false);

  DateTime startDate = DateTime(nowBookingTime.year, nowBookingTime.month, nowBookingTime.day);
  DateTime endDate = DateTime((nowBookingTime.month >= 11) ? nowBookingTime.year + 1 : nowBookingTime.year,
      (nowBookingTime.month >= 11) ? (nowBookingTime.month % 10) : nowBookingTime.month + 2);
  DateTime? _selectedDay;

  //-------------------Get data------------------------//
  Future<void> _getActiveData() async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    // Loading.
    _loadingTimeStamp.value = true;
    _loadingCalendar.value = true;

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      bool resourceInit = _resourceIds.isNotEmpty && resourceId == null;
      try {
        var data = await widget.getSlots(
          queryParameters: {
            "product_ids": widget.productId,
            "min_date": DateFormat("yyyy-MM-dd").format(nowBookingTime),
            "max_date": DateFormat("yyyy-MM-dd").format(nowBookingTime.add(const Duration(days: 3650))),
            if(_resourceIds.isNotEmpty) "resource_ids": resourceInit ? _resourceIds[0] : resourceId,
          },
          endPoint: "/wc-bookings/v1/products/slots",
        );
        // Add record.
        if (data["records"] != null) {
          _activeRecords.clear();
          setState(() {
            for (dynamic item in data["records"]) {
              if (item["available"] != null) {
                if (item["available"] > 0) {
                  _activeRecords.add(RecordBooking.fromJson(item));
                }
              }
            }
          });
        }
        // Add timestamp.
        _timeStamps.clear();
        for (var element in _activeRecords) {
          if (element.date != null && isSameDay(element.date!, nowBookingTime)) {
            _timeStamps.add(element);
          }
        }
        // Reset _pickedTime when selectedDay is changed.
        if (_pickedTime.value != defaultTime) {
          _pickedTime.value = defaultTime;
          widget.onChanged?.call({...?widget.appointment, 'type': WooBookingType.defaultBooking});
        }
        _loadingTimeStamp.value = false;
        _loadingCalendar.value = false;
      } catch (_) {
        _loadingTimeStamp.value = false;
        _loadingCalendar.value = false;
      }
    });
  }

  Future<void> _getBookableDays() async {
    dynamic data;
    try {
      if (!_loadingCalendar.value) {
        // Loading.
        _loadingCalendar.value = true;
      }
      // If it value is true, all date can be booked so don't need call api.
      if (_defaultDateAvailable) {
        data = {"do_not_need_get_bookable": true};
      } else {
        data = await widget.getBookableDays(
          queryParameters: {
            "product_id": widget.productId,
            "min_date": DateFormat("yyyy-MM-dd").format(startDate),
            "max_date": DateFormat("yyyy-MM-dd").format(endDate)
          },
          endPoint: "/app-builder/v1/bookings/find-booked-day-blocks",
        );
      }
      // Loaded.
      _loadingCalendar.value = false;

      setState(() {
        _bookableData = data;
      });
    } catch (_) {
      _loadingCalendar.value = false;
      setState(() {
        _bookableData = {"error": true};
      });
    }
  }

  /// Get list data has resources
  /// And create list data has resources in product
  _handleHasResource({int page = 1}) async {
    try {
      List<Map<String, dynamic>> resourceIds = await widget.getBookableDaysResources(
        endPoint: "/wc-bookings/v1/resources?page=$page&per_page=99",
      );
      if (resourceIds.isNotEmpty) {
        setState(() {
          for (int i = 0; i < _resourceIds.length; i++) {
            Iterable<Map<String, dynamic>> data = resourceIds.where((e) => e['id'] == _resourceIds[i]);
            if (data.length >= 1) {
              _resourceProduct.add(data.first);
              _loadingCalendar.value = false;
            } else {
              page = page + 1;
              _handleHasResource(page: page);
              _loadingCalendar.value = true;
            }
          }
        });
      }
    } catch (_) {
      _loadingCalendar.value = false;
    }
  }

  // count the number of days in a period of time
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day).add(Duration(days: 1));
    return (to.difference(from).inHours / 24).round();
  }

  void onChangedRange(bool customDurationRange, int duration, {bool isCount = true, DateTime? selectedDay}) {
    if (customDurationRange) {
      if (selectedDay != null) {
        _startDateRange = selectedDay;
        switch (_durationUnit) {
          case 'day':
            _endDateRange = _startDateRange!
                .add(Duration(days: (_customDurationValue > 0) ? (_customDurationValue * _duration) - 1 : 0));
            break;
        }
      }
      if (isCount) {
        if (_resourceIds.isNotEmpty && _resourceProduct.isNotEmpty) {
          widget.onChanged?.call({
            ...?widget.appointment,
            'date': DateFormat("yyyy-MM-dd").format(_startDateRange!),
            'endDate': DateFormat("yyyy-MM-dd").format(_endDateRange!),
            'time': DateFormat("HH:mm").format(_startDateRange!),
            'wc_bookings_field_duration': duration,
            'wc_bookings_field_resource': resourceId ?? _resourceProduct[0]['id'],
            'add-to-cart': widget.productId,
            "min_date": DateFormat("yyyy-MM-dd").format(startDate),
            "max_date": DateFormat("yyyy-MM-dd").format(endDate),
            'type': WooBookingType.customDay,
          });
        } else {
          widget.onChanged?.call({
            ...?widget.appointment,
            'date': DateFormat("yyyy-MM-dd").format(_startDateRange!),
            'time': DateFormat("HH:mm").format(_startDateRange!),
            'wc_bookings_field_duration': duration,
            'type': WooBookingType.customDay,
          });
        }
      }
    }
  }

  void onChangedDay(bool customDurationRange, DateTime start) {
    if (customDurationRange) {
      if (_durationUnit == 'hour' || _durationUnit == 'minute') {
        _startDateRange = null;
        _endDateRange = null;
        _getActiveData();
      }
    } else {
      _startDateRange = null;
      _endDateRange = null;
      if (_durationUnit == 'day') {
        if (_resourceIds.isNotEmpty && _resourceProduct.isNotEmpty) {
          widget.onChanged?.call({
            ...?widget.appointment,
            'date': DateFormat("yyyy-MM-dd").format(start),
            'time': DateFormat("HH:mm").format(start),
            'wc_bookings_field_resource': resourceId ?? _resourceProduct[0]['id'],
            'add-to-cart': widget.productId,
            "min_date": DateFormat("yyyy-MM-dd").format(startDate),
            "max_date": DateFormat("yyyy-MM-dd").format(endDate),
            'type': WooBookingType.defaultBooking,
          });
        } else {
          widget.onChanged?.call({
            ...?widget.appointment,
            'date': DateFormat("yyyy-MM-dd").format(start),
            'time': DateFormat("HH:mm").format(start),
            'type': WooBookingType.defaultBooking,
          });
        }
      }
    }
  }

  void _onSelected(DateTime? start, DateTime? end, DateTime focusedDay, {String enable = 'onDay'}) {
    bool customDurationRange = _customDuration && _durationUnit != 'minute' && _durationUnit != 'hour';
    switch (enable) {
      // Lets the user select a start and end date on the calendar
      // duration will be calculated automatically.
      case 'onRange':
        setState(() {
          _selectedDay = start;
          _focusedDay.value = focusedDay;
          _startDateRange = start;
          _endDateRange = end;
        });
        if (end == null) {
          widget.onChanged?.call({});
        }

        if (end != null) {
          int countOfDay = daysBetween(start!, end);
          bool isCount = countOfDay >= _minDuration || countOfDay <= _maxDuration;
          onChangedRange(customDurationRange, countOfDay, isCount: isCount);
        }
        onChangedDay(customDurationRange, start!);
        _getActiveData();
        break;
      case 'onDay':
        onChangedRange(customDurationRange, _customDurationValue, isCount: true, selectedDay: start);
        setState(() {
          _selectedDay = start;
          _focusedDay.value = focusedDay;
        });
        onChangedDay(customDurationRange, start!);
        _getActiveData();
        break;
      default:
        null;
    }
  }

  Future<void> _getAppointmentData() async {
    try {
      _loadingCalendar.value = true;
      // Get information of product.
      var product = await widget.getBookingProduct(
        productId: widget.productId,
        endPoint: "/wc-bookings/v1/products",
      );

      _defaultDateAvailable = get(product, ['default_date_availability'], '') == 'available';
      _durationUnit = get(product, ['duration_unit'], 'hour');
      _duration = stringToInt(get(product, ['duration'], 0));
      _hasRestrictedDays = get(product, ['has_restricted_days'], '') != '';
      dynamic restricted = get(product, ['restricted_days'], []);
      if (restricted is List) {
        for (var item in restricted) {
          _restrictedDays.add(item.toString());
        }
      }
      _minDateUnit = get(product, ['min_date_unit'], 'day');
      _minDateValue = get(product, ['min_date_value'], 0);
      _maxDateUnit = get(product, ['max_date_unit'], 'day');
      _maxDateValue = get(product, ['max_date_value'], 0);
      _customDuration = get(product, ['duration_type'], "fixed") == 'customer';
      _maxDuration = get(product, ['max_duration'], 0);
      _minDuration = get(product, ['min_duration'], 0);
      _customDurationValue = _minDuration;
      _availability = get(product, ['availability'], []);
      _hasPersons = get(product, ['has_persons'], false);
      _minPersons = get(product, ['min_persons'], 0);
      _personsValue = _minPersons;
      _maxPerson = get(product, ['max_persons'], 0);
      _enableRangePicker = get(product, ['enable_range_picker'], false);
      _resourceIds = _toListInt(get(product, ['resource_ids'], []));
      _resourceLabel = get(product, ['resource_label'], '');

      if (_resourceIds.isNotEmpty) {
        _handleHasResource();
      }

      /// Init first value;
      if (_hasPersons) {
        _onChangedPersons();
      }
      if (_customDuration && _durationUnit == 'month') {
        _bookableData = {"do_not_need_get_bookable": true};
        _handleAvailableMonthsBooking();
      } else {
        await _getBookableDays();
      }
      if (_loadingCalendar.value = true) {
        _loadingCalendar.value = false;
      }
    } catch (_) {
      _loadingCalendar.value = false;
    }
  }

  //---------------------------------------------------//
  /// Call if [_customDuration] is true and [_durationUnit] is month.
  _handleAvailableMonthsBooking() {
    /// If [_defaultDateAvailable] is true, available range follow [_minDateValue] & [_maxDateValue].
    if (_defaultDateAvailable) {
      DateTime start = getFutureDate(nowBookingTime, _minDateUnit, _minDateValue);
      DateTime end = getFutureDate(nowBookingTime, _maxDateUnit, _maxDateValue);
      // Get full day start month
      start = DateTime(start.year, start.month, 1);
      // Get full day end month
      end = getNextMonth(1, end);
      end = DateTime(end.year, end.month, 1);
      _monthsAvailable.addAll(getCustomMonthsAvailable(
        start,
        end,
      ));
    } else {
      for (var item in _availability) {
        if (get(item, ['bookable'], '') == 'yes') {
          _monthsAvailable.addAll(getCustomMonthsAvailable(
            DateFormat('yyyy-MM-dd').parse(get(item, ['from'], '2022-10-02')),
            DateFormat('yyyy-MM-dd').parse(get(item, ['to'], '2022-10-02')),
          ));
        }
      }
    }
    _currentMonthsAvailable.addAll(_monthsAvailable);
    _onChangedCustomDurationValue();
  }

  _onChangedCustomDurationValue() {
    switch (_durationUnit) {
      case 'month':
        _pickedTime.value = defaultTime;
        widget.onChanged
            ?.call({'type': WooBookingType.customMonth, 'wc_bookings_field_duration': _customDurationValue});
        if (_customDurationValue > _monthsAvailable.length) {
          _currentMonthsAvailable.clear();
        } else {
          if (_customDurationValue > 1) {
            _currentMonthsAvailable = _monthsAvailable.sublist(0, _monthsAvailable.length - (_customDurationValue - 1));
          } else {
            _currentMonthsAvailable = _monthsAvailable;
          }
        }
        setState(() {});
        break;
      case 'day':
        widget.onChanged?.call({
          ...?widget.appointment,
          'type': WooBookingType.customDay,
          'wc_bookings_field_duration': _customDurationValue
        });
        break;
      default:
        break;
    }
  }

  /// Used if [_hasPersons] is true.
  _onChangedPersons() {
    widget.onChanged?.call({
      ...?widget.appointment,
      'wc_bookings_field_persons': (_hasPersons) ? _personsValue : null,
    });
  }

  @override
  void didChangeDependencies() async {
    await _getAppointmentData();
    await _getActiveData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _focusedDay.addListener(() {
      DateTime now = nowBookingTime;
      DateTime nowMonth = DateTime(now.year, now.month);
      DateTime focusMonth = DateTime(_focusedDay.value.year, _focusedDay.value.month);

      _enableHeadingLeftArrow = focusMonth.compareTo(nowMonth) > 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Style.
    TextStyle defaultTextCalendar = theme.textTheme.titleSmall ?? const TextStyle();
    TextStyle disableTextCalendar = theme.textTheme.bodyMedium ?? const TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Persons space.
        if (_hasPersons)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Persons"),
                  const SizedBox(
                    height: 5,
                  ),
                  CounterBooking(
                      minValue: _minPersons,
                      maxValue: _maxPerson,
                      onChangedValue: (value) {
                        _personsValue = value;
                        _onChangedPersons();
                      })
                ],
              ),
            ),
          ),
        HasResource(
          resourceIds: _resourceIds,
          resourceProduct: _resourceProduct,
          resourceLabel: _resourceLabel,
          onChange: (data, id) {
            setState(() {
              availability = data;
              resourceId = id;
              _startDateRange = null;
              _endDateRange = null;
              _selectedDay = null;
              widget.onChanged?.call({});
              _getActiveData();
            });
          },
        ),
        // Calendar Space.
        Stack(
          children: [
            // Calendar.
            (_bookableData.isNotEmpty)
                ? (get(_bookableData, ['error'], false))
                    ? DefaultCalendar(
                        error: true,
                        onTapRetry: () async {
                          await _getBookableDays();
                        },
                      )
                    : (_customDuration && _durationUnit == 'month')
                        ? MonthsAvailableBooking(
                            months: _currentMonthsAvailable,
                            pickedTime: _pickedTime,
                            onTap: (picked) {
                              _pickedTime.value = picked;
                              widget.onChanged?.call({
                                ...?widget.appointment,
                                'wc_bookings_field_duration': _customDurationValue,
                                'wc_bookings_field_start_date_yearmonth':
                                    DateFormat('yyyy-MM').format(_pickedTime.value),
                                'type': WooBookingType.customMonth
                              });
                            },
                          )
                        : SizedBox(
                            height: 400,
                            child: Column(
                              children: [
                                ValueListenableBuilder<DateTime>(
                                  valueListenable: _focusedDay,
                                  builder: (context, value, _) {
                                    return CalendarHeader(
                                      focusedDay: value,
                                      onLeftArrowTap: _enableHeadingLeftArrow
                                          ? () async {
                                              endDate = DateTime(
                                                  (endDate.month == 1) ? (endDate.year - 1) : endDate.year,
                                                  (endDate.month == 1) ? (12) : endDate.month - 1);
                                              await _getBookableDays();
                                              await _getActiveData();
                                              _pageController.previousPage(
                                                duration: const Duration(milliseconds: 10),
                                                curve: Curves.easeOut,
                                              );
                                            }
                                          : null,
                                      onRightArrowTap: () async {
                                        endDate = DateTime((endDate.month == 12) ? (endDate.year + 1) : endDate.year,
                                            (endDate.month == 12) ? (1) : endDate.month + 1);
                                        await _getBookableDays();
                                        await _getActiveData();
                                        _pageController.nextPage(
                                          duration: const Duration(milliseconds: 10),
                                          curve: Curves.easeOut,
                                        );
                                      },
                                    );
                                  },
                                ),
                                TableCalendar(
                                  onCalendarCreated: (controller) => _pageController = controller,
                                  availableGestures: AvailableGestures.none,
                                  firstDay: nowBookingTime,
                                  lastDay: (nowBookingTime.add(const Duration(days: 3650))),
                                  focusedDay: _focusedDay.value,
                                  headerVisible: false,
                                  rangeStartDay: _startDateRange,
                                  rangeEndDay: _endDateRange,
                                  calendarStyle: CalendarStyle(
                                    outsideDaysVisible: false,
                                    defaultTextStyle: defaultTextCalendar,
                                    todayTextStyle: defaultTextCalendar.copyWith(color: Colors.red),
                                    disabledTextStyle: disableTextCalendar,
                                    selectedTextStyle: defaultTextCalendar.copyWith(color: theme.colorScheme.onPrimary),
                                    weekendTextStyle: defaultTextCalendar,
                                    todayDecoration: const BoxDecoration(),
                                    selectedDecoration:
                                        BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
                                    markerDecoration: BoxDecoration(
                                      color: theme.textTheme.bodySmall?.color,
                                      shape: BoxShape.circle,
                                    ),
                                    markersAnchor: 1.3,
                                  ),
                                  daysOfWeekHeight: 21,
                                  eventLoader: (day) {
                                    return [];
                                  },
                                  selectedDayPredicate: (day) {
                                    return isSameDay(_selectedDay, day);
                                  },
                                  rangeSelectionMode: RangeSelectionMode.toggledOn,
                                  onRangeSelected: _enableRangePicker
                                      ? (start, end, focusedDay) =>
                                          _onSelected(start, end, focusedDay, enable: 'onRange')
                                      : null,
                                  onDaySelected: !_enableRangePicker
                                      ? (selectedDay, focusedDay) => _onSelected(selectedDay, null, focusedDay)
                                      : null,
                                  onPageChanged: (focusedDay) {
                                    _focusedDay.value = focusedDay;
                                  },
                                  enabledDayPredicate: (date) {
                                    bool availabilityInit =
                                        availability.isEmpty && _resourceProduct.isNotEmpty && resourceId == null;
                                    return activeDayAppointment(
                                      day: date,
                                      bookableData: _bookableData,
                                      activeRecords: _activeRecords,
                                      defaultDateAvailable: _defaultDateAvailable,
                                      now: DateTime.now(),
                                      minDateUnit: _minDateUnit,
                                      minDateValue: _minDateValue,
                                      maxDateUnit: _maxDateUnit,
                                      maxDateValue: _maxDateValue,
                                      hasRestrictedDay: _hasRestrictedDays,
                                      restrictedDays: _restrictedDays,
                                      hasResources: resource(
                                        date: date,
                                        availability:
                                            availabilityInit ? _resourceProduct[0]['availability'] : availability,
                                        resourceIds: _resourceIds,
                                      )
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                : const DefaultCalendar(),
            // _________________________
            // Loading calendar.
            ValueListenableBuilder<bool>(
              valueListenable: _loadingCalendar,
              builder: (context, value, _) {
                return (value)
                    ? Container(
                        height: 400,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            )
            // _________________________
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Divider(thickness: 2, height: 2),
        ),
        (!_customDuration)
            // Time stamps.
            ? ValueListenableBuilder<bool>(
                valueListenable: _loadingTimeStamp,
                builder: (context, value, _) {
                  if (value) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }
                  return ValueListenableBuilder<DateTime>(
                      valueListenable: _pickedTime,
                      builder: (context, pickedTime, _) {
                        return ListTimeStamp(
                          timeStamps: _timeStamps,
                          pickedTime: pickedTime,
                          onPickTimeStamp: (time) {
                            if (time != null) {
                              _pickedTime.value = time;
                              widget.onChanged?.call({
                                ...?widget.appointment,
                                'date': DateFormat("yyyy-MM-dd").format(_pickedTime.value),
                                'time': DateFormat("HH:mm").format(_pickedTime.value),
                                'type': WooBookingType.defaultBooking,
                              });
                            }
                          },
                        );
                      });
                },
              )
            // __________________________
            // Custom duration.
            : Visibility(
                visible: !_enableRangePicker,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _loadingTimeStamp,
                  builder: (context, value, _) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: 130,
                          child: CustomDurationBooking(
                            timeStamps: _timeStamps,
                            maxDuration: _maxDuration,
                            minDuration: _minDuration,
                            defaultDateAvailable: _defaultDateAvailable,
                            duration: _duration,
                            durationUnit: _durationUnit,
                            // Enable for case: duration unit is minutes or hour.
                            onPickEndTime: (startDate, fieldDuration) {
                              widget.onChanged?.call({
                                ...?widget.appointment,
                                'date': (startDate != null) ? DateFormat("yyyy-MM-dd").format(startDate) : null,
                                'time': (startDate != null) ? DateFormat("HH:mm").format(startDate) : null,
                                'type': WooBookingType.customHourMinute,
                                'wc_bookings_field_duration': fieldDuration,
                              });
                            },
                            // Enable for case: duration unit is day or week or month.
                            onChangedCustomDuration: (value) {
                              _customDurationValue = value;
                              _onChangedCustomDurationValue();
                            },
                          ),
                        ),
                        if (value)
                          const SizedBox(
                            height: 100,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ),
        // __________________________
      ],
    );
  }
}
