import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:signature/signature.dart';

class ForSignatureController extends GetxController {
  static ForSignatureController get to => Get.find();
  late SignatureController sigCtr;
  var signatureCanvas;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    sigCtr = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );

    signatureCanvas = Signature(
      controller: sigCtr,
      width: 460,
      height: 200,
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
    );
  }

  final signatureName = ''.obs;

  uploadSignatureFile(int customerId) async {
    var image = await sigCtr.toPngBytes();
    if (image != null && sigCtr.value.isNotEmpty) {
      print('draw');
      signatureName.value =
          customerId.toString() + DateTime.now().toString() + '.png';
      var result = await supabase.storage
          .from('signatures/$customerId')
          .uploadBinary(signatureName.value, image);
      print(result);

      // sigCtr.clear();
    }
  }

  clearSignature() {
    signatureName.value = '';
    sigCtr.clear();
  }

  void SignatureDialog(
      BuildContext context, int customerId, Future<void> Function() fuc) {
    try {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            width: 500,
            height: 400,
            child: StatefulBuilder(builder: (context, setDialog) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      '서명을 해주세요',
                      style: coNameText,
                    ),
                    Gap(10),
                    Center(child: signatureCanvas),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              sigCtr.undo();
                            },
                            icon: Icon(Icons.undo_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              sigCtr.clear();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ButtonWidget(
                      bgColor: Colors.blue,
                      onTap: () async {
                        await uploadSignatureFile(customerId);

                        // 함수 호출 시 괄호를 추가하고 await 사용
                        await fuc();
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
