import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String? labelText;
  final Function(DateTime)? onDateSelected;
  final TextEditingController? controller;

  const CustomDatePicker({
    super.key,
    this.labelText,
    this.onDateSelected,
    this.controller,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late TextEditingController _dateController;
  DateTime _currentDate = DateTime.now();

  final List<String> _dayHeaders = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];

  @override
  void initState() {
    super.initState();
    _dateController = widget.controller ?? TextEditingController();
  }

  void _selectDate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 8.h,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 400.w,
                height: 380.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Iconsax.arrow_circle_left, size: 20.sp),
                            onPressed: () {
                              setState(() {
                                _currentDate = DateTime(
                                    _currentDate.year, _currentDate.month - 1);
                              });
                            },
                          ),
                          Text(DateFormat('MMMM yyyy').format(_currentDate),
                              style: GLTextStyles.manropeStyle(
                                  size: 16.sp, weight: FontWeight.w400)),
                          IconButton(
                            icon: Icon(Iconsax.arrow_circle_right, size: 20.sp),
                            onPressed: () {
                              setState(() {
                                _currentDate = DateTime(
                                    _currentDate.year, _currentDate.month + 1);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: _dayHeaders
                            .map((day) => Expanded(
                                  child: Center(
                                    child: Text(
                                      day.toUpperCase(),
                                      style: GLTextStyles.manropeStyle(
                                          size: 12.sp,
                                          weight: FontWeight.w500,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _getDaysInMonth(
                              _currentDate.year, _currentDate.month) +
                          _getFirstDayOfMonth(_currentDate),
                      itemBuilder: (context, index) {
                        if (index < _getFirstDayOfMonth(_currentDate)) {
                          return const SizedBox();
                        }

                        int day = index - _getFirstDayOfMonth(_currentDate) + 1;
                        DateTime dateTime = DateTime(
                            _currentDate.year, _currentDate.month, day);

                        return InkWell(
                          onTap: () {
                            _dateController.text =
                                DateFormat('dd-MM-yyyy').format(dateTime);

                            widget.onDateSelected?.call(dateTime);
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                  color: _isToday(dateTime)
                                      ? ColorTheme.desaiGreen
                                      : Colors.black,
                                  fontWeight: _isToday(dateTime)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 16.sp),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday - 1;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      readOnly: true,
      style: GLTextStyles.manropeStyle(
        weight: FontWeight.w400,
        size: 15.sp,
        color: const Color.fromARGB(255, 87, 87, 87),
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(Iconsax.calendar_1, size: 20.sp),
          onPressed: () => _selectDate(context),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffD5D7DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffD5D7DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _dateController.dispose();
    }
    super.dispose();
  }
}
