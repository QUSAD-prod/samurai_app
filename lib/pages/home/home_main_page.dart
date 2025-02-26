import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({
    super.key,
    required this.watchSamurai,
  });

  final Function() watchSamurai;

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  late FixedExtentScrollController daysController;
  late FixedExtentScrollController hoursController;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    daysController = FixedExtentScrollController(initialItem: 58);
    hoursController = FixedExtentScrollController(initialItem: 21);

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RawScrollbar(
        radius: const Radius.circular(36),
        thumbColor: const Color(0xFF00FFFF),
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50 / 844 * height),
                Text(
                  "battles will\nstart in",
                  style: TextStyle(
                    fontSize: 44 / 844 * height,
                    fontFamily: 'AmazObitaemOstrovItalic',
                    color: Colors.white,
                    height: 0.9,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50 / 844 * height),
                SizedBox(
                  height: 166 / 354 * (width - width * 0.14),
                  width: width - width * 0.14,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 20 / 354 * (width - width * 0.14),
                        ),
                        height: 100 / 354 * (width - width * 0.14),
                        child: Row(
                          children: [
                            const Spacer(
                              flex: 20,
                            ),
                            Expanded(
                              flex: 130,
                              child: WheelChooser.integer(
                                controller: daysController,
                                onValueChanged: (i) => debugPrint(i.toString()),
                                maxValue: 100,
                                minValue: 1,
                                isInfinite: true,
                                selectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                unSelectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.15),
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                itemSize: 60 / 354 * (width - width * 0.14),
                                listHeight: 120 / 354 * (width - width * 0.14),
                              ),
                            ),
                            const Spacer(
                              flex: 52,
                            ),
                            Expanded(
                              flex: 130,
                              child: WheelChooser.integer(
                                controller: hoursController,
                                onValueChanged: (i) => debugPrint(i.toString()),
                                maxValue: 24,
                                minValue: 1,
                                isInfinite: true,
                                selectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                unSelectTextStyle: GoogleFonts.spaceMono(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.15),
                                  fontSize: 30 / 354 * (width - width * 0.14),
                                ),
                                itemSize: 60 / 354 * (width - width * 0.14),
                                listHeight: 120 / 354 * (width - width * 0.14),
                              ),
                            ),
                            const Spacer(
                              flex: 20,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/pages/homepage/clock_border.svg',
                        height: 166 / 354 * (width - width * 0.14),
                        width: width - width * 0.14,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25 / 844 * height),
                InkWell(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  onTap: () => {}, //TODO AR
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/transparent_button.svg',
                        width: width - width * 0.14,
                        height: (width - width * 0.14) * 0.32,
                      ),
                      SizedBox(
                        width: width - width * 0.14,
                        height: (width - width * 0.14) * 0.32,
                        child: Center(
                          child: Text(
                            "ar masks",
                            style: TextStyle(
                              fontFamily: 'AmazObitaemOstrovItalic',
                              fontSize: height * 0.025,
                              color: const Color(0xFF00FFFF),
                              height: 0.98,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8 / 844 * height),
                InkWell(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  onTap: widget.watchSamurai,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/login_button.svg',
                        width: width - width * 0.14,
                        height: (width - width * 0.14) * 0.32,
                      ),
                      SizedBox(
                        width: width - width * 0.14,
                        height: (width - width * 0.14) * 0.32,
                        child: Center(
                          child: Text(
                            "watch samurai",
                            style: TextStyle(
                              fontFamily: 'AmazObitaemOstrovItalic',
                              fontSize: height * 0.025,
                              color: const Color(0xFF0D1238),
                              height: 0.98,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50 / 844 * height),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
