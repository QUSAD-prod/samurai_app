import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterSeedPage extends StatefulWidget {
  const EnterSeedPage({super.key});

  @override
  State<EnterSeedPage> createState() => _EnterSeedPageState();
}

class _EnterSeedPageState extends State<EnterSeedPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: SvgPicture.asset(
              'assets/modal_bottom_sheet_bg.svg',
              fit: BoxFit.fill,
            ),
          ),
          InkWell(
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
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
                          child: Center(
                            child: Text(
                              'enter seed',
                              style: TextStyle(
                                fontFamily: 'AmazObitaemOstrovItalic',
                                fontSize: 37 / 844 * height,
                                color: Colors.white,
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
                    Text(
                      'phrase',
                      style: TextStyle(
                        fontFamily: 'AmazObitaemOstrovItalic',
                        fontSize: 37 / 844 * height,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24 / 844 * height),
                    Text(
                      "Whrite down your Seed Phrase\nseparated by a space without commas",
                      style: GoogleFonts.spaceMono(
                        fontSize: 13 / 844 * height,
                        fontWeight: FontWeight.w400,
                        height: 15 / 13,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24 / 844 * height),
                    SizedBox(
                      width: width - 56,
                      height: 206 / 340 * (width - 56),
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/enter_seed_border.svg',
                            width: width - 56,
                            height: 206 / 340 * (width - 56),
                            fit: BoxFit.fill,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 37 / 390 * width,
                              vertical: 19 / 844 * height,
                            ),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              decoration: InputDecoration.collapsed(
                                hintText: "Your seed phrase",
                                hintStyle: GoogleFonts.spaceMono(
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              style: GoogleFonts.spaceMono(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.white,
                              ),
                              cursorColor: const Color(0xFF00FFFF),
                              cursorRadius: const Radius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24 / 844 * height),
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => {},
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
          ),
        ],
      ),
    );
  }
}
