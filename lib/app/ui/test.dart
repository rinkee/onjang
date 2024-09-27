import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/go_routes.dart';
import 'package:http/http.dart' as http;
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:signature/signature.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

final SignatureController _controller = SignatureController(
  penStrokeWidth: 3,
  penColor: Colors.black,
  exportBackgroundColor: Colors.white,
);

// INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD
var _signatureCanvas = Signature(
  controller: _controller,
  width: 400,
  height: 200,
  backgroundColor: Colors.white,
);

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Uint8List? signature;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('테스트 페이지'),
            // if (signature != null) Image.memory(signature!),
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                width: 300,
                height: 300,
              ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: SizedBox(
                                width: 500,
                                height: 400,
                                child: StatefulBuilder(
                                    builder: (context, setDialog) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '서명을 해주세요',
                                          style: coNameText,
                                        ),
                                        Gap(10),
                                        Center(child: _signatureCanvas),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    _controller.undo();
                                                  },
                                                  icon:
                                                      Icon(Icons.undo_rounded)),
                                              IconButton(
                                                  onPressed: () {
                                                    _controller.clear();
                                                  },
                                                  icon: Icon(Icons.close)),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        ButtonWidget(
                                            bgColor: _controller.value.isEmpty
                                                ? null
                                                : Colors.blue,
                                            onTap: () async {
                                              var image =
                                                  await _controller.toPngBytes(
                                                      width: 300, height: 300);

                                              if (image != null) {
                                                // print(image);
                                                // setState(() {
                                                //   signature = image;
                                                // });

                                                final String fullPath =
                                                    await supabase.storage
                                                        .from('signatures')
                                                        .uploadBinary(
                                                          'avatar2.png',
                                                          image,
                                                        )
                                                        .whenComplete(() async {
                                                  var url = await supabase
                                                      .storage
                                                      .from('signatures')
                                                      .createSignedUrl(
                                                          'avatar2.png', 60);
                                                  print(url);
                                                  setState(() {
                                                    context.pop();
                                                    imageUrl = url;
                                                  });
                                                });
                                              }
                                            },
                                            child: Text('확인'))
                                      ],
                                    ),
                                  );
                                })),
                          ));
                },
                child: Text('드로잉 테스트')),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: BorderContainerWidget(
                w: 800,
                h: 600,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('기본형'),
                            ),
                            Text('선결제 장부가 아직 많지않거나 천천히 도입을 원하시는 사장님들에게 추천해요'),
                            Table(
                              border: TableBorder.all(
                                  color:
                                      const Color.fromARGB(255, 234, 234, 234)),
                              children: [
                                TableRow(
                                  children: [
                                    TableText(
                                      text: '고객 등록 수',
                                    ),
                                    TableText(
                                      text: '5명',
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableText(
                                      text: '광고',
                                    ),
                                    TableText(
                                      text: 'O',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(20),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('베이직'),
                            ),
                            Text('선결제 비중이 많아 관리가 필요한 사장님들에게 추천해요'),
                            Table(
                              border: TableBorder.all(
                                  color:
                                      const Color.fromARGB(255, 234, 234, 234)),
                              children: [
                                TableRow(children: [
                                  TableText(
                                    text: '고객 등록 수',
                                  ),
                                  TableText(
                                    text: '30',
                                  ),
                                ]),
                                TableRow(children: [
                                  TableText(
                                    text: '광고',
                                  ),
                                  TableText(
                                    text: 'X',
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}

class TableText extends StatelessWidget {
  const TableText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
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
