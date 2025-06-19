// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:ders_admin/fcmv1.dart';
import 'package:http/http.dart' as http;

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

const String dbPath = '/ilmfelagi/DB.db';

// const String serverUrl = "https://ilmfelagi.com/api";
const String serverUrl = "https://ilmfelagi-backend.onrender.com/api";

class DatabaseConst {
  static String savedCourses = "Courses";
  static String category = "Category";
  static String faq = "FAQ";
  static String ustaz = "Ustaz";
  static String content = "Content";
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
  sendFCMNotificationToTopic("ders", title, body, imgUrl);
  // final dio = Dio();
  // const url = 'https://fcm.googleapis.com/fcm/send';

  // final headers = {
  //   'Content-Type': 'application/json',
  //   'Authorization':
  //       'key=${dotEnv.env['Server_key']}', // Replace with your server key
  // };

  // final data = {
  //   'notification': {
  //     'title': title,
  //     'body': body,
  //     'image': imgUrl,
  //   },
  //   'to': "/topics/ders",
  // };

  // try {
  //   final response = await dio.post(
  //     url,
  //     options: Options(headers: headers),
  //     data: data,
  //   );

  //   // Handle the response as needed
  //   print(response.data);
  // } catch (e) {
  //   // Handle any error that occurred during the request
  //   print('Error sending FCM notification: $e');
  // }
}

Future<void> uploadFileToB2(File file) async {
  // Replace with your B2 tials
  String? accountId = dotEnv.env['YOUR_ACCOUNT_ID'];
  String? applicationKey = dotEnv.env['YOUR_APPLICATION_KEY'];

  // Replace with your bucket name and file name
  String? bucketName = dotEnv.env['YOUR_BUCKET_NAME'];
  String fileName = file.path.split('/').last;
  String ext = fileName.split(".").last;

  // Read the file content as bytes
  List<int> fileBytes = await file.readAsBytes();

  if (accountId == null || applicationKey == null || bucketName == null) {
    return;
  }

  // Create the URL for uploading the file
  String uploadUrl =
      'https://api.backblazeb2.com/b2api/v2/b2_upload_file/$bucketName/DersDb/$fileName';

  // Set the request headers
  Map<String, String> headers = {
    'Authorization':
        'Basic ${base64.encode(utf8.encode('$accountId:$applicationKey'))}',
    'Content-Type': 'b2/x-auto',
    'X-Bz-File-Name': fileName,
    'X-Bz-Content-Sha1': sha1.convert(fileBytes).toString(),
  };

  try {
    // Send the HTTP request with the file content
    http.Response response = await http.post(
      Uri.parse(uploadUrl),
      headers: headers,
      body: fileBytes,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "File uploaded successfully",
        backgroundColor: primaryColor,
      );
    } else {
      Fluttertoast.showToast(msg: "File upload failed ${response.statusCode}");
      print("File upload failed ${response.statusCode}");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    print(e.toString());
  }
}

String formatFileSize(int sizeInBytes) {
  if (sizeInBytes < 1024) {
    return '$sizeInBytes B';
  } else if (sizeInBytes < 1024 * 1024) {
    double sizeInKB = sizeInBytes / 1024;
    return '${sizeInKB.toStringAsFixed(2)} KB';
  } else if (sizeInBytes < 1024 * 1024 * 1024) {
    double sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(2)} MB';
  } else if (sizeInBytes < 1024 * 1024 * 1024 * 1024) {
    double sizeInGB = sizeInBytes / (1024 * 1024 * 1024);
    return '${sizeInGB.toStringAsFixed(2)} GB';
  } else {
    double sizeInTB = sizeInBytes / (1024 * 1024 * 1024 * 1024);
    return '${sizeInTB.toStringAsFixed(2)} TB';
  }
}

enum AudioState { playing, paused, idle }
