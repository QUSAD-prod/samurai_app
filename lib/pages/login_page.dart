import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/samurai_text_field.dart';
import 'package:samurai_app/components/storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Timer _timer;
  int? timerValue;
  bool isAgree = false;
  String email = '';
  String code = '';

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void login() async {
    if (email.isNotEmpty && isAgree) {
      try {
        var data = await Rest.checkCode(email, code);
        await AppStorage().write('jwt', data['jwt']);

        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF020A38),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(0.0, -MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              width: width,
              height: height * 0.8,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.asset(
                  'assets/pages/start/background.png',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: getTopPadding(
                        height * 0.35,
                        MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/pages/start/logo.svg',
                            height: height * 0.12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: SvgPicture.asset(
                              'assets/pages/start/logo_text.svg',
                              height: height * 0.075,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: SamuraiTextField(
                      screeenHeight: height,
                      screeenWidth: width,
                      hint: "Email address",
                      onChanged: (value) => setState(
                        () {
                          email = value;
                        },
                      ),
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
                      keyboardType: TextInputType.number,
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
                            if (!mounted) {
                              timer.cancel();
                            }
                            setState(
                              () {
                                timerValue = timerValue! - 1;
                                if (timerValue == 0) {
                                  setState(() {
                                    timerValue = null;
                                    timer.cancel();
                                  });
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Container(
                          width: height * 0.03,
                          height: height * 0.03,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF00FFFF)),
                          ),
                          child: Checkbox(
                            value: isAgree,
                            onChanged: (value) => setState(
                              () => isAgree = !isAgree,
                            ),
                            fillColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            checkColor: const Color(0xFF00FFFF),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        Text(
                          "  I agree",
                          style: GoogleFonts.spaceMono(
                            fontSize: height * 0.015,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: InkWell(
                            onTap: () => {},
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Terms of Use", //TODO
                                style: GoogleFonts.spaceMono(
                                  fontSize: height * 0.015,
                                  height: 1.5,
                                  color: const Color(0xFF00FFFF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "&",
                          style: GoogleFonts.spaceMono(
                            fontSize: height * 0.015,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: InkWell(
                            onTap: () => {}, //TODO
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Privacy Policy",
                                style: GoogleFonts.spaceMono(
                                  fontSize: height * 0.015,
                                  height: 1.5,
                                  color: const Color(0xFF00FFFF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 28),
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: login,
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
                                "login/sign up",
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTopPadding(double height, double keyboard) {
    if (height - keyboard < 28) {
      return 28;
    } else {
      return height - keyboard;
    }
  }
}
