import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/craft_page.dart';
import 'package:samurai_app/pages/home/home_main_page.dart';
import 'package:samurai_app/pages/home/wallet_page.dart';
import 'package:samurai_app/pages/pin_code_page.dart';

import 'home/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 2;
  bool isMenuOpened = false;
  int craftSwitch = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
    ).then(
      (value) {
        if (ModalRoute.of(context)!.settings.arguments != null) {
          if (ModalRoute.of(context)!.settings.arguments == 'wallet') {
            setState(
              () {
                selectedPage = 5;
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          getBackground(width, height),
          SizedBox(
            width: width,
            height: height,
            child: SvgPicture.asset(
              'assets/background_gradient.svg',
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 112 / 390 * width,
              bottom: 190 / 393 * width - 190 / 393 * 0.4 * width,
            ),
            child: getContent(width, height), // Content
          ),
          bottomNavigationAndAppBar(width, height),
        ],
      ),
    );
  }

  Widget bottomNavigationAndAppBar(double width, double height) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: width,
              height: 112 / 390 * width,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/pages/homepage/appbar_background.svg',
                    width: width,
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box('prefs').listenable(),
                    builder: (context, box, widget) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).viewPadding.top,
                          bottom: 12 / 390 * width,
                          left: 25 / 390 * width,
                          right: 25 / 390 * width,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => setState(
                                    () {
                                      isMenuOpened = true;
                                    },
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/pages/homepage/menu_icon.svg',
                                      width: 35 / 390 * width,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                onTap: selectedPage != 5 ? null : () => openQr(width, height),
                                child: SvgPicture.asset(
                                  selectedPage != 5 ? 'assets/pages/homepage/RYO_icon.svg' : 'assets/pages/homepage/receive.svg',
                                  height: selectedPage != 5 ? height * 0.04 : null,
                                  fit: selectedPage != 5 ? BoxFit.contain : BoxFit.fitHeight,
                                ),
                              ),
                              selectedPage != 5
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        '0',
                                        style: GoogleFonts.spaceMono(
                                          fontSize: 16 / 844 * height,
                                          height: 21 / 14,
                                          color: Colors.white,
                                        ),
                                      ), //TODO Value
                                    )
                                  : Container(),
                              const Spacer(),
                              InkWell(
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                onTap: selectedPage != 5 ? null : () async => await AppStorage().updateUserWallet(),
                                child: SvgPicture.asset(
                                  selectedPage != 5 ? 'assets/pages/homepage/CLC_icon.svg' : 'assets/pages/homepage/trade.svg',
                                  height: selectedPage != 5 ? height * 0.04 : null,
                                  fit: selectedPage != 5 ? BoxFit.contain : BoxFit.fitHeight,
                                ),
                              ),
                              selectedPage != 5
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        AppStorage().getUser()['usdc_balance'].toString(),
                                        style: GoogleFonts.spaceMono(
                                          fontSize: 16 / 844 * height,
                                          height: 21 / 14,
                                          color: Colors.white,
                                        ),
                                      ), //TODO Value
                                    )
                                  : Container(),
                              const Spacer(),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  onTap: () {
                                    if (selectedPage != 5 && selectedPage != 6) {
                                      String? pin = AppStorage().read('pin');
                                      String? walletAdress = AppStorage().read('wallet_adress');
                                      String? walletMnemonic = AppStorage().read('wallet_mnemonic');
                                      if (walletAdress == null || walletMnemonic == null) {
                                        Navigator.pushReplacementNamed(context, '/createWallet');
                                      } else if (pin == null) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/pin',
                                          arguments: PinCodePageType.create,
                                        );
                                      } else {
                                        Navigator.of(context).pushNamed(
                                          '/pin',
                                          arguments: PinCodePageType.enter,
                                        );
                                      }
                                    } else if (selectedPage == 5) {
                                      Navigator.of(context).pushNamed('/settings');
                                    } else {}
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: SvgPicture.asset(
                                    selectedPage != 5 ? 'assets/pages/homepage/wallet_icon.svg' : 'assets/pages/homepage/settings.svg',
                                    width: selectedPage != 5 ? 50 / 390 * width : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: width,
              height: 190 / 393 * width,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/pages/homepage/bottom_navigation_background.svg',
                    width: width,
                  ),
                  Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 35 / 844 * height - 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Spacer(flex: 3),
                            bottomNavigButton(
                              SvgPicture.asset(
                                'assets/pages/homepage/page_1.svg',
                              ),
                              0,
                            ),
                            const Spacer(flex: 1),
                            bottomNavigButton(
                              SvgPicture.asset(
                                'assets/pages/homepage/page_2.svg',
                              ),
                              1,
                            ),
                            const Spacer(flex: 1),
                            bottomNavigButton(
                              SvgPicture.asset(
                                'assets/pages/homepage/page_3.svg',
                              ),
                              2,
                            ),
                            const Spacer(flex: 1),
                            bottomNavigButton(
                              SvgPicture.asset(
                                'assets/pages/homepage/page_4.svg',
                              ),
                              3,
                            ),
                            const Spacer(flex: 1),
                            bottomNavigButton(
                              SvgPicture.asset(
                                'assets/pages/homepage/page_5.svg',
                              ),
                              4,
                            ),
                            const Spacer(flex: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        isMenuOpened ? getMenu(width, height) : const SizedBox(),
      ],
    );
  }

  void openQr(double width, double height) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SizedBox(
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
            Padding(
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                          child: Center(
                            child: Text(
                              'receive',
                              style: TextStyle(
                                fontFamily: 'AmazObitaemOstrovItalic',
                                fontSize: 37 / 844 * height,
                                color: Colors.white,
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
                  const Spacer(flex: 18),
                  Expanded(
                    flex: 200,
                    child: Container(
                      padding: EdgeInsets.all(width * 0.01),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImage(
                        data: AppStorage().read('wallet_adress')!,
                        version: QrVersions.auto,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(flex: 18),
                  Expanded(
                    flex: 16,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "Scan address to recieve payment",
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 8),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      AppStorage().read('wallet_adress')!,
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(flex: 18),
                  InkWell(
                    overlayColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: AppStorage().read('wallet_adress')!,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to your clipboard!'),
                            ),
                          );
                        },
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
                              "copy adress",
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
          ],
        ),
      ),
    );
  }

  Widget bottomNavigButton(Widget child, int id) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(
              () {
                selectedPage = id;
              },
            ),
            borderRadius: BorderRadius.circular(100),
            child: Opacity(
              opacity: selectedPage == id ? 0.5 : 1.0,
              child: child,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Opacity(
            opacity: selectedPage == id ? 1.0 : 0.0,
            child: SvgPicture.asset(
              'assets/pages/homepage/indicator.svg',
              width: 4,
              height: 4,
            ),
          ),
        )
      ],
    );
  }

  Widget getMenu(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF0D1238).withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.075,
        ),
        child: Column(
          children: [
            const Spacer(flex: 65),
            Expanded(
              flex: 630,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: height * 0.66,
                      decoration: BoxDecoration(
                        color: const Color(0xFF020A38),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: const Color(0xFF00FFFF),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Opacity(
                          opacity: 0.4,
                          child: Image.asset(
                            'assets/pages/start/background.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 160,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 85,
                              child: SvgPicture.asset(
                                'assets/pages/start/logo.svg',
                              ),
                            ),
                            Expanded(
                              flex: 69,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: SvgPicture.asset(
                                  'assets/pages/start/logo_text.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 50),
                      Expanded(
                        flex: 301,
                        child: Column(
                          children: [
                            Expanded(
                              child: getMenuButton(
                                () => setState(
                                  () {
                                    selectedPage = 7;
                                    isMenuOpened = false;
                                  },
                                ),
                                'ACCOUNT',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                () => {},
                                'CHRONICLES',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                null,
                                'COUNTER',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                null,
                                'AR MASKS',
                                height,
                              ),
                            ),
                            Expanded(
                              child: getMenuButton(
                                null,
                                'CONTACTS',
                                height,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 63),
                      Expanded(
                        flex: 48,
                        child: InkWell(
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          onTap: () => setState(
                            () {
                              isMenuOpened = false;
                            },
                          ),
                          child: SvgPicture.asset(
                            'assets/pages/homepage/menu_pop_icon.svg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 150),
          ],
        ),
      ),
    );
  }

  Widget getMenuButton(Function? onTap, String text, double height) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap() : null,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'AmazObitaemOstrovItalic',
                color: onTap != null ? const Color(0xFF00FFFF) : const Color(0xFF9E9E9E),
                fontSize: height * 0.025,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getContent(double width, double height) {
    switch (selectedPage) {
      case 0:
        return getCraftPage(width - width * 0.14);
      case 2:
        return HomeMainPage(
          watchSamurai: () => setState(
            () => selectedPage = 0,
          ),
        );
      case 5:
        return const WalletPage();
      case 7:
        return const AccountPage();
      default:
        return Center(
          child: Text(
            "Coming soon",
            style: TextStyle(
              fontFamily: 'AmazObitaemOstrovItalic',
              fontSize: height * 0.05,
              color: Colors.white,
            ),
          ),
        );
    }
  }

  Widget getBackground(double width, double height) {
    switch (selectedPage) {
      case 0:
        return SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            craftSwitch == 0 ? 'assets/pages/homepage/craft/water_bg.png' : 'assets/pages/homepage/craft/fire_bg.png',
            fit: BoxFit.fitWidth,
          ),
        );
      case 2:
        return SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            'assets/pages/homepage/home_main_bg.png',
            fit: BoxFit.fitWidth,
          ),
        );
      default:
        return Container();
    }
  }

  Widget getCraftPage(double width) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: Stack(
            children: [
              SvgPicture.asset(
                craftSwitch == 0 ? 'assets/pages/homepage/craft/water.svg' : 'assets/pages/homepage/craft/fire.svg',
                fit: BoxFit.fitWidth,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => setState(
                        () {
                          craftSwitch = 0;
                        },
                      ),
                      child: SizedBox(
                        height: 45.73 / 340 * width,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => setState(
                        () {
                          craftSwitch = 1;
                        },
                      ),
                      child: SizedBox(
                        height: 45.73 / 340 * width,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: CraftPage(
            craftSwitch: craftSwitch,
          ),
        ),
      ],
    );
  }
}
