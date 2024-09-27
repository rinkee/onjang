import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/web/demo/demo_home.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  TextStyle titleStyle = const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  TextStyle titleWhiteStyle = const TextStyle(
      height: 1.2,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.black);

  TextStyle subTitleStyle = const TextStyle(
    fontSize: 20,
    height: 1.3,
  );

  TextStyle shortTitleStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: sgColor);

  TextStyle whiteShortTitleStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

  Timer? timer;
  var showMainImage = 'assets/images/showLedger.gif';

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {}

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Text('테블릿');
        }
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              titleSpacing: 0.0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      '모두의 장부',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          context.goNamed(Routes.login);
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(100),
                    AspectRatio(
                      aspectRatio: 1920 / 1085,
                      child: BorderContainerWidget(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  showMainImage,
                                  fit: BoxFit.fill,
                                )),
                          )),
                    ),
                    Gap(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '효율성이 중요한 사장님들을 위한',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '선결제 장부 서비스',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Gap(150),
                    Text(
                      '이런 장점이 있어요',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Gap(10),
                    TellGoodThings(
                      title: '검색 기능',
                      description: '일일이 찾아야 했던 장부를 클릭 몇 번으로 검색해서 사용해보세요',
                    ),
                    TellGoodThings(
                      title: '자동 계산',
                      description: '잔액이 자동으로 계산되어 편리합니다',
                    ),
                    TellGoodThings(
                      title: '추가 충전',
                      description: '일정 퍼센트 추가 충전으로 고객님들께 할인 혜택을 드릴 수 있습니다',
                    ),
                    TellGoodThings(
                      title: '합리적인 가격',
                      description: '월 1,000원부터 시작하는 플랜으로 부담 없이 적용할 수 있습니다',
                    ),
                    Gap(150),
                    Text(
                      '어떤 서비스인지 궁금해요',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Gap(5),
                    Text(
                      '체험하기를 클릭해 어떤 서비스인지 확인해보세요',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    Text(
                      '(서비스는 태블릿,PC화면에 최적화 되어있습니다)',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonWidget(
                            w: 200,
                            bgColor: Colors.blue,
                            hoverColor: Colors.blue[600],
                            onTap: () {
                              // Get.toNamed(Routes.demoHome);
                              final _demoCtr = Get.put(DemoController());
                              _demoCtr.updateCompanyList();
                              context.goNamed(Routes.demohome);
                            },
                            child: const Text(
                              '체험하기',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ],
                    ),
                    Gap(150),
                    Text(
                      '플랜',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Table(
                                border: TableBorder.all(
                                    color: const Color.fromARGB(
                                        255, 234, 234, 234)),
                                children: [
                                  TableRow(
                                    children: [
                                      TableText(
                                        text: '플랜명',
                                      ),
                                      TableText(
                                        text: '장부1000',
                                      ),
                                      TableText(
                                        text: '장부3000',
                                      ),
                                      TableText(
                                        text: '장부5000',
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableText(
                                        text: '고객 등록 수',
                                      ),
                                      TableText(
                                        text: '5명',
                                      ),
                                      TableText(
                                        text: '무제한',
                                      ),
                                      TableText(
                                        text: '무제한',
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
                                      TableText(
                                        text: 'X',
                                      ),
                                      TableText(
                                        text: 'X',
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableText(
                                        text: '가격 (월)',
                                      ),
                                      TableText(
                                        text: '1000원',
                                      ),
                                      TableText(
                                        text: '3000원',
                                      ),
                                      TableText(
                                        text: '5000원',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleSpacing: 0.0,
            title: MaxWidthBox(
              maxWidth: 1200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      '모두의 장부',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          context.goNamed(Routes.login);
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: ListView(
            children: [
              TwoContent(
                flex: 2,
                // bgColor: Colors.black,
                left: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '이제 노트에\n적지마세요',
                          style: titleWhiteStyle,
                        ),
                        const Gap(20),
                        Text(
                          '클릭 몇번이면 검색, 계산, 알림까지\n장부를 효율적으로 관리해보세요',
                          style: subTitleStyle,
                        ),
                        const Gap(30),
                        // Container(
                        //   width: 150,
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.3),
                        //           spreadRadius: 1,
                        //           blurRadius: 5.0,
                        //           offset: const Offset(
                        //               0, 5), // changes position of shadow
                        //         ),
                        //       ],
                        //       color: Colors.blue,
                        //       borderRadius: const BorderRadius.all(
                        //           Radius.circular(10))),
                        //   child: const Center(
                        //     child: Text(
                        //       '시작하기',
                        //       style: TextStyle(
                        //           fontSize: 18,
                        //           height: 1,
                        //           color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                        Row(
                          children: [
                            ButtonWidget(
                                w: 150,
                                bgColor: Colors.blue,
                                hoverColor: Colors.blue[600],
                                onTap: () {
                                  // Get.toNamed(Routes.demoHome);
                                  final _demoCtr = Get.put(DemoController());
                                  _demoCtr.updateCompanyList();
                                  context.goNamed(Routes.demohome);
                                },
                                child: const Text(
                                  '체험하기',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                            const Gap(10),
                            ButtonWidget(
                                bgColor: Colors.white,
                                w: 150,
                                onTap: () {
                                  context.goNamed(Routes.login);
                                },
                                child: const Text(
                                  '시작하기',
                                  style: TextStyle(fontSize: 18),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
                right: [
                  AspectRatio(
                    aspectRatio: 1920 / 1085,
                    child: BorderContainerWidget(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                showMainImage,
                                fit: BoxFit.fill,
                              )),
                        )),
                  )
                ],
              ),
              // OneContent(bgColor: Colors.grey[100], content: [
              //   Text(
              //     '많은 사장님들이 이런 걱정을 하세요',
              //     style: titleWhiteStyle,
              //   ),
              //   const Gap(30),
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       BorderContainerWidget(
              //           w: 350,
              //           h: 300,
              //           child: Padding(
              //             padding: const EdgeInsets.all(70.0),
              //             child: Image.asset('assets/images/worriedMenBG.png'),
              //           )),
              //       const Gap(20),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           WorryText('노트를 일일이 찾기 귀찮아요...'),
              //           WorryText('장부가 너무 많아서 관리가 힘들어요...'),
              //           WorryText('잔액 계산이 너무 귀찮아요...'),
              //           WorryText('사용하기 편리한 장부가 없어요...'),
              //         ],
              //       ),
              //     ],
              //   )
              // ]),
              // TwoContent(
              //   left: [
              //     Container(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             '찾기 쉽게',
              //             textAlign: TextAlign.center,
              //             style: shortTitleStyle,
              //           ),
              //           const Gap(20),
              //           Text(
              //             '검색으로 한번에\n찾을 수 있어요.',
              //             style: titleStyle,
              //           ),
              //           const Gap(20),
              //           Text(
              //             '3초만에 찾아 시간을 절약해요',
              //             style: subTitleStyle,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              //   right: [
              //     Container(
              //       child: Column(
              //         children: [
              //           const Gap(60),
              //           BorderContainerWidget(
              //               color: Colors.grey[100],
              //               w: 300,
              //               child: const Padding(
              //                 padding: EdgeInsets.symmetric(horizontal: 20),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [Text('단골 에이님'), Icon(Icons.search)],
              //                 ),
              //               )),
              //           const Gap(20),
              //           BorderContainerWidget(
              //               color: Colors.grey[100],
              //               w: 300,
              //               h: 200,
              //               child: const Padding(
              //                 padding: EdgeInsets.symmetric(
              //                     horizontal: 20, vertical: 20),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       '단골 에이님',
              //                       style: TextStyle(
              //                           fontSize: 28,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     Spacer(),
              //                     Text(
              //                       '34,000P',
              //                       style: TextStyle(
              //                           fontSize: 36,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                   ],
              //                 ),
              //               ))
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              // TwoContent(
              //   bgColor: Colors.grey[100],
              //   left: [
              //     Container(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             '계산 쉽게',
              //             textAlign: TextAlign.center,
              //             style: shortTitleStyle,
              //           ),
              //           const Gap(20),
              //           Text(
              //             '잔액을 자동으로 계산.',
              //             style: titleStyle,
              //           ),
              //           const Gap(20),
              //           Text(
              //             '더이상 계산기 두드릴 필요 없어요',
              //             style: subTitleStyle,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              //   right: [
              //     BorderContainerWidget(
              //       w: 400,
              //       h: 300,
              //       child: Padding(
              //         padding: const EdgeInsets.all(20.0),
              //         child: Column(
              //           children: [
              //             AddMoney(
              //               money: '100,000P',
              //             ),
              //             MinusMoney(money: '4,000P'),
              //             MinusMoney(money: '23,000P'),
              //             MinusMoney(money: '33,000P'),
              //             const Divider(),
              //             const Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   '잔액',
              //                   style: TextStyle(
              //                       fontSize: 20, fontWeight: FontWeight.bold),
              //                 ),
              //                 Text(
              //                   '172,000P',
              //                   style: TextStyle(
              //                       fontSize: 30, fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // TwoContent(
              //   left: [
              //     Container(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             '지원 예정',
              //             textAlign: TextAlign.center,
              //             style: shortTitleStyle,
              //           ),
              //           const Gap(20),
              //           Text(
              //             '남은 잔액을 고객님께 전달해주세요',
              //             style: titleStyle,
              //           ),
              //           const Gap(20),
              //           Text(
              //             '3초만에 찾아 시간을 절약해요',
              //             style: subTitleStyle,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              //   right: [
              //     BorderContainerWidget(
              //       w: 500,
              //       h: 300,
              //       color: Colors.amber,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           Container(
              //               width: 400,
              //               height: 250,
              //               decoration: BoxDecoration(
              //                   color: Colors.grey[100],
              //                   borderRadius: const BorderRadius.only(
              //                       topLeft: Radius.circular(19),
              //                       topRight: Radius.circular(19))),
              //               child: const Padding(
              //                 padding: EdgeInsets.symmetric(
              //                     horizontal: 20, vertical: 20),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       '단골 에이님\n남은 포인트는',
              //                       style: TextStyle(
              //                           fontSize: 28,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     Spacer(),
              //                     Text(
              //                       '34,000P',
              //                       style: TextStyle(
              //                           fontSize: 40,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     Text(
              //                       '입니다',
              //                       style: TextStyle(
              //                           fontSize: 28,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                   ],
              //                 ),
              //               ))
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              // OneContent(bgColor: Colors.grey[100], content: [
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 100),
              //     child: Column(
              //       children: [
              //         const Text(
              //           '요금',
              //           style: TextStyle(color: Colors.grey, fontSize: 24),
              //         ),
              //         const Gap(10),
              //         const Text(
              //           '하루 이용료 단돈 1,000원',
              //           style: TextStyle(
              //             fontSize: 50,
              //             fontWeight: FontWeight.bold,
              //             height: 1.2,
              //           ),
              //         ),
              //         const Gap(10),
              //         Text(
              //           '월 30,000원, 하루 1,000원에 부담 없이 이용 할 수 있어요',
              //           style: TextStyle(color: Colors.grey[700], fontSize: 24),
              //         ),
              //         const Gap(50),
              //         GestureDetector(
              //           onTap: () {
              //             context.goNamed(Routes.login);
              //           },
              //           child: SizedBox(
              //             width: 500,
              //             height: 120,
              //             child: BorderContainerWidget(
              //                 color: sgColor,
              //                 child: const Center(
              //                     child: Text(
              //                   '하루 천원에 시작하기',
              //                   style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 24,
              //                       fontWeight: FontWeight.bold),
              //                 ))),
              //           ),
              //         )
              //       ],
              //     ),
              //   )
              // ])
            ],
          ),
        );

        // if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
        //   return Container(color: Colors.red);
        // }

        // if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
        //   return Container(color: Colors.yellow);
        // }

        // return Container(color: Colors.purple);
      },
    );
  }

  Text WorryText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 24, color: Colors.grey[700]),
    );
  }
}

class TellGoodThings extends StatelessWidget {
  const TellGoodThings({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap(10),
        Text(
          description,
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

class AddMoney extends StatelessWidget {
  AddMoney({
    super.key,
    required this.money,
  });
  String money;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.add),
            const Gap(5),
            Text(
              money,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Gap(10),
      ],
    );
  }
}

class MinusMoney extends StatelessWidget {
  MinusMoney({
    super.key,
    required this.money,
  });
  String money;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.remove_rounded),
            const Gap(5),
            Text(
              money,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Gap(10),
      ],
    );
  }
}

class OneContent extends StatelessWidget {
  OneContent({super.key, this.bgColor, required this.content});

  Color? bgColor;
  List<Widget> content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: MaxWidthBox(
        maxWidth: 1200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Expanded(
              child: Container(
                  child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: content,
            ),
          ))),
        ),
      ),
    );
  }
}

class TwoContent extends StatelessWidget {
  TwoContent(
      {super.key,
      this.flex,
      this.bgColor,
      required this.left,
      required this.right});

  Color? bgColor;
  List<Widget> left;
  List<Widget> right;
  int? flex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      color: bgColor,
      child: MaxWidthBox(
        maxWidth: 1200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                      child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: left,
                ),
              ))),
              Expanded(
                  flex: flex ?? 1,
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: right,
                    ),
                  ))),
            ],
          ),
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
