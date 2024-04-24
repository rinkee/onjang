import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/common_widget/k_edit_textfield.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/home/home_screen.dart';
import 'package:jangboo_flutter/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/login/login_screen.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
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
        Get.off(const HomeScreen());
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
      Get.to(const HomeScreen());
      print('crtUser : ${supabase.auth.currentUser}');
    } else {
      Get.to(const SingInScreen());
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

  checkPhone(String value) {
    if (value.isEmpty) {
      emailBgColor = Colors.red[100];
      emailHintText = '전화번호를 입력해 주세요';
      setState(() {});
    }
    if (value.length != 11) {
      print('옳지않은 전화번호 형식');
      emailBgColor = Colors.red[100];
      emailHintText = '전화번호를 다시 한번 확인 해 주세요';
      setState(() {});
    }
    if (value.length == 11) {
      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = RegExp(patttern);
      if (!regExp.hasMatch(value)) {
        print('옳지않은 전화번호 형식');
        print('옳지않은 전화번호 형식');
        emailBgColor = Colors.red[100];
        emailHintText = '전화번호를 다시 한번 확인 해 주세요';
        setState(() {});
      } else {
        print('phone check');
        emailHintText = '';
        emailBgColor = Colors.green[100];
        emailCheck = true;
        setState(() {});
      }
    }
  }

  checkEmail(String value) {
    if (value.isEmpty) {
      emailBgColor = Colors.red[100];
      emailHintText = '전화번호를 입력해 주세요';
      setState(() {});
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        print('wrong email');
        emailBgColor = Colors.red[100];
        emailHintText = '잘못된 전화번호 형식입니다.';
        emailCtr.clear();
        phone = '';
        setState(() {});
      } else {
        print('email check');
        emailHintText = '';
        emailBgColor = Colors.green[100];
        emailCheck = true;
        setState(() {});
        return null; //null을 반환하면 정상
      }
    }
  }

  checkPassword(String value) {
    if (value.length < 6) {
      password = '';
      passwordCtr.clear();
      passwordBgColor = Colors.red[100];
      passwordHintText = '6자리 이상으로 만들어 주세요';
      setState(() {});
    } else {
      if (value.toString().contains(' ')) {
        print('password in space');
        password = '';
        passwordCtr.clear();
        passwordBgColor = Colors.red[100];
        passwordHintText = '공백을 제거해 주세요';
        setState(() {});
      } else {
        passwordHintText = '';
        passwordBgColor = Colors.green[100];
        passwordCheck = true;
        setState(() {});
      }
    }
  }

  checkName({required String name, required String storeName}) {
    if (name == "") {
      nameBgColor = Colors.red[100];
    } else {
      nameBgColor = Colors.green[100];
    }
    if (storeName == "") {
      storeNameBgColor = Colors.red[100];
    } else {
      storeNameBgColor = Colors.green[100];
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailCtr.dispose();
    passwordCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: maxWidth,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '4가지만 입력하면',
                      style: menuTitle,
                    ),
                    const Text(
                      '가입완료',
                      style: menuTitle,
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        Expanded(
                          child: EditTextField(
                            ctr: emailCtr,
                            title: '전화번호',
                            bgColor: emailBgColor,
                            hintText: emailHintText,
                            textInputType: TextInputType.phone,
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
                        const Gap(20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              passwordBgColor = Colors.grey[100];
                              setState(() {});
                            },
                            child: EditTextField(
                              ctr: passwordCtr,
                              title: '비밀번호',
                              bgColor: passwordBgColor,
                              hintText: passwordHintText,
                              isPassword: true,
                              onTap: () {
                                passwordBgColor = Colors.grey[100];

                                setState(() {});
                              },
                              onChanged: (_) {
                                password = _;
                                print(password);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),

                    // const Padding(
                    //   padding: EdgeInsets.only(left: 5),
                    //   child: Text(
                    //     '비밀번호',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // const Gap(5),
                    // GestureDetector(
                    //   onTap: () {
                    //     passwordBgColor = Colors.grey[100];
                    //     setState(() {});
                    //   },
                    //   child: KContainer(
                    //       color: passwordBgColor,
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 20),
                    //         child: Center(
                    //           child: TextField(
                    //             obscureText: true,
                    //             controller: passwordCtr,
                    //             decoration: InputDecoration(
                    //                 hintText: passwordHintText,
                    //                 border: InputBorder.none),
                    //             onTap: () {
                    //               passwordBgColor = Colors.grey[100];
                    //               passwordHintText = '';
                    //               setState(() {});
                    //             },
                    //             onChanged: (_) {
                    //               password = _;
                    //               print(password);
                    //             },
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: EditTextField(
                            ctr: nameCtr,
                            title: '이름',
                            bgColor: nameBgColor,
                            hintText: '사용자의 이름을 입력 해 주세요',
                            onChanged: (_) {
                              if (_ == '') {
                                nameBgColor = Colors.grey[100];
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          child: EditTextField(
                            ctr: storeNameCtr,
                            title: '가게명',
                            bgColor: storeNameBgColor,
                            hintText: '사용자의 가게명을 입력 해 주세요',
                            onChanged: (_) {
                              if (_ == '') {
                                storeNameBgColor = Colors.grey[100];
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const Gap(20),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: kBtn(
                            onTap: () async {
                              var key = utf8.encode(password);
                              print(key);
                              var passwordHash = sha256.convert(key).toString();
                              print(passwordHash);

                              checkPhone(phone);
                              checkPassword(passwordCtr.text);
                              checkName(
                                  name: nameCtr.text,
                                  storeName: storeNameCtr.text);
                              if (emailCheck &&
                                  passwordCheck &&
                                  nameCtr.text != '' &&
                                  storeNameCtr.text != '') {
                                final auth = Get.put(AuthController());
                                final result = await auth.signUp(
                                    phone: phone,
                                    password: password,
                                    name: nameCtr.text,
                                    passwordHash: passwordHash,
                                    store_name: storeNameCtr.text);
                                Get.to(() => const HomeScreenDesktop());
                                // print(result['message']);
                                if (result == 'error') {
                                  emailCtr.clear();
                                  emailHintText = '이미 존재하는 번호입니다';
                                  emailBgColor = Colors.red[100];
                                  setState(() {});
                                }
                              }
                            },
                            bgColor: sgColor,
                            child: const Center(
                                child: Text(
                              '시작하기',
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
                            Get.offAll(const LoginScreen());
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
