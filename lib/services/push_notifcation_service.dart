import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotifcationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "seenchatapp",
      "private_key_id": "3798275b096a778d7fa4ed374665cd2e3087bba7",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCVsNKBmraG/HwD\niLYuNJGd4GD3PIlaNh71tE5BsRwDCHTpwYGo/RzvZYqTF88NbWOnXMh6FgqK6KCl\nEuaPHOGHKMAp7WbEUaZJTBtFynkT+vuJ/kK8wySgslto2GeFAIgItE7dWGZ2ltbP\n/46KStUZtiYLIZ0ARXYOFdtxFz2g36yANkMqxr51wGsP3q63eILKjRkS+PWjgv9d\nheIev2LzwArN5ugzK3Zemj7MxcGZtosvuSXMXZ1JwVMhxU/6LwzvQBOqhOLee+hN\ngHiIcTI+qLEHIwWXmdCQMHdiHAik9FP2T1godR+IxhHlhIMAJ9ckvVxGntUV63iH\n2Alq9G53AgMBAAECggEAGD2jSVO5nVCD8LqR7hebQTrV2RPXlmFPUDDbv22kAKW8\n8SHiEnCy393MvBdN83m0eqTe3k51dJtJcJIH/kMKDq49uEx2qPIkAJivjfTE+MRb\nObSQMCtV4iQgA3GQCgzU+rvgTZ4EMc4piVN0TNbjfZ9ut7zAxQt6m7tUZxMBauyu\nYAa1Lm9agF9o07dZWcKN+ZW5lL3KwI5rawbk0IJxAlwzXIYzFgZoEdb4jxCby5Sd\n+pto97L81nxcam/NBl9lnHUJApStSMJeK+KNXIzSWupuWct9U/QJjFAbfbp1UBr3\nF30yuMISY0S5q/C9LdSj8CTd5pPfLGw8zefPLqPz0QKBgQDRvbdGn96WuSd5byQz\nZNmPudnduDl9h40rxin1Y8/jItktaQ3jUkvO2DE7gE8WIYRCSt2UuJtIaowjuXFE\nkPGpy8sAsq9VK8s4VhCUUW6t74HqB8yFcH83udn4RTV/tdT9Ge8N5AA5bHZz7dsm\nEmUGCoVhOyCH9C5F2RHt0l4m+QKBgQC2tJN15MtU7DDnUzK5oCY0T2YWdjBkuzq9\n62Pv1QdXwVamYTdLc7yakOC94GVUdY6n82rn9a5MP8juTxFpBZvAGxJVhzgXr5AT\ns8iIEZ4Hj1HHf55/+STWJTLsGN+cb0XChxN1X5LzWFJ9K6IZfu1+OgPs+K8nLome\n+/KJh8Vs7wKBgDVmpjk3Dwc1ERXb9E2ZicMMQKow84JAdvMEOz6dMRrVjpH/Q2fz\nVhXN+Yr6uigaVIBEa3IoJnEjn5ag6nPYq47dskv1MqruwYkQcJwyt4lVh7A8WBhJ\ncjqP+S07AcoIU7g1WCYjPONh+C7ACqIA4PPOzfLZiQjUZMun3ua8PviRAoGAZcZj\nWknwBkdn2oRa/lI61ergyGRgAszVJRRp4CB/7Z9ygE4pOiunhUZtGvhUGd8+b0pG\nZB5UUH87k5yR6znHkBTEesZPNcqDbKY6b6m4qSdp+8KYbVtA7NVd72zPq1nEt179\nNOXfexTZJobWznMJIsZ4h1nkX+Qpn1ljur7Z+BsCgYEAo6PA+AYYpmtFXjkeFdd1\nE7Tb1hUHcLwKEf/PxjeHfBQPFvvNR49s9eiSlu3aKb0uNcf9mluWWU/Ypue8GV+U\nn4LV9FNyvoGSjiv8ZnWRB7Ej2idpO8ZTNWM9LJnVU8jy2e35NEhml28BeJnw53ek\nuCvcdlFaNlQR+yvkwJmS3HU=\n-----END PRIVATE KEY-----\n",
      "client_email": "seenchatapp@appspot.gserviceaccount.com",
      "client_id": "116277255281564001579",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/seenchatapp%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotifcationToSelectUser({
    required String deviceToken,
    required String anotherUserId,
    required String userName,
    required String messageContent,
  }) async {
    final String serverAccessTokenKay = await getAccessToken();

    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/seenchatapp/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': userName,
          'body': messageContent,
        },
        'data': {
          'userName': userName,
          'body': messageContent,
          'anotherUserId': anotherUserId,
          'anotherFcToken': deviceToken,
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $serverAccessTokenKay',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Notification not sent. Status code: ${response.statusCode}');
    }
  }
}
