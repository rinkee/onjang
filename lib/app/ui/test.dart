import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/go_routes.dart';
import 'package:http/http.dart' as http;

var serviceId = 'ncp:sms:kr:340689979068:verification';
var accessKey = 'ncp_iam_BPAMKR5SGHb24oOaWEAV';
var secretKey = 'ncp_iam_BPKMKRYmJoZuCljTJxdgMQei4Z1arlqziY';

String getSignature(
    String serviceId, String timeStamp, String accessKey, String secretKey) {
  var space = " "; // one space
  var newLine = "\n"; // new line
  var method = "POST"; // method
  var url = "/sms/v2/services/$serviceId/messages";

  var buffer = new StringBuffer();
  buffer.write(method);
  buffer.write(space);
  buffer.write(url);
  buffer.write(newLine);
  buffer.write(timeStamp);
  buffer.write(newLine);
  buffer.write(accessKey);
  // print(buffer.toString());

  /// signing key
  var key = utf8.encode(secretKey);
  var signingKey = new Hmac(sha256, key);

  var bytes = utf8.encode(buffer.toString());
  var digest = signingKey.convert(bytes);
  String signatureKey = base64.encode(digest.bytes);
  return signatureKey;
}

void sendSMS(String phoneNumber) async {
  Map data = {
    "type": "SMS",
    "contentType": "COMM",
    "countryCode": "82",
    "from": "1234567890",
    "content": "ABCD",
    "messages": [
      {"to": phoneNumber, "content": "EFGH"}
    ],
  };
  var result = await http.post(
      Uri(
          query:
              "https://sens.apigw.ntruss.com/sms/v2/services/${Uri.encodeComponent(secretKey)}/messages"),
      headers: <String, String>{
        "accept": "application/json",
        'content-Type': 'application/json; charset=UTF-8',
        'x-ncp-apigw-timestamp': DateTime.now().toString(),
        'x-ncp-iam-access-key': accessKey,
        'x-ncp-apigw-signature-v2': getSignature(Uri.encodeComponent(serviceId),
            DateTime.now().toString(), accessKey, secretKey)
      },
      body: json.encode(data));
  print(result.body);
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('테스트 페이지'),
          TextButton(
              onPressed: () async {
                // context.goNamed('/2');
                // var value = await getSignature(
                //     serviceId, DateTime.now().toString(), accessKey, secretKey);

                // print(value);
                sendSMS('01047562062');
              },
              child: Text('테스트2로'))
        ],
      ),
    );
  }
}

class TestScreen2 extends StatelessWidget {
  const TestScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('테스트 페이지2'),
          TextButton(
              onPressed: () {
                context.goNamed('/3');
              },
              child: Text('테스트3로'))
        ],
      ),
    );
  }
}

class TestScreen3 extends StatelessWidget {
  const TestScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('테스트 페이지3'),
    );
  }
}
