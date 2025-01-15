import 'package:call_e_log/call_log.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';

class CallLogList extends StatefulWidget {
  const CallLogList({super.key, required this.number});
  final String number;

  @override
  State<CallLogList> createState() => _CallLogListState();
}

class _CallLogListState extends State<CallLogList> {
  List<CallLogEntry> filteredCallLogs = [];

  @override
  void initState() {
    super.initState();
    fetchFilteredCallLogs();
  }

Future<void> fetchFilteredCallLogs() async {
  final permissionStatus = await Permission.phone.request();
  if (permissionStatus.isGranted) {
    try {
      final Iterable<CallLogEntry> callLogs = await CallLog.get();
      final List<CallLogEntry> filteredLogs = callLogs
          .where((log) =>
              log.number != null && log.number!.contains(widget.number))
          .toList();

      setState(() {
        filteredCallLogs = filteredLogs;
      });
    } catch (e) {
      debugPrint('Error fetching call logs: $e');
      setState(() {
        filteredCallLogs = [];
      });
    }
  } else {
    debugPrint('Phone permission denied');
    setState(() {
      filteredCallLogs = [];
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final Map<String, List<CallLogEntry>> logsByDate = {};

    for (var log in filteredCallLogs) {
      final logDate = formatDate(log.timestamp);
      if (!logsByDate.containsKey(logDate)) {
        logsByDate[logDate] = [];
      }
      logsByDate[logDate]!.add(log);
    }

    if (logsByDate.isEmpty) {
      return Center(
          child: Text(
        "No Call Log",
        style: GLTextStyles.manropeStyle(
          size: 15.sp,
          weight: FontWeight.w400,
          color: const Color(0xff414651),
        ),
      ));
    }

    final sortedDates = logsByDate.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;
        return b.compareTo(a);
      });

    return Expanded(
      child: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, dateIndex) {
          final date = sortedDates[dateIndex];
          final logsForDate = logsByDate[date]!;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GLTextStyles.interStyle(
                    size: 14.sp,
                    weight: FontWeight.w500,
                    color: const Color(0xff414651),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xfff5f5f5),
                  ),
                  child: Column(
                    children: logsForDate.map((callLog) {
                      final index = logsForDate.indexOf(callLog);
                      return Column(
                        children: [
                          CallLogItem(
                            name: callLog.name ?? ' ',
                            number: callLog.number ?? '',
                            time: formatTime(callLog.timestamp),
                            duration: formatDuration(callLog.duration ?? 0),
                            type: getCallType(callLog.callType),
                            date: date,
                          ),
                          if (index < logsForDate.length - 1)
                            const Divider(
                              color: Color(0xffEAE2E2),
                              height: 1,
                              indent: 60,
                              endIndent: 15,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String getCallType(CallType? callType) {
    switch (callType) {
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.incoming:
        return 'Incoming';
      case CallType.missed:
        return 'Missed';
      case CallType.rejected:
        return 'Rejected';
      case CallType.blocked:
        return 'Blocked';
      case CallType.voiceMail:
        return 'Voicemail';
      case CallType.wifiIncoming:
        return 'Wifi Incoming';
      case CallType.wifiOutgoing:
        return 'Wifi Outgoing';
      case null:
      default:
        return 'Unknown';
    }
  }

  String formatTime(int? timestamp) {
    if (timestamp == null) return ' ';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final hour = date.hour;
    final minute = date.minute;

    final isAM = hour < 12;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    final formattedTime =
        '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${isAM ? 'am' : 'pm'}';

    return formattedTime;
  }

  String formatDate(int? timestamp) {
    if (timestamp == null) return ' ';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (isSameDay(date, today)) {
      return 'Today';
    } else if (isSameDay(date, yesterday)) {
      return 'Yesterday';
    } else {
      return '${getDayName(date)}, ${date.day} ${getMonthName(date)}';
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getDayName(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[date.weekday - 1];
  }

  String getMonthName(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[date.month - 1];
  }

  String formatDuration(int durationInSeconds) {
    if (durationInSeconds == 0) return '0secs';
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return '${minutes}m ${seconds}secs';
  }
}

class CallLogItem extends StatelessWidget {
  final String name;
  final String number;
  final String time;
  final String duration;
  final String type;
  final String date;

  const CallLogItem({
    super.key,
    required this.name,
    required this.number,
    required this.time,
    required this.duration,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Row(
        children: [
          getCallTypeIcon(type),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GLTextStyles.manropeStyle(
                    size: 14.sp,
                    weight: FontWeight.w500,
                    color: const Color(0xff1F2A37),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$type, $duration',
                  style: GLTextStyles.manropeStyle(
                    size: 12.sp,
                    weight: FontWeight.w500,
                    color: const Color.fromARGB(240, 99, 99, 107),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Icon getCallTypeIcon(String type) {
    switch (type) {
      case 'Outgoing':
        return Icon(
          Iconsax.call_outgoing,
          color: const Color.fromARGB(255, 67, 116, 140),
          size: 24.sp,
        );
      case 'Incoming':
        return Icon(
          Iconsax.call_incoming,
          color: Colors.green,
          size: 24.sp,
        );
      case 'Missed':
        return Icon(
          Iconsax.call_received,
          color: Colors.red,
          size: 24.sp,
        );
      case 'Rejected':
        return Icon(
          Iconsax.call_remove,
          color: Colors.orange,
          size: 24.sp,
        );
      case 'Blocked':
        return Icon(
          Iconsax.slash,
          color: Colors.grey,
          size: 24.sp,
        );
      case 'Voicemail':
        return const Icon(
          Iconsax.volume_low,
          color: Colors.purple,
          size: 24.0,
        );
      case 'Wifi Incoming':
        return Icon(
          Iconsax.call_incoming,
          color: Colors.green,
          size: 24.sp,
        );
      case 'Wifi Outgoing':
        return Icon(
          Iconsax.call_outgoing,
          color: const Color.fromARGB(255, 67, 116, 140),
          size: 24.sp,
        );
      default:
        return Icon(
          Iconsax.call,
          color: Colors.grey,
          size: 24.sp,
        );
    }
  }
}
