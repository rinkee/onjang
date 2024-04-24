import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/k_icon_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/new_balance_add_btn.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';
import 'package:jangboo_flutter/common_widget/number_pad/number_pad.dart';
import 'package:jangboo_flutter/common_widget/search/k_search_bar.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/screen_controller.dart';
import 'package:jangboo_flutter/customer/customer_screen_desktop.dart';
import 'package:jangboo_flutter/home/home_screen_desktop.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';

class DesktopLayout extends StatelessWidget {
  DesktopLayout({super.key, required this.child});

  final Widget child;
  final screenCtr = Get.put(ScreenController());

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1400,
      child: Scaffold(
        appBar: AppBar(),
        drawer: Container(
          width: Get.width / 6,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                  child: Center(child: Text('텐퍼센트 금남로점')),
                ),
                const Gap(20),
                KIconBtn(
                  onTap: () {
                    screenCtr.changeScreen(ContentType.Home);
                  },
                  title: '홈',
                  icon: Icons.home,
                  select: true,
                ),
                // const Gap(10),
                KIconBtn(
                    onTap: () {
                      screenCtr.changeScreen(ContentType.Customer);
                    },
                    title: '고객',
                    icon: Icons.people_alt_rounded),
                // const Gap(10),
                KIconBtn(onTap: () {}, title: '홈', icon: Icons.home),
                const Spacer(),
                KIconBtn(onTap: () {}, title: '홈', icon: Icons.home),
                const Gap(10),
                KIconBtn(onTap: () {}, title: '홈', icon: Icons.home),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //menu
                  // Container(
                  //   color: Colors.white,
                  //   width: Get.width / 6,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(20),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const SizedBox(
                  //           height: 60,
                  //           child: Center(child: Text('텐퍼센트 금남로점')),
                  //         ),
                  //         const Gap(20),
                  //         KIconBtn(
                  //           onTap: () {
                  //             screenCtr.changeScreen(ContentType.Home);
                  //           },
                  //           title: '홈',
                  //           icon: Icons.home,
                  //           select: true,
                  //         ),
                  //         // const Gap(10),
                  //         KIconBtn(
                  //             onTap: () {
                  //               screenCtr.changeScreen(ContentType.Customer);
                  //             },
                  //             title: '고객',
                  //             icon: Icons.people_alt_rounded),
                  //         // const Gap(10),
                  //         KIconBtn(onTap: () {}, title: '홈', icon: Icons.home),
                  //         const Spacer(),
                  //         KIconBtn(onTap: () {}, title: '홈', icon: Icons.home),
                  //         const Gap(10),
                  //         KIconBtn(onTap: () {}, title: '홈', icon: Icons.home),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // main content
                  const Gap(20),
                  // Expanded(
                  //   child: Obx(() {
                  //     if (screenCtr.currentScreen.value == ContentType.Home) {
                  //       return const Home();
                  //     }
                  //     if (screenCtr.currentScreen.value ==
                  //         ContentType.Customer) {
                  //       final customerCtr =
                  //           Get.put(CustomerContentController());
                  //       return Text(customerCtr.customerList[0].name);
                  //     }

                  //     return const Text('null');
                  //   }),
                  // ),
                  Expanded(child: child),

                  const Gap(20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchCtr = TextEditingController();
  final customerCtr = Get.put(CustomerContentController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCtr.addListener(() {
      print(searchCtr.text);
      customerCtr.fucSearchCustomer(searchCtr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('home'),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Gap(50),
              Row(
                children: [
                  const KNewBalanceAddBtn(),
                  const Gap(20),
                  KSearchBar(
                    textCtr: searchCtr,
                  )
                ],
              ),
              const Gap(20),
              CustomerCard(
                favorite: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Gap(100),
              SizedBox(
                height: 300,
                child: NumberPad(
                  textCtr: searchCtr,
                ),
              ),
              const Gap(20),
              kBtn(
                bgColor: sgColor,
                child: const Center(
                    child: Text(
                  '검색하기',
                  style: TextStyle(color: Colors.white),
                )),
                onTap: () {
                  searchCtr.text = '1';
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
