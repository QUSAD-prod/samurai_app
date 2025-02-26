import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/storage.dart';

import '../../api/rest.dart';
import '../../components/samurai_text_field.dart';

class CraftPageComponents {
  static void openTransferModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required String samuraiType,
  }) {
    String mode = 'toFree';
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
          width: width,
          height: height * 0.65,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SizedBox(
                  width: width,
                  height: height * 0.65,
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
                            child: Center(
                              child: Text(
                                'transfer',
                                style: TextStyle(
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  fontSize: 37 / 844 * height,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {}, //TODO go to info
                            child: SvgPicture.asset(
                              'assets/pages/homepage/craft/info.svg',
                              height: width * 0.12,
                              width: width * 0.12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 30),
                      Expanded(
                        flex: 146,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/swap_border.svg',
                              fit: BoxFit.fitWidth,
                              width: width - 46,
                            ),
                            Row(
                              children: [
                                const Spacer(flex: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(flex: 30),
                                    Expanded(
                                      flex: 20,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          mode == 'toArmy' ? 'FREE' : 'ARMY',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(flex: 35),
                                    Expanded(
                                      flex: 20,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          mode == 'toArmy' ? 'ARMY' : 'FREE',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(flex: 28),
                                  ],
                                ),
                                const Spacer(flex: 24),
                                Expanded(
                                  flex: 15,
                                  child: InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    onTap: () => setState(
                                      () {
                                        mode == 'toArmy' ? mode = 'toFree' : mode = 'toArmy';
                                      },
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/swap_change_bt.svg',
                                      fit: BoxFit.fitWidth,
                                      height: height * 0.1,
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 6),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 38),
                      SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: 'Ammount',
                        keyboardType: TextInputType.number,
                        controller: controller,
                      ),
                      const Spacer(flex: 11),
                      Row(
                        children: [
                          Text(
                            "Available: 214 ${mode == 'toArmy' ? 'Free' : 'Army'} Samurai", //TODO value
                            style: GoogleFonts.spaceMono(
                              fontSize: 13 / 844 * height,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(flex: 10),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () async {
                          if (mode == 'toArmy') {
                            await Rest.transferSamuraiToArmy(
                              int.parse(controller.text),
                              samuraiType,
                            );
                          } else if (mode == 'toFree') {
                            await Rest.transferSamuraiToFree(
                              int.parse(controller.text),
                              samuraiType,
                            );
                          }
                        },
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

  static void openHealModalPage({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
          width: width,
          height: height * 0.55,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SizedBox(
                  width: width,
                  height: height * 0.55,
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
                            child: Center(
                              child: Text(
                                'heal',
                                style: TextStyle(
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  fontSize: 37 / 844 * height,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {}, //TODO go to info
                            child: SvgPicture.asset(
                              'assets/pages/homepage/craft/info.svg',
                              height: width * 0.12,
                              width: width * 0.12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 23),
                      Expanded(
                        flex: 67,
                        child: SvgPicture.asset(
                          'assets/heart.svg',
                          width: width * 0.5,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const Spacer(flex: 12),
                      Text(
                        "HEALTH: 91%",
                        style: GoogleFonts.spaceMono(
                          fontSize: 13 / 844 * height,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FFFF),
                        ),
                      ), //TODO value
                      const Spacer(flex: 21),
                      Text(
                        "CURE ALL THE SAMURAI IN\nTHE ARMY?",
                        style: GoogleFonts.spaceMono(
                          fontSize: 16 / 844 * height,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 12),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () {}, //TODO
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
                                  "treat for 70 RYO",
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

  static void openToWalletModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required String samuraiType,
  }) {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
          width: width,
          height: height * 0.65,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SizedBox(
                  width: width,
                  height: height * 0.65,
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
                            child: Center(
                              child: Text(
                                'to wallet',
                                style: TextStyle(
                                  fontFamily: 'AmazObitaemOstrovItalic',
                                  fontSize: 37 / 844 * height,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {}, //TODO go to info
                            child: SvgPicture.asset(
                              'assets/pages/homepage/craft/info.svg',
                              height: width * 0.12,
                              width: width * 0.12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 28),
                      Expanded(
                        flex: 85,
                        child: SvgPicture.asset(
                          'assets/nft_polygon.svg',
                          width: width * 0.4,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const Spacer(flex: 28),
                      Text(
                        "THROW THE FREE SAMURAI\nINTO THE PURSE STRINGS?",
                        style: GoogleFonts.spaceMono(
                          fontSize: 16 / 844 * height,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 28),
                      SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: 'Quanity',
                        keyboardType: TextInputType.number,
                        controller: controller,
                      ),
                      const Spacer(flex: 15),
                      Row(
                        children: [
                          Text(
                            "Available: 1075 SAMURAI", //TODO value
                            style: GoogleFonts.spaceMono(
                              fontSize: 13 / 844 * height,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "GAS: 0,017 MATIC", //TODO value
                            style: GoogleFonts.spaceMono(
                              fontSize: 13 / 844 * height,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 10),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () async {
                          await Rest.transfer(
                            double.parse(controller.text),
                            samuraiType,
                            AppStorage().read('wallet_adress') as String,
                          );
                        },
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
                                  "send samurai",
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
