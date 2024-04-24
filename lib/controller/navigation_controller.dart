import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MenuType {
  Home(state: 'home', title: '홈', icon: Icons.home),
  Customer(state: 'customer', title: '고객', icon: Icons.people_alt_outlined),

  Setting(state: 'setting', title: '내 정보', icon: Icons.settings);

  final state;
  final title;
  final icon;
  const MenuType({
    required this.state,
    required this.title,
    required this.icon,
  });
}

enum CustomerChildMenuType {
  Home(idx: 0, state: 'home', title: '홈', icon: Icons.home),
  Card(idx: 0, state: 'customer', title: '카드', icon: Icons.add_card_rounded),
  Record(idx: 0, state: 'customer', title: '기록', icon: Icons.list_rounded),
  Setting(idx: 0, state: 'setting', title: '설정', icon: Icons.settings);

  final idx;
  final state;
  final title;
  final icon;
  const CustomerChildMenuType({
    required this.idx,
    required this.state,
    required this.title,
    required this.icon,
  });
}

class NavigationController extends GetxController {
  var currentMenu = MenuType.Home.obs;
  var currentInde = 0.obs; // 현재 선택된 메뉴 인덱스를 관찰 가능한 상태로 선언
  var customerChildMenu = CustomerChildMenuType.Home.obs;
  var customerChildMenuIndex = 0.obs;
}
