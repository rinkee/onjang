import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/navigation_controller.dart';
import 'package:jangboo_flutter/controller/screen_controller.dart';
import 'package:jangboo_flutter/customer/customer_desktop.dart';
import 'package:jangboo_flutter/customer/customer_screen.dart';
import 'package:jangboo_flutter/customer/customer_screen2.dart';
import 'package:jangboo_flutter/customer/customer_screen_desktop.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';

final _authCtr = Get.put(AuthController());

class CustomerCard extends StatelessWidget {
  CustomerCard({super.key, required this.favorite});
  final bool favorite;
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('customer')
            .stream(primaryKey: ['id'])
            .eq('user_id', _authCtr.uid.value)
            .order('favorite', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // customerCtr.isLoading.value = true;
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // customerCtr.isLoading.value = false;
            return const Center(child: Text('데이터가 없습니다'));
          }

          List<CustomerModel> customers = snapshot.data!
              .map((json) => CustomerModel.fromJson(json))
              .toList();
          customerCtr.customerList.clear();
          customerCtr.customerList.addAll(customers);

          List<CustomerModel> favoriteList = [];
          for (int i = 0; i < customers.length; i++) {
            if (customers[i].favorite == true) {
              favoriteList.add(customers[i]);
            }
          }
          print(favoriteList);

          return Obx(() {
            if (customerCtr.filteredItems.isEmpty &&
                customerCtr.showSearchScreen.value) {
              return const Column(
                children: [
                  Gap(50),
                  Icon(Icons.warning_rounded, color: Colors.grey),
                  Gap(5),
                  Text('검색결과가 없어요',
                      style: TextStyle(
                          color: sgColor, fontWeight: FontWeight.bold)),
                  Text('검색하신 단어를 확인해주세요', style: TextStyle(color: Colors.grey)),
                ],
              );
            } else {
              // filteredItems가 비어있지 않거나 showSearchScreen이 false인 경우

              var listToShow = customerCtr.filteredItems.isEmpty
                  ? customers
                  : customerCtr.filteredItems;
              if (favorite) {
                return kCustomerCard(list: favoriteList);
              } else {
                return kCustomerCard(list: listToShow);
              }
              // return kCustomerCard(list: listToShow);
            }
          });
        },
      ),
    );
  }
}

class kCustomerCard extends StatefulWidget {
  const kCustomerCard({
    super.key,
    required this.list,
  });

  final List<CustomerModel> list;

  @override
  State<kCustomerCard> createState() => _kCustomerCardState();
}

class _kCustomerCardState extends State<kCustomerCard> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenCtr = Get.put(ScreenController());

    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: GridView.builder(
            itemCount: widget.list.length,
            shrinkWrap: true,
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 120,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) => kBtn(
                  hoverColor: Colors.grey[300],
                  bgColor: Colors.white,
                  onTap: () {
                    var customer = widget.list[index];
                    print(customer.name);
                    final naviCtr = Get.put(NavigationController());
                    final customerCtr = Get.put(CustomerContentController());
                    customerCtr.selectCustomerList.clear();
                    customerCtr.selectCustomerList.add(customer);
                    customerCtr.currentCustomerIndex = index;
                    customerCtr.fucSetUpActionButton(balance: customer.balance);

                    customerCtr.filteredItems.clear();
                    customerCtr.showSearchScreen.value = false;

                    Get.to(const CustomerDesktop());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        widget.list[index].favorite == true
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ],
                              )
                            : const Icon(
                                Icons.star_rounded,
                                color: Colors.transparent,
                                size: 20,
                              ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.list[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: cardTitle,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      f.format(widget.list[index].balance),
                                      style: cardBalance,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
