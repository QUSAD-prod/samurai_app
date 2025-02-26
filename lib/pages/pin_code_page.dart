import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/storage.dart';

enum PinCodePageType { create, enter }

class PinCodePage extends StatefulWidget {
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  String pinCode = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              'assets/background_gradient.svg',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35 / 390 * width),
            child: Column(
              children: [
                const Spacer(flex: 3),
                SizedBox(
                  width: 320 / 390 * width,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      ModalRoute.of(context)!.settings.arguments == PinCodePageType.create ? "create the code" : "enter the code",
                      style: const TextStyle(
                        fontFamily: 'AmazObitaemOstrovItalic',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                getIndicator(width, height),
                const Spacer(flex: 2),
                getKeyboard(width, height),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getIndicator(double width, double height) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getDot(0, width),
        getDot(1, width),
        getDot(2, width),
        getDot(3, width),
      ],
    );
  }

  Widget getDot(int id, double width) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5 / 390 * width,
      ),
      width: 30 / 390 * width,
      height: 35 / 390 * width,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/pin_indicator_1.svg',
              fit: BoxFit.fitWidth,
              width: 12 / 390 * width,
              color: pinCode.length > id ? const Color(0xFF00FFFF) : Colors.white,
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/pin_indicator_2.svg',
              fit: BoxFit.fitWidth,
              width: 30 / 390 * width,
              color: pinCode.length == id ? const Color(0xFF00FFFF) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget getKeyboard(double width, double height) {
    return Column(
      children: [
        Row(
          children: [
            getButton(
              width,
              height,
              '1',
            ),
            getButton(
              width,
              height,
              '2',
            ),
            getButton(
              width,
              height,
              '3',
            ),
          ],
        ),
        Row(
          children: [
            getButton(
              width,
              height,
              '4',
            ),
            getButton(
              width,
              height,
              '5',
            ),
            getButton(
              width,
              height,
              '6',
            ),
          ],
        ),
        Row(
          children: [
            getButton(
              width,
              height,
              '7',
            ),
            getButton(
              width,
              height,
              '8',
            ),
            getButton(
              width,
              height,
              '9',
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: ModalRoute.of(context)!.settings.arguments == PinCodePageType.enter ? () => Navigator.of(context).pop() : null,
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 40 / 844 * height * 1.2,
                    child: Center(
                      child: Text(
                        ModalRoute.of(context)!.settings.arguments == PinCodePageType.create ? '' : 'Cancel',
                        style: GoogleFonts.spaceMono(
                          fontSize: 14 / 844 * height,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FFFF).withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            getButton(
              width,
              height,
              '0',
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (pinCode.isNotEmpty) {
                    setState(
                      () {
                        pinCode = pinCode.substring(0, pinCode.length - 1);
                      },
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 40 / 844 * height * 1.2,
                    child: Center(
                      child: SizedBox(
                        height: 20 / 844 * height,
                        width: 40 / 844 * height,
                        child: SvgPicture.asset(
                          'assets/keyboard_symb.svg',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getButton(double width, double height, String id) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (pinCode.length < 4) {
            setState(
              () {
                pinCode += id;
              },
            );
            if (ModalRoute.of(context)!.settings.arguments == PinCodePageType.enter && pinCode.length == 4) {
              String? validCode = AppStorage().read('pin');
              if (pinCode == validCode!) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                  arguments: 'wallet',
                );
              } else {
                setState(
                  () {
                    pinCode = '';
                  },
                );
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid code"),
                    duration: Duration(milliseconds: 3000),
                  ),
                );
              }
            } else if (ModalRoute.of(context)!.settings.arguments == PinCodePageType.create && pinCode.length == 4) {
              AppStorage().write('pin', pinCode).then(
                    (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                      arguments: 'wallet',
                    ),
                  );
            }
          }
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            id,
            style: TextStyle(
              fontFamily: 'AmazObitaemOstrovItalic',
              fontSize: 40 / 844 * height,
              color: const Color(0xFF00FFFF),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
