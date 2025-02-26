import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:samurai_app/api/rest.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:samurai_app/components/token.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class AppStorage {
  Box box = Hive.box('prefs');

  static const List<Map<String, dynamic>> tokens = [
    {'name': 'usdc', 'asset': 'assets/token.abi.json', 'address': '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174'},
    {'name': 'matic', 'asset': 'assets/token.abi.json', 'address': '0x0000000000000000000000000000000000001010'},
    {'name': 'water_samurai', 'asset': 'assets/erc1155.abi.json', 'address': '0x9e03b7c91b94235d71e031876a90c831cf409df4', 'tokenId': 0},
    {'name': 'fire_samurai', 'asset': 'assets/erc1155.abi.json', 'address': '0x9e03b7c91b94235d71e031876a90c831cf409df4', 'tokenId': 1},
  ];

  String? read(String key) {
    return box.get(key) as String?;
  }

  Future<void> write(String key, String? value) async {
    if (value != null) {
      await box.put(key, value);
    }
  }

  Future<void> remove(String key) async {
    await box.delete(key);
  }

  Future<void> fetchUser() async {
    Map value = await Rest.getUser();
    Map<String, dynamic> userData = Map.from(value);
    print(userData);
    await box.put('user', userData);
  }

  Future<void> updateUserWallet() async {
    final ethClient = Web3Client('https://polygon-rpc.com/', Client());
    String? walletAddress = AppStorage().read('wallet_adress');
    String? walletMnemonic = AppStorage().read('wallet_mnemonic');
    HDWallet? wallet;
    if (walletAddress != null && walletMnemonic != null) {
      wallet = HDWallet.createWithMnemonic(
        walletMnemonic,
      );
    }

    Map value = await Rest.getUser();
    Map<String, dynamic> userData = Map.from(value);

    if (walletAddress != null && walletMnemonic != null) {
      await Future.forEach(
        tokens,
        ((el) async {
          final abi = ContractAbi.fromJson(
            await rootBundle.loadString(el['asset']!),
            el['name']!,
          );

          DeployedContract contractUsdc = DeployedContract(
            abi,
            EthereumAddress.fromHex(
              el['address']!,
            ),
          );

          final token = Token(contractUsdc, ethClient, 137);

          List res = [];

          if (el['tokenId'] == null) {
            res = await token.read(
              contractUsdc.function('balanceOf'),
              [
                EthereumAddress.fromHex(walletAddress),
              ],
              null,
            );
          } else {
            res = await token.read(
              contractUsdc.function('balanceOf'),
              [EthereumAddress.fromHex(walletAddress), BigInt.from(el['tokenId'])],
              null,
            );
          }
          if (res.isNotEmpty) {
            if (el['name'].toString().contains('samurai')) {
              userData.addAll(
                {
                  '${el['name']!}_balance_onchain': res[0],
                },
              );
            } else {
              userData.addAll(
                {'${el['name']!}_balance_onchain': (res[0] / BigInt.from(1000000000000000000)).toDouble()},
              );
            }
          } else {
            userData.addAll(
              {
                '${el['name']!}_balance_onchain': 0.0,
              },
            );
          }
        }),
      );
    }
    await box.put('user', userData);
  }

  Map<String, dynamic> getUser() {
    return box.get('user', defaultValue: {
      'usdc_balance': 0,
    });
  }

  Map<String, dynamic> getUserWallet() {
    return box.get('user', defaultValue: {});
  }
}
