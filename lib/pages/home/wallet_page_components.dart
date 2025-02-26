import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import '../../api/rest.dart';
import '../../api/wallet.dart';
import '../../components/samurai_text_field.dart';

class WalletPageComponents {
  static void openSwapModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required HDWallet wallet,
    String? tokenAdress,
    required String token,
    required String walletAddress,
    required String iconPath,
  }) {
    String mode = 'inGame';
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
          width: width,
          height: height * 0.8,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SizedBox(
                  width: width,
                  height: height * 0.8,
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
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.1,
                                ),
                                child: Center(
                                  child: Text(
                                    'swap',
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
                          ),
                          SizedBox(
                            height: width * 0.12,
                            width: width * 0.12,
                          ),
                        ],
                      ),
                      MediaQuery.of(context).viewInsets.bottom == 0 ? const Spacer(flex: 19) : Container(),
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? Expanded(
                              flex: 96,
                              child: SvgPicture.asset(
                                iconPath,
                                width: width * 0.4,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(),
                      const Spacer(flex: 30),
                      Expanded(
                        flex: 146,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/swap_border.svg',
                              fit: BoxFit.fill,
                              width: width - 46,
                            ),
                            Row(
                              children: [
                                const Spacer(flex: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(flex: 31),
                                    Expanded(
                                      flex: 20,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          mode == 'inGame' ? 'WALLET' : 'GAME',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(flex: 32),
                                    Expanded(
                                      flex: 20,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          mode == 'inGame' ? 'GAME' : 'WALLET',
                                          style: GoogleFonts.spaceMono(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(flex: 30),
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
                                        mode == 'inGame' ? mode = 'inChain' : mode = 'inGame';
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
                            "Available: 1075 ETH", //TODO value
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
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom / 2,
                      ),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () {
                          if (token == 'USDC_MATIC') {
                            if (mode == 'inGame') {
                              WalletAPI.transferERC20(
                                wallet,
                                tokenAdress!,
                                double.parse(controller.text),
                                null,
                              );
                            } else if (mode == 'inChain') {
                              Rest.transfer(
                                double.parse(controller.text),
                                token,
                                walletAddress,
                              );
                            }
                          } else if (token == 'MATIC') {
                            if (mode == 'inGame') {
                              WalletAPI.transferMATIC(
                                wallet,
                                double.parse(controller.text),
                                null,
                              );
                            } else if (mode == 'inChain') {
                              Rest.transfer(
                                double.parse(controller.text),
                                token,
                                walletAddress,
                              );
                            }
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

  static void openToGameModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required HDWallet wallet,
    required String tokenAdress,
    required int tokenId,
    required String iconPath,
  }) {
    TextEditingController controller = TextEditingController();

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
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.1,
                                ),
                                child: Center(
                                  child: Text(
                                    "to game",
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
                          ),
                          SizedBox(
                            height: width * 0.12,
                            width: width * 0.12,
                          ),
                        ],
                      ),
                      MediaQuery.of(context).viewInsets.bottom == 0 ? const Spacer(flex: 17) : Container(),
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? Expanded(
                              flex: 85,
                              child: SvgPicture.asset(
                                iconPath,
                                width: width * 0.4,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(),
                      const Spacer(flex: 25),
                      SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: 'Ammount',
                        keyboardType: TextInputType.number,
                        controller: controller,
                      ),
                      const Spacer(flex: 15),
                      Row(
                        children: [
                          Text(
                            "Available: 1075 ETH", //TODO value
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
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom / 2,
                      ),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () {
                          WalletAPI.transferERC1155(
                            wallet,
                            tokenAdress,
                            tokenId,
                            int.parse(
                              controller.text,
                            ),
                            null,
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

  static void openTransferModalPage({
    required BuildContext context,
    required double width,
    required double height,
    required HDWallet wallet,
    required String tokenAdress,
    required String type,
    int? tokenId,
    required String iconPath,
  }) {
    TextEditingController adressController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, StateSetter setState) => SizedBox(
          width: width,
          height: height * 0.7,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: SizedBox(
                  width: width,
                  height: height * 0.7,
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
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                ),
                                child: Center(
                                  child: Text(
                                    'withdraw',
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
                          ),
                          SizedBox(
                            height: width * 0.12,
                            width: width * 0.12,
                          ),
                        ],
                      ),
                      MediaQuery.of(context).viewInsets.bottom == 0 ? const Spacer(flex: 19) : Container(),
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? Expanded(
                              flex: 96,
                              child: SvgPicture.asset(
                                iconPath,
                                width: width * 0.4,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(),
                      const Spacer(flex: 34),
                      SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: "To adress",
                        controller: adressController,
                      ),
                      const Spacer(flex: 20),
                      SamuraiTextField(
                        screeenHeight: height,
                        screeenWidth: width,
                        hint: 'Ammount',
                        keyboardType: TextInputType.number,
                        controller: amountController,
                      ),
                      const Spacer(flex: 15),
                      Row(
                        children: [
                          Text(
                            "Available: 1075 ETH", //TODO value
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
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom / 2,
                      ),
                      InkWell(
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () {
                          if (type == 'token') {
                            WalletAPI.transferERC20(
                              wallet,
                              tokenAdress,
                              double.parse(amountController.text),
                              adressController.text,
                            );
                          } else if (type == 'samurai') {
                            WalletAPI.transferERC1155(
                              wallet,
                              tokenAdress,
                              tokenId!,
                              int.parse(amountController.text),
                              adressController.text,
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
}
