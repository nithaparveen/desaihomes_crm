import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeadChartCard extends StatelessWidget {
  const LeadChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> leadCounts = [
      2600, 2800, 3000, 3200, 2400, 2300, 2500, 
      2600, 2800, 3000, 3200, 3100, 3300, 3400, 
      3500, 3400, 3000, 3200, 2400, 2300
    ];

    final List<DateTime> dates = [
      DateTime(2024, 12, 1), DateTime(2024, 12, 2), DateTime(2024, 12, 3),
      DateTime(2024, 12, 4), DateTime(2024, 12, 5), DateTime(2024, 12, 6),
      DateTime(2024, 12, 7), DateTime(2024, 12, 8), DateTime(2024, 12, 9),
      DateTime(2024, 12, 10), DateTime(2024, 12, 11), DateTime(2024, 12, 12),
      DateTime(2024, 12, 13), DateTime(2024, 12, 14), DateTime(2024, 12, 15),
      DateTime(2024, 12, 16), DateTime(2024, 12, 17), DateTime(2024, 12, 18),
      DateTime(2024, 12, 19), DateTime(2024, 12, 20)
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD5D7DA), width: 1.0),
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 13.w, top: 13.h, bottom: 13.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Leads",
                    style: GLTextStyles.interStyle(
                      size: 13.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff181D27),
                    )),
                SizedBox(height: 8.h),
                Text("2,420",
                    style: GLTextStyles.interStyle(
                      size: 19.6.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff181D27),
                    )),
              ],
            ),
            SizedBox(width: 30.w),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Color(0xff030229),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        Text("29",
                            style: GLTextStyles.interStyle(
                                size: 8.6.sp,
                                weight: FontWeight.w700,
                                color: Colors.white)),
                        SizedBox(height: 4.h),
                        Text("Leads on 21/02/2023",
                            style: GLTextStyles.interStyle(
                                size: 6.sp,
                                weight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(12.71, 7.53),
                        painter: PolygonPainter(flipVertical: true),
                      ),
                      Positioned(
                        top: 7.53, 
                        child: VerticalDottedLine(
                          height: 115.h,
                          color:  ColorTheme.grey,
                          strokeWidth: .45,
                          dashHeight: 4.0,
                          dashSpace: 2.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 100.h,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: leadCounts
                                .asMap()
                                .map((index, leadCount) => MapEntry(
                                    index,
                                    FlSpot(index.toDouble(),
                                        leadCount.toDouble())))
                                .values
                                .toList(),
                            isCurved: true,
                            color: const Color(0xFF8710FF),
                            barWidth: 2,
                            belowBarData: BarAreaData(show: false),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (touchedSpot) =>
                                Colors.transparent,
                            tooltipBorder: BorderSide.none,
                          ),
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? touchResponse) {
                            if (touchResponse != null &&
                                touchResponse.lineBarSpots != null &&
                                touchResponse.lineBarSpots!.isNotEmpty) {
                              final spot = touchResponse.lineBarSpots![0];
                              final index = spot.x.toInt();
                              final date = dates[index];
                              final leadCount = leadCounts[index];
                            }
                          },
                          handleBuiltInTouches: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalDottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashHeight;
  final double dashSpace;

  const VerticalDottedLine({
    Key? key,
    this.height = 100.0,
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dashHeight = 5.0,
    this.dashSpace = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VerticalDottedLinePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashHeight: dashHeight,
        dashSpace: dashSpace,
      ),
      child: SizedBox(
        height: height,
        width: strokeWidth,
      ),
    );
  }
}

class _VerticalDottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashHeight;
  final double dashSpace;

  _VerticalDottedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashHeight,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PolygonPainter extends CustomPainter {
  final bool flipVertical;

  PolygonPainter({this.flipVertical = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xff030229)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver;

    final Path path = Path();
    path.moveTo(size.width / 2, 0); 
    path.lineTo(size.width, size.height); 
    path.lineTo(0, size.height); 
    path.close(); 

    if (flipVertical) {
      canvas.translate(0, size.height);
      canvas.scale(1.0, -1.0);
    }

    canvas.drawPath(path, paint);

    if (flipVertical) {
      canvas.translate(0, -size.height);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}