import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

class IntroduceScreen extends StatelessWidget {
  IntroduceScreen({super.key});

  TextStyle titleStyle =
      const TextStyle(fontSize: 36, fontWeight: FontWeight.bold);

  TextStyle subTitleStyle = const TextStyle(fontSize: 24, color: Colors.grey);

  TextStyle shortTitleStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: sgColor);
  TextStyle whiteShortTitleStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '선장',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        shadowColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                Get.to(() => const HomeScreenDesktop());
              },
              child: const Text('시작하기'))
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: BorderContainerWidget(
                h: 500,
                // color: Colors.blueGrey[100],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 800,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '이 서비스는 오직\n사장님들을 위해 만들었습니다.',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const Gap(50),
                            BorderContainerWidget(
                                color: sgColor,
                                child: const SizedBox(
                                    width: 150,
                                    child: Center(
                                        child: Text(
                                      '시작하기',
                                      style: TextStyle(color: Colors.white),
                                    ))))
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 7.0,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ],
                          ),
                          child: BorderContainerWidget(
                              h: 400,
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        Image.asset('assets/images/home.png')),
                              )),
                        )
                      ],
                    ),
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BorderContainerWidget(
                  h: 400,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/customer.png')),
                  )),
            ],
          ),
          Container(
            color: Colors.grey[100],
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '서비스 개발의 시작',
                  textAlign: TextAlign.center,
                  style: shortTitleStyle,
                ),
                const Gap(30),
                const Text('계속 많아지고 사용하기 불편한 선결제 장부\n편하게 사용할 수 없을까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    )),
                const Gap(50),
                const Text('...직접 만들자',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Container(
            height: 500,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이런점이 불편했습니다',
                  textAlign: TextAlign.center,
                  style: whiteShortTitleStyle,
                ),
                const Gap(30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                        child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                  child: Text(
                                '고객 찾기 힘듦',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ))),
                    Card(
                        child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                  child: Text(
                                '귀찮은 잔액 계산',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ))),
                    Card(
                        child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                  child: Text(
                                '어려운 관리',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ))),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: Get.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: SizedBox(
                  width: 800,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '찾기 쉽게',
                              textAlign: TextAlign.center,
                              style: shortTitleStyle,
                            ),
                            const Gap(20),
                            Text(
                              '검색으로 한번에\n찾을 수 있어요.',
                              style: titleStyle,
                            ),
                            const Gap(20),
                            Text(
                              '3초만에 찾아 시간을 절약해요',
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            const Gap(60),
                            BorderContainerWidget(
                                color: Colors.grey[100],
                                w: 300,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('단골 에이님'),
                                      Icon(Icons.search)
                                    ],
                                  ),
                                )),
                            const Gap(20),
                            BorderContainerWidget(
                                color: Colors.grey[100],
                                w: 300,
                                h: 200,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '단골 에이님',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        '34,000P',
                                        style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: Get.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: SizedBox(
                  width: 800,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '계산 쉽게',
                              textAlign: TextAlign.center,
                              style: shortTitleStyle,
                            ),
                            const Gap(20),
                            Text(
                              '잔액을 자동으로 계산.',
                              style: titleStyle,
                            ),
                            const Gap(20),
                            Text(
                              '더이상 계산기 두드릴 필요 없어요',
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const Gap(200),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Gap(60),
                            BorderContainerWidget(
                              h: 300,
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '충전',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          '100,000',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '사용',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '37,000',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '사용',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '24,000',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '사용',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '12,000',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Gap(30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '잔액',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '172,000',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[100],
            width: Get.width,
            height: 500,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: SizedBox(
                    width: 800,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '무료로 시작해보세요',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Gap(30),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: BorderContainerWidget(
                              color: sgColor,
                              child: const SizedBox(
                                  width: 200,
                                  child: Center(
                                      child: Text(
                                    '시작하기',
                                    style: TextStyle(color: Colors.white),
                                  )))),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
