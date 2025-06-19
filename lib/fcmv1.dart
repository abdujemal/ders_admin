import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<String> getAccessToken() async {
  // Load the service account credentials
  final String serviceAccountJson =
      await rootBundle.loadString('assets/key.json');

  final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

  final client = await clientViaServiceAccount(
    credentials,
    ['https://www.googleapis.com/auth/firebase.messaging'],
  );

  // Get the OAuth 2.0 access token
  return client.credentials.accessToken.data;
}

Future<void> sendFCMNotificationToTopic(String topic, String title, String body,
    [String? image]) async {
  final dio = Dio();

  try {
    // Get the OAuth token
    final accessToken = await getAccessToken();

    // Prepare the FCM payload
    final data = jsonEncode({
      "message": {
        "topic": topic, // Target topic
        "notification": {
          "title": title,
          "body": body,
          "image": image,
        },
        "android": {
          "priority": "high", // Optional: Set priority for Android
        }
      }
    });

    final response = await dio.post(
      'https://fcm.googleapis.com/v1/projects/completed-full-lectures/messages:send',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // OAuth token here
        },
      ),
      data: data,
    );

    print('FCM Notification sent successfully: ${response.data}');
  } catch (e) {
    print('Error sending FCM notification: $e');
  }
}
