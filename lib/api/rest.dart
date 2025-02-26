import 'package:dio/dio.dart';
import 'dart:convert' show jsonDecode;

import 'package:samurai_app/components/storage.dart';

//const SERVER_IP = 'http://192.168.1.5:820'; //net
const serverIp = 'https://api.samurai-versus.io'; //work

class Rest {
  static final dio = Dio();

  static Future<Map<String, dynamic>> restHandler(String body) async {
    final data = jsonDecode(body) as Map<String, dynamic>;
    if (data['status'] == null || data['status'] == 1) {
      return data;
    } else {
      throw Exception(data['message']);
    }
  }

  static void sendCode(String email) async {
    final data = await dio.post(
      '$serverIp/api/auth/login',
      data: {'email': email},
      options: Options(
        headers: {
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> checkCode(String email, String code) async {
    final data = await dio.post(
      '$serverIp/api/auth/verify',
      data: {'email': email, 'time_code': code},
      options: Options(
        headers: {
          'Content-Type': "application/json",
        },
      ),
    );
    return data.data;
  }

  static void updateWalletAddress(String walletAddress) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/update/wallet',
      data: {'wallet_address': walletAddress},
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> getUser() async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.get(
      '$serverIp/api/users/self',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
    return data.data;
  }

  //token "FIRE_SAMURAI_MATIC" или "WATER_SAMURAI_MATIC"
  static Future<void> transfer(double amount, String token, String toAddress) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/web3/transfer',
      data: {
        'chain': 137,
        'amount': amount,
        'token': token,
        'toAddress': toAddress,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> getInfoSamurai() async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.get(
      '$serverIp/api/users/samurai/info',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
    return data.data;
  }

  //TOKEN_TYPE "FIRE_SAMURAI_MATIC" или "WATER_SAMURAI_MATIC"
  static Future<void> transferSamuraiToFree(int amount, String TOKEN_TYPE) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/samurai/${TOKEN_TYPE}/transfer/free',
      data: {
        'amount': amount,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  //TOKEN_TYPE "FIRE_SAMURAI_MATIC" или "WATER_SAMURAI_MATIC"
  static Future<void> transferSamuraiToArmy(int amount, String TOKEN_TYPE) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/samurai/${TOKEN_TYPE}/transfer/army',
      data: {
        'health': 100,
        'amount': amount,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }
}
