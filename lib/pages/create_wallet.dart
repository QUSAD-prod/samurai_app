import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/pin_code_page.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  @override
  void initState() {
    super.initState();
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
              children: [
                const Spacer(
                  flex: 10,
                ),
                InkWell(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  onTap: () async {
                    HDWallet wallet = HDWallet();
                    String walletAddres = wallet.getAddressForCoin(
                      TWCoinType.TWCoinTypePolygon,
                    );
                    debugPrint(
                      wallet.getAddressForCoin(TWCoinType.TWCoinTypePolygon),
                    );
                    await AppStorage().write(
                      'wallet_adress',
                      walletAddres,
                    );
                    debugPrint(
                      wallet.mnemonic(),
                    );
                    await AppStorage().write(
                      'wallet_mnemonic',
                      wallet.mnemonic(),
                    );
                    await AppStorage().updateUserWallet();
                    if (mounted) {
                      Rest.updateWalletAddress(walletAddres);
                      Navigator.pushReplacementNamed(
                        context,
                        '/pin',
                        arguments: PinCodePageType.create,
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
                            "create wallet",
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
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'or',
                      style: GoogleFonts.spaceMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 0.9375,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/enterSeed'),
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
                            "enter seed",
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
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
