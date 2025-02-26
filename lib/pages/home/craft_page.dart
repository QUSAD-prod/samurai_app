import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:samurai_app/pages/home/craft_page_components.dart';

import '../../api/rest.dart';

class CraftPage extends StatefulWidget {
  const CraftPage({
    super.key,
    required this.craftSwitch,
  });

  final int craftSwitch;

  @override
  State<CraftPage> createState() => _CraftPageState();
}

class _CraftPageState extends State<CraftPage> {
  late final ScrollController scrollController;

  late Map<String, dynamic> info;

  int? fireSamuraiBalance;
  int? lockedFireSamuraiBalance;
  int? fireSamuraiXp;
  int? waterSamuraiBalance;
  int? lockedWaterSamuraiBalance;
  int? waterSamuraiXp;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    getSamuraiInfo().then(
      (value) => setState(
        () {
          info = value;
          fireSamuraiBalance = info['fire_samurai_balance'];
          lockedFireSamuraiBalance = info['locked_fire_samurai_balance'];
          fireSamuraiXp = info['fire_samurai_xp'];
          waterSamuraiBalance = info['water_samurai_balance'];
          lockedWaterSamuraiBalance = info['locked_water_samurai_balance'];
          waterSamuraiXp = info['water_samurai_xp'];
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<Map<String, dynamic>> getSamuraiInfo() async {
    return await Rest.getInfoSamurai();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      valueListenable: Hive.box('prefs').listenable(),
      builder: (context, box, widget) {
        return RawScrollbar(
          radius: const Radius.circular(36),
          thumbColor: const Color(0xFF00FFFF),
          thumbVisibility: true,
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Stack(
                    children: [
                      getBackgroundBorder(width),
                      Row(
                        children: [
                          getCharacter(width),
                          getStats(width, height),
                          const Spacer(
                            flex: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  getLoader(height, width),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: getCraftButton(width, height),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getStats(double width, double height) {
    return Expanded(
      flex: 202,
      child: SizedBox(
        height: 280 / 340 * width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(
              flex: 52,
            ),
            Expanded(
              flex: 176,
              child: Row(
                children: [
                  const Spacer(
                    flex: 15,
                  ),
                  Expanded(
                    flex: 180,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 60,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Spacer(
                                      flex: 8,
                                    ),
                                    Expanded(
                                      flex: 15,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          'HEAL',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00FFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "HEALTH: ",
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00FFFF),
                                          ),
                                        ),
                                        Text(
                                          "100%", //TODO VALUE
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(
                                      flex: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(
                                flex: 16,
                              ),
                              Expanded(
                                flex: 50,
                                child: InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  onTap: () => CraftPageComponents.openHealModalPage(
                                    context: context,
                                    width: width,
                                    height: height,
                                  ),
                                  child: SvgPicture.asset(
                                    widget.craftSwitch == 0
                                        ? 'assets/pages/homepage/craft/heart_water.svg'
                                        : 'assets/pages/homepage/craft/heart_fire.svg',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 50,
                        ),
                        Expanded(
                          flex: 60,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 15,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          'TRANSFER TROOPS',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00FFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 10,
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ARMY: ",
                                            style: GoogleFonts.spaceMono(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF00FFFF),
                                            ),
                                          ),
                                          Text(
                                            (widget.craftSwitch == 0 ? lockedWaterSamuraiBalance ?? 0 : lockedFireSamuraiBalance ?? 0).toString(),
                                            style: GoogleFonts.spaceMono(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 10,
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Row(
                                        children: [
                                          Text(
                                            "FREE: ",
                                            style: GoogleFonts.spaceMono(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF00FFFF),
                                            ),
                                          ),
                                          Text(
                                            (widget.craftSwitch == 0 ? waterSamuraiBalance ?? 0 : fireSamuraiBalance ?? 0).toString(),
                                            style: GoogleFonts.spaceMono(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(
                                flex: 24,
                              ),
                              Expanded(
                                flex: 55,
                                child: InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  onTap: () => CraftPageComponents.openTransferModalPage(
                                    context: context,
                                    width: width,
                                    height: height,
                                    samuraiType: widget.craftSwitch == 0 ? "WATER_SAMURAI_MATIC" : "FIRE_SAMURAI_MATIC",
                                  ),
                                  child: SvgPicture.asset(
                                    widget.craftSwitch == 0
                                        ? 'assets/pages/homepage/craft/change_water.svg'
                                        : 'assets/pages/homepage/craft/change_fire.svg',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 12,
            ),
            Expanded(
              flex: 46,
              child: getSendButton(width, height),
            ),
            const Spacer(
              flex: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCharacter(double width) {
    return SizedBox(
      height: 265 / 340 * width,
      width: (138 / 312) * (265 / 340 * width),
      child: Image.asset(
        widget.craftSwitch == 0 ? 'assets/pages/homepage/samurai/water_samurai.png' : 'assets/pages/homepage/samurai/fire_samurai.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget getSendButton(double width, double height) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      onTap: () => CraftPageComponents.openToWalletModalPage(
        context: context,
        width: width,
        height: height,
        samuraiType: widget.craftSwitch == 0 ? "WATER_SAMURAI_MATIC" : "FIRE_SAMURAI_MATIC",
      ),
      child: SvgPicture.asset(
        'assets/pages/homepage/craft/send_bt.svg',
      ),
    );
  }

  Widget getBackgroundBorder(double width) {
    return Container(
      margin: EdgeInsets.only(top: 22 / 340 * width),
      width: width - width * 0.14,
      height: 243 / 340 * width,
      padding: EdgeInsets.only(
        left: 50 / 390 * width,
      ),
      child: SvgPicture.asset(
        'assets/pages/homepage/craft/border.svg',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getLoader(double height, double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 32 / 844 * height),
          child: Row(
            children: [
              Text(
                "XP: ",
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00FFFF),
                  fontSize: 14 / 844 * height,
                ),
              ),
              Text(
                getDaylyXp(),
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              ),
              const Spacer(),
              Text(
                "XP EARNED: ",
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00FFFF),
                  fontSize: 14 / 844 * height,
                ),
              ),
              Text(
                (widget.craftSwitch == 0 ? waterSamuraiXp ?? 0 : fireSamuraiXp ?? 0).toString(),
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 14 / 844 * height),
          width: width - width * 0.14,
          height: 15.75 / 335 * (width - width * 0.14),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Stack(
              children: [
                SvgPicture.asset(
                  widget.craftSwitch == 0 ? 'assets/pages/homepage/craft/loader_water.svg' : 'assets/pages/homepage/craft/loader_fire.svg',
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  width: width - width * 0.14,
                  height: 15 / 335 * (width - width * 0.14),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: getXp(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.craftSwitch == 0 ? const Color(0xFF00FFFF) : const Color(0xFFFF0049),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      100 - getXp() > 0
                          ? Spacer(
                              flex: 100 - getXp(),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text(
                "0 ",
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              ),
              const Spacer(),
              Text(
                '15',
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              ),
              const Spacer(),
              Text(
                '30',
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              ),
              const Spacer(),
              Text(
                '45',
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              ),
              const Spacer(),
              Text(
                '60',
                style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14 / 844 * height,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getCraftButton(double width, double height) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      onTap: null, //TODO CRAFT
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/off_button.svg',
            width: width - width * 0.14,
            height: (width - width * 0.14) * 0.32,
          ),
          SizedBox(
            width: width - width * 0.14,
            height: (width - width * 0.14) * 0.32,
            child: Center(
              child: Text(
                "craft hero",
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
    );
  }

  int getXp() {
    if (widget.craftSwitch == 0) {
      if (waterSamuraiXp != 0 && waterSamuraiXp != null) {
        if (waterSamuraiXp! <= 60) {
          return ((waterSamuraiXp! / 60) * 100).round();
        } else {
          return 100;
        }
      } else {
        return 1;
      }
    } else {
      if (fireSamuraiXp != 0 && fireSamuraiXp != null) {
        if (fireSamuraiXp! <= 60) {
          return ((fireSamuraiXp! / 60) * 100).round();
        } else {
          return 100;
        }
      } else {
        return 1;
      }
    }
  }

  String getDaylyXp() {
    if (widget.craftSwitch == 0) {
      if (lockedWaterSamuraiBalance != null) {
        return "+${lockedWaterSamuraiBalance! % 10} XP / Day";
      } else {
        return "+0 XP / Day";
      }
    } else {
      if (lockedFireSamuraiBalance != null) {
        return "+${lockedFireSamuraiBalance! % 10} XP / Day";
      } else {
        return "+0 XP / Day";
      }
    }
  }
}
