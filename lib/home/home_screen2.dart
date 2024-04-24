import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/customer/create_new_customer_screen.dart';
import 'package:jangboo_flutter/customer/customer_screen.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../const/const.dart';

class HomeScreen2 extends StatefulWidget {
  HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('온라인 장부'),
        centerTitle: false,
        actions: [
          Text('홈'),
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
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          Icon(Icons.search),
                          SizedBox(
                            width: 5,
                          ),
                          Text('이름, 전화번호, 바코드로 검색하세요'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('1'),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: supabase
                            .from('customer')
                            .stream(primaryKey: ['id']),
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
                          final cards = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cards.length + 1,
                            itemBuilder: (context, index) {
                              final customer_index = index - 1;
                              if (index == 0) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(() => CreateNewCustomerScreen());
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 140,
                                    decoration: BoxDecoration(
                                        color: sgColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '새로 등록',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
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
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      CustomerModel customer =
                                          CustomerModel.fromJson(
                                              cards![customer_index]);
                                      Get.to(() =>
                                          CustomerScreen(customer: customer));
                                    },
                                    child: Container(
                                      width: 250,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star_rounded,
                                                      color:
                                                          cards[customer_index]
                                                                  ['favorite']
                                                              ? Colors.amber
                                                              : Colors
                                                                  .grey[300],
                                                    ),
                                                    Gap(3),
                                                    Text(
                                                      cards[index - 1]['name'],
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.grey,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                            Text(
                                                '${cards[customer_index]['balance']}원',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey[700])),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
