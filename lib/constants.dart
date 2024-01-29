// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

class UrlData {
  final String name;
  final String url;
  UrlData({
    required this.name,
    required this.url,
  });
}

launchUrl(url) async {
  if (!await launchUrl(url)) {
    Fluttertoast.showToast(msg: 'Could not launch $url');
  }
}

const primaryColor = MaterialColor(
  0xFF2FA887,
  <int, Color>{
    50: Color(0xFFE0F3E4),
    100: Color(0xFFB3E0C7),
    200: Color(0xFF80CCAA),
    300: Color(0xFF4DB892),
    400: Color(0xFF26AA7A),
    500: Color(0xFF2FA887),
    600: Color(0xFF268170),
    700: Color(0xFF1F6A5A),
    800: Color(0xFF185442),
    900: Color(0xFF0F3D2B),
  },
);

// Future<String> getTelegramName(String botToken, int chatId) async {
//   final bot = TelegramBot(token: botToken);
//   final getChatResponse = await bot.getChat(chatId);

//   if (getChatResponse.ok) {
//     final chat = getChatResponse.result;
//     final name = chat.title ?? chat.firstName;
//     return name ?? 'Unknown';
//   } else {
//     throw Exception('Failed to retrieve Telegram name');
//   }
// }

Future<void> sendFcmNotification(
    String title, String body, String imgUrl) async {
  final dio = Dio();
  const url = 'https://fcm.googleapis.com/fcm/send';

  print(dotEnv.env['Server_key']);

  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=${dotEnv.env['Server_key']}', // Replace with your server key
  };

  final data = {
    'notification': {
      'title': title,
      'body': body,
      'image': imgUrl,
    },
    'to': "/topics/ders",
  };

  try {
    final response = await dio.post(
      url,
      options: Options(headers: headers),
      data: data,
    );

    // Handle the response as needed
    print(response.data);
  } catch (e) {
    // Handle any error that occurred during the request
    print('Error sending FCM notification: $e');
  }
}

enum AudioState { playing, paused, idle }
