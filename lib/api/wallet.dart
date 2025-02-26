import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:samurai_app/components/token.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_ffi.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:web3dart/web3dart.dart';

class WalletAPI {
  static const rootWalletAddress = '0x2D423710BaD0e41883C3Ad379b4365ac4a97DE92';

  static final ethClient = Web3Client(
    'https://polygon-rpc.com/',
    Client(),
  );

  static Future<void> transferERC1155(HDWallet wallet, String tokenAddress, int tokenId, int amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(
      TWCoinType.TWCoinTypeSmartChain,
    );
    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/erc1155.abi.json'),
      'usdc',
    );
    final deployedContract = DeployedContract(
      abi,
      EthereumAddress.fromHex(tokenAddress),
    );
    final tokenContract = Token(deployedContract, ethClient, 137);
    final transaction = Transaction(
      to: EthereumAddress.fromHex(tokenAddress),
    );
    final String transactionHash = await tokenContract.write(
      credentials,
      transaction,
      deployedContract.function('safeTransferFrom'),
      [
        EthereumAddress.fromHex(wallet.getAddressForCoin(TWCoinType.TWCoinTypePolygon)),
        EthereumAddress.fromHex(toAddress ?? rootWalletAddress),
        BigInt.from(tokenId),
        BigInt.from(amount),
        Uint8List.fromList(Uint8List.fromList('0x'.codeUnits)),
      ],
    );
  }

  static Future<void> transferMATIC(HDWallet wallet, double amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeSmartChain);

    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final transaction = Transaction(
      to: EthereumAddress.fromHex(rootWalletAddress),
      value: EtherAmount.fromBigInt(EtherUnit.wei, BigInt.from(amount * 1000000000000000000)),
    );
    final String transactionHash = await ethClient.sendTransaction(credentials, transaction, chainId: 137);
  }

  static Future<void> transferERC20(HDWallet wallet, String tokenAddress, double amount, String? toAddress) async {
    PrivateKey privateKey = wallet.getKeyForCoin(
      TWCoinType.TWCoinTypeSmartChain,
    );
    final credentials = EthPrivateKey.fromHex(
      HEX.encode(privateKey.data()),
    );

    final abi = ContractAbi.fromJson(
      await rootBundle.loadString('assets/token.abi.json'),
      'usdc',
    );
    final deployedContract = DeployedContract(
      abi,
      EthereumAddress.fromHex(tokenAddress),
    );
    final tokenContract = Token(deployedContract, ethClient, 137);
    final transaction = Transaction(
      to: EthereumAddress.fromHex(toAddress ?? rootWalletAddress),
    );
    final String transactionHash = await tokenContract.write(
      credentials,
      transaction,
      deployedContract.function('transfer'),
      [
        EthereumAddress.fromHex(toAddress ?? rootWalletAddress),
        BigInt.from(amount * 1000000000000000000),
      ],
    );
  }
}
