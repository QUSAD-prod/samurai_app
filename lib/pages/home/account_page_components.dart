import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/rest.dart';
import '../../components/samurai_text_field.dart';

class AccountPageComponents {
  static void openChangeEmailModalPage({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    Timer _timer;
    int? timerValue;
    bool isAgree = false;
    String email = '';
    String code = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
          width: width,
          height: height * 0.7,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SizedBox(
                  width: width,
                  height: height * 0.7,
                  child: SvgPicture.asset(
                    'assets/modal_bottom_sheet_bg.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              InkWell(
                overlayColor: MaterialStateProperty.all(
                  Colors.transparent,
                ),
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: SvgPicture.asset(
                              'assets/back_button.svg',
                              height: width * 0.12,
                              width: width * 0.12,
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.1,
                                ),
                                child: Center(
                                  child: Text(
                                    'change',
                                    style: TextStyle(
                                      fontFamily: 'AmazObitaemOstrovItalic',
                                      fontSize: 37 / 844 * height,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.12,
                            width: width * 0.12,
                          ),
                        ],
                      ),
                      MediaQuery.of(context).viewInsets.bottom == 0 ? const Spacer(flex: 28) : Container(),
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? Text(
                              "ENTER NEW E-MAIL",
                              style: GoogleFonts.spaceMono(
                                fontSize: 16 / 844 * height,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      Spacer(flex: MediaQuery.of(context).viewInsets.bottom == 0 ? 28 : 10),
                      SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: "Email address",
                        onChanged: (value) => setState(
                          () {
                            email = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SamuraiTextField(
                          screeenHeight: height,
                          screeenWidth: width,
                          hint: "Email verification code",
                          onChanged: (value) => setState(
                            () {
                              code = value;
                            },
                          ),
                          buttonWithTimerEnabled: true,
                          timerValue: timerValue,
                          onTapTimerButton: () {
                            Rest.sendCode(email);
                            setState(
                              () {
                                timerValue = 60;
                              },
                            );
                            _timer = Timer.periodic(
                              const Duration(seconds: 1),
                              (timer) {
                                setState(
                                  () {
                                    timerValue = timerValue! - 1;
                                    if (timerValue == 0) {
                                      setState(
                                        () {
                                          timerValue = null;
                                          timer.cancel();
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const Spacer(flex: 10),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom / 2,
                      ),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () {},
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
                                  "confirm",
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
