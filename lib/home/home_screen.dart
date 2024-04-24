import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/customer/create_new_customer_screen.dart';
import 'package:jangboo_flutter/customer/customer_screen.dart';
// import 'package:jangboo_flutter/customer/customer_screen2.dart';
import 'package:jangboo_flutter/customer/customer_screen3.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../const/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CustomerModel> filteredItems = <CustomerModel>[].obs;
  final showSearchScreen = false.obs;
  final String _query = '';
  var userId = '';

  @override
  void initState() {
    filteredItems.clear();
    // userId = supabase.auth.currentUser!.id;
    super.initState();
  }

  final customerCtr = Get.put(CustomerContentController());
  TextEditingController searchCtr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('온라인 장부'),
        centerTitle: false,
        actions: const [
          Text('홈'),

          // Text(userId)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 1000,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: TextField(
                            controller: searchCtr,
                            onChanged: (_) {
                              filteredItems.clear();
                              for (int i = 0;
                                  i < contentCtr.customerList.length;
                                  i++) {
                                if (contentCtr.customerList[i].name
                                    .toString()
                                    .contains(_)) {
                                  filteredItems.add(contentCtr.customerList[i]);
                                  showSearchScreen.value = true;
                                } else if (contentCtr.customerList[i].phone
                                        .toString()
                                        .contains(_) ||
                                    contentCtr.customerList[i].barcode
                                        .toString()
                                        .contains(_)) {
                                  filteredItems.add(contentCtr.customerList[i]);
                                  showSearchScreen.value = true;
                                }
                                // if (contentCtr.customerList[i].barcode
                                //         .toString() ==
                                //     _) {
                                //   print(i);
                                //   filteredItems.add(contentCtr.customerList[i]);
                                // }
                              }

                              print(filteredItems);
                              if (_ == '') {
                                filteredItems.clear();
                              }
                              setState(() {});
                            },
                          )),
                          const Text('이름, 전화번호, 바코드로 검색하세요'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Obx(() {
                if (!showSearchScreen.value) {
                  return StreamBuilder<List<Map<String, dynamic>>>(
                      stream:
                          supabase.from('customer').stream(primaryKey: ['id']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('데이터가 없습니다'),
                            );
                          }
                        }
                        customerCtr.customerList.clear();
                        for (var element in snapshot.data!) {
                          customerCtr.customerList
                              .add(CustomerModel.fromJson(element));
                        }
                        customerCtr.customerList.sort((a, b) => b.favorite
                            .toString()
                            .compareTo(a.favorite.toString()));

                        return Obx(() => ResponsiveGridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: customerCtr.customerList.length + 1,
                              gridDelegate: const ResponsiveGridDelegate(
                                  minCrossAxisExtent: 200,
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                final customerIndex = index - 1;
                                if (index == 0) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(() => CreateNewCustomerScreen());
                                    },
                                    child: Container(
                                      width: 250,
                                      height: 140,
                                      decoration: const BoxDecoration(
                                          color: sgColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '새로 등록',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return HomeCard(
                                    data:
                                        customerCtr.customerList[customerIndex],
                                    onTap: () {
                                      Get.to(() => CustomerScreen3(
                                          customer: customerCtr
                                              .customerList[customerIndex]));
                                    },
                                  );
                                }
                              },
                            ));
                      });
                } else {
                  return ResponsiveGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const ResponsiveGridDelegate(
                          minCrossAxisExtent: 200,
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return HomeCard(
                          data: filteredItems[index],
                          onTap: () async {
                            var clickIndex = contentCtr.customerList.indexWhere(
                                (element) =>
                                    element.id ==
                                    filteredItems[index]
                                        .id); // ctr의 list에서 값을 넘기기 위해 같은 아이디 값을 구함

                            Get.to(() => CustomerScreen3(
                                customer: contentCtr
                                    .customerList[clickIndex]))?.then((value) {
                              // filteredItems.clear();
                              searchCtr.clear();
                            });
                            showSearchScreen.value = false;

                            // 이렇게 안하고 filteredItems를 초기화 하면 (검색 화면을 초기화 하기 위해)
                            // 디테일 화면으로 넘어가지않음

                            // setState(() {});
                          },
                        );
                      });
                }
              }),

              // StreamBuilder<List<Map<String, dynamic>>>(
              //     stream: supabase.from('customer').stream(primaryKey: ['id']),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       } else {
              //         if (snapshot.data!.isEmpty) {
              //           return const Center(
              //             child: Text('데이터가 없습니다'),
              //           );
              //         }
              //       }

              //       final cards = snapshot.data!;
              //       return ResponsiveGridView.builder(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         itemCount: cards.length + 1,
              //         gridDelegate: const ResponsiveGridDelegate(
              //             minCrossAxisExtent: 200,
              //             maxCrossAxisExtent: 300,
              //             childAspectRatio: 2,
              //             mainAxisSpacing: 10,
              //             crossAxisSpacing: 10),
              //         itemBuilder: (context, index) {
              //           final customerIndex = index - 1;
              //           if (index == 0) {
              //             return InkWell(
              //               onTap: () {
              //                 Get.to(() => CreateNewCustomerScreen());
              //               },
              //               child: Container(
              //                 width: 250,
              //                 height: 140,
              //                 decoration: const BoxDecoration(
              //                     color: sgColor,
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(10))),
              //                 child: const Padding(
              //                   padding: EdgeInsets.all(15.0),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Text(
              //                             '새로 등록',
              //                             style: TextStyle(
              //                                 fontSize: 20,
              //                                 fontWeight: FontWeight.bold,
              //                                 color: Colors.white),
              //                           ),
              //                           Icon(
              //                             Icons.arrow_forward_ios_rounded,
              //                             color: Colors.white,
              //                             size: 18,
              //                           )
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             );
              //           } else {
              //             return InkWell(
              //               onTap: () {
              //                 CustomerModel customer =
              //                     CustomerModel.fromJson(cards[customerIndex]);

              //                 Get.to(() => CustomerScreen2(customer: customer));
              //               },
              //               child: Container(
              //                 width: 250,
              //                 height: 140,
              //                 decoration: BoxDecoration(
              //                     color: Colors.grey[100],
              //                     borderRadius: const BorderRadius.all(
              //                         Radius.circular(10))),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(10.0),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceAround,
              //                     children: [
              //                       Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Row(
              //                             children: [
              //                               Icon(
              //                                 Icons.star_rounded,
              //                                 color: cards[customerIndex]
              //                                         ['favorite']
              //                                     ? Colors.amber
              //                                     : Colors.grey[300],
              //                               ),
              //                               const Gap(3),
              //                               Text(
              //                                 cards[index - 1]['name'],
              //                                 style: const TextStyle(
              //                                     fontSize: 20,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ],
              //                           ),
              //                           const Icon(
              //                             Icons.arrow_forward_ios_rounded,
              //                             color: Colors.grey,
              //                             size: 14,
              //                           )
              //                         ],
              //                       ),
              //                       Text('${cards[customerIndex]['balance']}원',
              //                           style: TextStyle(
              //                               fontSize: 20,
              //                               color: Colors.grey[700])),
              //                       const Text(
              //                         '최근 사용 24년 1월 10일',
              //                         style: TextStyle(
              //                             fontSize: 12, color: Colors.grey),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             );
              //           }
              //         },
              //       );
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  HomeCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  CustomerModel data;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 140,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: data.favorite ? Colors.amber : Colors.grey[300],
                      ),
                      const Gap(3),
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 14,
                  )
                ],
              ),
              Text('${data.balance}원',
                  style: TextStyle(fontSize: 20, color: Colors.grey[700])),
              const Text(
                '최근 사용 24년 1월 10일',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
