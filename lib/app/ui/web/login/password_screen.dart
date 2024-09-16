import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/input_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';

class PasswordScreen extends StatefulWidget {
  PasswordScreen({super.key, required this.email});

  var email;

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final AuthService _authService = Get.find<AuthService>();

  bool validatePassword(String value) {
    String pattern = r'^[^\s]{6,15}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  TextEditingController passwordCtr = TextEditingController();
  TextEditingController passwordCheckCtr = TextEditingController();

  var passwordBgColor = Colors.grey[100];
  var passwordHintText = '6자리 이상 공백 없이 만들어주세요';

  Future<bool> checkPassword(String value) async {
    if (value.isEmpty) {
      // updateUI(Colors.red[100], ' 입력해 주세요');
      ShowDialog(context, '비밀번호를 입력해 주세요');
      return false;
    }

    if (!validatePassword(value)) {
      ShowDialog(context, '6자리 이상 15자리 이하');

      return false;
    }

    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordCtr.dispose();
    passwordCheckCtr.dispose();
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
                      '비밀번호를 입력해 주세요',
                      style: menuTitle,
                    ),
                    const Gap(15),
                    InputWidget(
                      ctr: passwordCtr,
                      title: '비밀번호',
                      bgColor: passwordBgColor,
                      hintText: passwordHintText,
                      isPassword: true,
                      textInputType: TextInputType.phone,
                      onTap: () {},
                      onChanged: (_) {},
                    ),
                    const Gap(10),
                    InputWidget(
                      ctr: passwordCheckCtr,
                      title: '비밀번호 확인',
                      bgColor: passwordBgColor,
                      hintText: passwordHintText,
                      isPassword: true,
                      textInputType: TextInputType.phone,
                      onTap: () {},
                      onChanged: (_) {},
                    ),
                    const Gap(10),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: ButtonWidget(
                            onTap: () async {
                              var check = false;
                              if (passwordCtr.text == passwordCheckCtr.text) {
                                check = await checkPassword(passwordCtr.text);
                              } else {
                                ShowDialog(context, '비밀번호가 같지 않아요');
                                passwordCtr.clear();
                                passwordCheckCtr.clear();
                              }

                              print(check);

                              if (check == true) {
                                print('다음 화면으로');
                                final UserController _userCtr =
                                    Get.find<UserController>();
                                await _authService.signUp(
                                    email: widget.email,
                                    password: passwordCtr.text);
                                Get.offAll(() => const HomeScreen());
                              } else {
                                print('비번 확인 필요');
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
