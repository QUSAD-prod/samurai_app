import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/account_page_components.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final ScrollController scrollController;
  late bool googleAuthenticatorSwitch;
  late bool emailAuthenticatorSwitch;
  late bool soundSwitch;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    googleAuthenticatorSwitch = false; //TODO
    emailAuthenticatorSwitch = false; //TODO
    soundSwitch = false; //TODO
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
        valueListenable: Hive.box('prefs').listenable(),
        builder: (context, box, widget) {
          Map<String, dynamic> temp = box.get(
            'user',
            defaultValue: <String, dynamic>{},
          );
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: RawScrollbar(
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
                      Text(
                        'ACCOUNT',
                        style: TextStyle(
                          fontFamily: 'AmazObitaemOstrovItalic',
                          color: Colors.white,
                          fontSize: 38 / 960 * height,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: width * 0.86,
                          height: 144 / 340 * width * 0.86,
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/pages/account/border.svg',
                                width: width * 0.86,
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      temp['email'],
                                      style: GoogleFonts.spaceMono(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 16 / 960 * height,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2 / 96 * height),
                                      child: InkWell(
                                        overlayColor: MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                        onTap: () => AccountPageComponents.openChangeEmailModalPage(
                                          context: context,
                                          width: width,
                                          height: height,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/pages/account/change_email_bt.svg',
                                          height: 5 / 96 * height,
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
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          "Google Authenticator",
                          Switch(
                            activeColor: const Color(0xFF00FFFF),
                            value: googleAuthenticatorSwitch,
                            onChanged: (value) => setState(
                              () {
                                // googleAuthenticatorSwitch = value; //TODO
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          "E-mail Authenticator",
                          Switch(
                            activeColor: const Color(0xFF00FFFF),
                            value: emailAuthenticatorSwitch,
                            onChanged: (value) => setState(
                              () {
                                // emailAuthenticatorSwitch = value; //TODO
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          'Sound',
                          Switch(
                            activeColor: const Color(0xFF00FFFF),
                            value: soundSwitch,
                            onChanged: (value) => setState(
                              () {
                                // soundSwitch = value; //TODO
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          "Terms of Use",
                          IconButton(
                            onPressed: () => {}, //TODO
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF00FFFF),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getMainAccountTextWidget(
                          height,
                          "Privacy Policy",
                          IconButton(
                            onPressed: () => {}, //TODO
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF00FFFF),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSecondaryAccountTextWidget(
                          height,
                          "Version",
                          AppStorage().read('appVer').toString(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3 / 96 * height),
                        child: getSeporator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSecondaryAccountTextWidget(
                          height,
                          "Total battles",
                          '0', //TODO
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSeporator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSecondaryAccountTextWidget(
                          height,
                          "Earned RYO",
                          '0', //TODO
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16 / 960 * height),
                        child: getSeporator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3 / 96 * height),
                        child: InkWell(
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          onTap: () async {
                            await AppStorage().remove('jwt');
                            await AppStorage().remove('pin');
                            await AppStorage().remove('wallet_adress');
                            await AppStorage().remove('wallet_mnemonic');
                            await AppStorage().remove('user');
                            if (mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/pages/account/logout_bt.svg',
                            height: 45 / 960 * height,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.075,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getMainAccountTextWidget(
    double height,
    String title,
    Widget endWidget,
  ) {
    return SizedBox(
      height: 4 / 96 * height,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.spaceMono(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 17 / 960 * height,
              ),
            ),
          ),
          SizedBox(
            height: 4 / 96 * height,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: endWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSecondaryAccountTextWidget(
    double height,
    String title,
    String endTitle,
  ) {
    return SizedBox(
      height: 4 / 96 * height,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.spaceMono(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 17 / 960 * height,
              ),
            ),
          ),
          Text(
            endTitle,
            style: GoogleFonts.spaceMono(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16 / 960 * height,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSeporator() {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}
