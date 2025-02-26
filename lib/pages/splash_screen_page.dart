import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/pin_code_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    String? jwt = AppStorage().read('jwt');

    // CryptoWalletModel().init();
    // FlutterTrustWalletCore.init();

    if (jwt == null) {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () {
          Future.delayed(Duration.zero).then(
            (value) async {
              await AppStorage().fetchUser();
              await AppStorage().updateUserWallet();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF020A38),
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height * 0.8,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Image.asset(
                'assets/pages/start/background.png',
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/pages/start/logo.svg',
                  height: height * 0.15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SvgPicture.asset(
                    'assets/pages/start/logo_text.svg',
                    height: height * 0.1,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "By CLC",
                style: GoogleFonts.jost(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
