import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
            padding: EdgeInsets.symmetric(
              horizontal: 25 / 390 * width,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top * 1.25,
                ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        child: Center(
                          child: Text(
                            'settings',
                            style: TextStyle(
                              fontFamily: 'AmazObitaemOstrovItalic',
                              fontSize: 37 / 844 * height,
                              color: Colors.white,
                            ),
                            maxLines: 1,
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
                const Spacer(flex: 70),
                settingsButton(
                  height,
                  width,
                  'SEED PHRASE',
                  onTap: () => Navigator.of(context).pushNamed('/seed'),
                ),
                separator(width),
                settingsButton(
                  height,
                  width,
                  'TRANSACTION HISTORY',
                  isActive: false,
                ),
                separator(width),
                settingsButton(
                  height,
                  width,
                  'SIGN OUT',
                  onTap: () async {
                    await AppStorage().remove('pin');
                    await AppStorage().remove('wallet_adress');
                    await AppStorage().remove('wallet_mnemonic');
                    await AppStorage().remove('user');
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/createWallet',
                        (route) => false,
                      );
                    }
                  },
                ),
                const Spacer(flex: 500),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget settingsButton(
    double height,
    double width,
    String textData, {
    bool isActive = true,
    Function? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
      ),
      child: InkWell(
        onTap: isActive ? () => onTap!() : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 340 / 390 * width,
          padding: EdgeInsets.symmetric(
            vertical: height * 0.02,
          ),
          child: Center(
            child: Text(
              textData,
              style: GoogleFonts.spaceMono(
                fontSize: 20 / 844 * height,
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: isActive ? const Color(0xFF00FFFF) : const Color(0xFF9D9D9D).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget separator(double width) {
    return Container(
      width: 340 / 390 * width,
      height: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }
}
