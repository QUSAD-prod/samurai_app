import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/pages/home/wallet_page_components.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:web3dart/web3dart.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _samuraiController;
  late final ScrollController _heroesController;
  late String walletAddress;
  late HDWallet wallet;
  final AppStorage appStorage = AppStorage();

  final ethClient = Web3Client('https://polygon-rpc.com/', Client());
  late Map<String, dynamic> user;

  Map<String, dynamic> transferTapDialogArgs = {};
  Map<String, dynamic> swapTapDialogArgs = {};

  late final TextEditingController transferTapDialogTextEditingController;
  late final TextEditingController transferToAddressTapDialogTextEditingController;

  late final TextEditingController swapTapDialogTextEditingController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _samuraiController = ScrollController();
    _heroesController = ScrollController();

    transferTapDialogTextEditingController = TextEditingController();
    transferToAddressTapDialogTextEditingController = TextEditingController();
    swapTapDialogTextEditingController = TextEditingController();

    walletAddress = appStorage.read('wallet_adress')!;
    wallet = HDWallet.createWithMnemonic(appStorage.read('wallet_mnemonic')!);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
    _samuraiController.dispose();
    _heroesController.dispose();

    transferTapDialogTextEditingController.dispose();
    transferToAddressTapDialogTextEditingController.dispose();

    swapTapDialogTextEditingController.dispose();
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
          if (temp != <String, dynamic>{}) {
            user = temp;
          }
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: 'TOKENS',
                        ),
                        Tab(
                          text: 'SAMURAI',
                        ),
                        Tab(
                          text: 'HEROES',
                        ),
                        Tab(
                          text: 'ITEMS',
                        ),
                      ],
                      labelStyle: GoogleFonts.spaceMono(
                        fontSize: 14 / 880 * height,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF00FFFF),
                      indicatorColor: Colors.white,
                      dividerColor: const Color(0xFF00FFFF),
                      splashBorderRadius: BorderRadius.circular(8),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          getTokens(height, width),
                          getSamurais(height, width),
                          Stack(
                            children: [
                              getHeroes(height, width),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black.withOpacity(0.6),
                                child: Center(
                                  child: Text(
                                    "Coming soon",
                                    style: TextStyle(
                                      fontFamily: 'AmazObitaemOstrovItalic',
                                      fontSize: height * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: Text(
                              "Coming soon",
                              style: TextStyle(
                                fontFamily: 'AmazObitaemOstrovItalic',
                                fontSize: height * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget getSamurais(double height, double width) {
    return RawScrollbar(
      radius: const Radius.circular(36),
      thumbColor: const Color(0xFF00FFFF),
      thumbVisibility: true,
      controller: _samuraiController,
      child: SingleChildScrollView(
        controller: _samuraiController,
        child: Column(
          children: [
            getSamurai(
              height,
              width,
              'assets/pages/homepage/samurai/water_samurai.png',
              'Water',
              'assets/pages/homepage/samurai/water_icon.svg',
              (user['water_samurai_balance_onchain'] ?? '0').toString(),
              () {
                WalletPageComponents.openToGameModalPage(
                  context: context,
                  width: width,
                  height: height,
                  wallet: wallet,
                  tokenAdress: '0x9e03b7c91b94235d71e031876a90c831cf409df4',
                  tokenId: 0,
                  iconPath: 'assets/nft_polygon.svg',
                );
              },
              () {
                WalletPageComponents.openTransferModalPage(
                  context: context,
                  width: width,
                  height: height,
                  wallet: wallet,
                  tokenAdress: '0x9e03b7c91b94235d71e031876a90c831cf409df4',
                  tokenId: 0,
                  type: 'samurai',
                  iconPath: 'assets/nft_polygon.svg',
                );
              },
            ),
            getSamurai(
              height,
              width,
              'assets/pages/homepage/samurai/water_samurai.png',
              'Water',
              'assets/pages/homepage/samurai/water_genesis_icon.svg',
              '123', //TODO amount
              () {},
              () {},
            ),
            getSamurai(
              height,
              width,
              'assets/pages/homepage/samurai/fire_samurai.png',
              'Fire',
              'assets/pages/homepage/samurai/fire_icon.svg',
              (user['fire_samurai_balance_onchain'] ?? '0').toString(),
              () {
                WalletPageComponents.openToGameModalPage(
                  context: context,
                  width: width,
                  height: height,
                  wallet: wallet,
                  tokenAdress: '0x9e03b7c91b94235d71e031876a90c831cf409df4',
                  tokenId: 1,
                  iconPath: 'assets/nft_polygon.svg',
                );
              },
              () {
                WalletPageComponents.openTransferModalPage(
                  context: context,
                  width: width,
                  height: height,
                  wallet: wallet,
                  tokenAdress: '0x9e03b7c91b94235d71e031876a90c831cf409df4',
                  tokenId: 1,
                  type: 'samurai',
                  iconPath: 'assets/nft_polygon.svg',
                );
              },
            ),
            getSamurai(
              height,
              width,
              'assets/pages/homepage/samurai/fire_samurai.png',
              'Fire',
              'assets/pages/homepage/samurai/fire_genesis_icon.svg',
              '123', //TODO amount
              () {},
              () {},
            ),
            SizedBox(
              height: height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget getHeroes(double height, double width) {
    return RawScrollbar(
      radius: const Radius.circular(36),
      thumbColor: const Color(0xFF00FFFF),
      thumbVisibility: true,
      controller: _heroesController,
      child: SingleChildScrollView(
        controller: _heroesController,
        child: Column(
          children: [
            getHero(
              height,
              width,
              'assets/pages/homepage/heroes/muzhikotavr_hero.png',
              'Muzhikotavr',
              'Feudal',
              'assets/pages/homepage/samurai/water_icon.svg',
              true,
              'legendary',
              () => {},
              () => {},
            ),
            getHero(
              height,
              width,
              'assets/pages/homepage/heroes/muzhikotavr_hero.png',
              'Muzhikotavr',
              'Shogun',
              'assets/pages/homepage/samurai/fire_icon.svg',
              false,
              'epic',
              () => {},
              () => {},
            ),
            getHero(
              height,
              width,
              'assets/pages/homepage/heroes/muzhikotavr_hero.png',
              'Muzhikotavr',
              'Ronin',
              'assets/pages/homepage/samurai/water_icon.svg',
              true,
              'regular',
              () => {},
              () => {},
            ),
            SizedBox(
              height: height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget getHero(
    double height,
    double width,
    String heroPath,
    String heroName,
    String heroClass,
    String heroLogoPath,
    bool inChronicles,
    String heroRare,
    Function toGame,
    Function transfer,
  ) {
    return Container(
      height: width * 0.9 * 0.6,
      width: width * 0.9,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: 8,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              heroRare == 'legendary'
                  ? 'assets/pages/homepage/heroes/legendary_border.svg'
                  : heroRare == 'epic'
                      ? 'assets/pages/homepage/heroes/epic_border.svg'
                      : 'assets/pages/homepage/heroes/regular_border.svg',
              width: width * 0.9,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 120,
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      Image.asset(
                        heroPath,
                        width: width * 0.29,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 10),
              Expanded(
                flex: 145,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      heroName,
                      style: GoogleFonts.spaceMono(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          heroClass,
                          style: GoogleFonts.spaceMono(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w700,
                            color: heroRare == 'legendary'
                                ? const Color(0xFF2589FF)
                                : heroRare == 'epic'
                                    ? const Color(0xFFFF0049)
                                    : const Color(0xFF00E417),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            heroLogoPath,
                            height: height * 0.025,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SvgPicture.asset(
                        inChronicles ? 'assets/pages/homepage/heroes/in_chronicles.svg' : 'assets/pages/homepage/heroes/unknown.svg',
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 20),
              Expanded(
                flex: 45,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => toGame(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/to_game.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.017,
                    ),
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => transfer(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/transfer.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget getSamurai(
    double height,
    double width,
    String samuraiPath,
    String samuraiName,
    String samuraiLogoPath,
    String amount,
    Function toGame,
    Function transfer,
  ) {
    return Container(
      height: width * 0.9 * 0.6,
      width: width * 0.9,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/pages/homepage/samurai/border.svg',
              width: width * 0.9,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 120,
                child: Center(
                  child: Image.asset(
                    samuraiPath,
                    width: width * 0.22,
                  ),
                ),
              ),
              const Spacer(flex: 10),
              Expanded(
                flex: 165,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      samuraiName,
                      style: GoogleFonts.spaceMono(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Samurai',
                          style: GoogleFonts.spaceMono(
                            fontSize: height * 0.025,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            samuraiLogoPath,
                            height: height * 0.025,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'AMOUNT:',
                        style: GoogleFonts.spaceMono(
                          fontSize: height * 0.012,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FFFF),
                        ),
                      ),
                    ),
                    Text(
                      amount,
                      style: GoogleFonts.spaceMono(
                        fontSize: height * 0.018,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00FFFF),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 45,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => toGame(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/to_game.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.017,
                    ),
                    InkWell(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      onTap: () => transfer(),
                      child: SvgPicture.asset(
                        'assets/pages/homepage/samurai/transfer.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget getTokens(double height, double width) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                  ),
                  child: Text(
                    'InGame',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                  ),
                  child: Text(
                    'OnChain',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        getSeporator(width),
        getExchanger(
          height,
          width,
          (user['usdc_balance'] ?? '0.0').toString(),
          (user['usdc_balance_onchain'] ?? '0.0').toString(),
          'assets/pages/homepage/RYO_icon.svg',
          () {
            WalletPageComponents.openSwapModalPage(
              context: context,
              width: width,
              height: height,
              wallet: wallet,
              tokenAdress: '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174',
              token: 'USDC_MATIC',
              walletAddress: walletAddress,
              iconPath: 'assets/eth_logo.svg',
            );
          },
          () {
            WalletPageComponents.openTransferModalPage(
              context: context,
              width: width,
              height: height,
              wallet: wallet,
              tokenAdress: '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174',
              type: 'token',
              iconPath: 'assets/eth_logo.svg',
            );
          },
        ),
        getSeporator(width),
        getExchanger(
          height,
          width,
          (user['matic_balance'] ?? '0.0').toString(),
          (user['matic_balance_onchain'] ?? '0.0').toString(),
          'assets/pages/homepage/CLC_icon.svg',
          () {
            WalletPageComponents.openSwapModalPage(
              context: context,
              width: width,
              height: height,
              wallet: wallet,
              token: 'MATIC',
              walletAddress: walletAddress,
              iconPath: 'assets/eth_logo.svg',
            );
          },
          () {
            WalletPageComponents.openTransferModalPage(
              context: context,
              width: width,
              height: height,
              wallet: wallet,
              tokenAdress: '0x0000000000000000000000000000000000001010',
              type: 'token',
              iconPath: 'assets/eth_logo.svg',
            );
          },
        ),
        SizedBox(
          height: height * 0.05,
        ),
      ],
    );
  }

  Widget getSeporator(double width) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      color: Colors.white.withOpacity(0.5),
      height: 1,
    );
  }

  Widget getExchanger(
    double height,
    double width,
    String value1,
    String value2,
    String iconPath,
    Function onSwapTap,
    Function onExportTap,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.012,
      ),
      height: height * 0.05,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            fit: BoxFit.fitHeight,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  value1,
                  style: GoogleFonts.spaceMono(
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.007),
            child: InkWell(
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              onTap: () => onSwapTap(),
              child: SvgPicture.asset(
                'assets/pages/homepage/refresh.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  value2,
                  style: GoogleFonts.spaceMono(
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.007),
            child: InkWell(
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              onTap: () => onExportTap(),
              child: SvgPicture.asset(
                'assets/pages/homepage/next.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
