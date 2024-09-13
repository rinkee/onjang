import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/input_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/password_screen.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _redirect();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Get.off(const HomeScreenDesktop());
        print('crtUser : ${supabase.auth.currentUser}');
      }
    });
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      Get.to(const HomeScreenDesktop());
      print('crtUser : ${supabase.auth.currentUser}');
    } else {
      Get.to(const EmailScreen());
      print('crtUser : ${supabase.auth.currentUser}');
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      print('email is empty');
      return '이메일을 입력하세요';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        print('wrong email');
        return '잘못된 이메일 형식입니다.';
      } else {
        print('email check');
        return null; //null을 반환하면 정상
      }
    }
  }

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{6,15}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 6) {
      return '비밀번호는 6자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '특수문자, 문자, 숫자 포함 6자 이상 15자 이내로 입력하세요.';
    } else {
      return null; //null을 반환하면 정상
    }
  }

  var phone = '';
  var password = '';

  TextEditingController nameCtr = TextEditingController();
  TextEditingController storeNameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  var passwordBgColor = Colors.grey[100];
  var passwordHintText = '6자리 이상 공백 없이 만들어주세요';

  var emailBgColor = Colors.grey[100];
  var emailHintText = '';

  var nameBgColor = Colors.grey[100];
  var storeNameBgColor = Colors.grey[100];

  var emailCheck = false;
  var passwordCheck = false;

  Future<bool> checkEmail(String value) async {
    if (value.isEmpty) {
      updateUI(Colors.red[100], '이메일을 입력해 주세요');
      return false;
    }

    if (!isValidEmail(value)) {
      updateUI(Colors.red[100], '잘못된 이메일 형식입니다.');
      emailCtr.clear();
      phone = '';
      return false;
    }

    return await checkEmailExists(value);
  }

  void updateUI(Color? bgColor, String hintText) {
    emailBgColor = bgColor;
    emailHintText = hintText;
    setState(() {});
  }

  bool isValidEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      var response =
          await supabase.from('user').select().eq('email', email).count();
      if (response.data.isNotEmpty) {
        print('이미 가입한 이메일');
        ShowDialog(context, '이미 가입한 이메일 입니다.');
        return false;
      } else {
        print('존재하지 않는 이메일');
        return true;
      }
    } catch (e) {
      print('Database error: $e');
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailCtr.dispose();
    passwordCtr.dispose();
  }

  Future ShowDialog(context, text) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('앗!'),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '이메일을 입력해 주세요',
                      style: menuTitle,
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        Expanded(
                          child: InputWidget(
                            ctr: emailCtr,
                            title: '이메일',
                            bgColor: emailBgColor,
                            hintText: emailHintText,
                            onTap: () {
                              emailBgColor = Colors.grey[100];
                              setState(() {});
                            },
                            onChanged: (_) {
                              phone = _;
                              emailCheck = false;
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: ButtonWidget(
                            onTap: () async {
                              var check = await checkEmail(emailCtr.text);
                              print(check);
                              if (check == true) {
                                print('다음 화면으로');
                                Get.to(() => PasswordScreen(
                                      email: emailCtr.text,
                                    ));
                              } else {
                                print('이메일 확인 필요');
                              }
                            },
                            bgColor: sgColor,
                            child: const Center(
                                child: Text(
                              '다음',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))),
                      ),
                    ),
                    const Gap(10),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Get.off(const LoginScreen());
                          },
                          child: const Text('아이디가 있으신가요? 로그인')),
                    ),
                  ],
                ),

                // KContainer(
                //     child: const Center(
                //   child: Text('이메일 로그인'),
                // )),
                // GestureDetector(
                //   onTap: () async {
                //     //  final AuthResponse res = await supabase.auth.signInWithOtp(email: 'example@email.com');
                //     final res = await supabase.auth
                //         .signInWithOtp(email: 'qwedx1915@naver.com');
                //     // print(res);
                //   },
                //   child: Container(
                //     width: 200,
                //     height: 50,
                //     decoration: const BoxDecoration(
                //         color: Colors.blue,
                //         borderRadius: BorderRadius.all(Radius.circular(20))),
                //     child: const Padding(
                //       padding: EdgeInsets.all(8.0),
                //       child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Icon(Icons.add),
                //             Text(
                //               '구글 로그인',
                //               style: TextStyle(color: Colors.white),
                //             ),
                //             Icon(Icons.add)
                //           ]),
                //     ),
                //   ),
                // )
              ]),
        ),
      ),
    );
  }
}
