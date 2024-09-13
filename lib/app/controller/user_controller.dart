import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/instroduceLayout.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/introduceScreen.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';

import 'package:jangboo_flutter/app/data/model/user_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class UserController extends GetxController {
  static UserController get to => Get.find();
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() async {
    super.onInit();
    // checkInitialAuthState();
    // setupAuthListener();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      // Fetch user data from Supabase
      final userData = await Supabase.instance.client
          .from('user')
          .select()
          .eq('uid', currentUser.id);

      if (userData != null) {
        user.value = UserModel.fromJson(userData.first);
        print('user value = ${user.value}');
      }
    }
  }

  Future signUp({
    required String email,
    required String password,
  }) async {
    try {
      var key = utf8.encode(password);

      var passwordHash = sha256.convert(key).toString();
      int firstInt = Random().nextInt(19); // 0 ~ 99 랜덤
      int lastInt = Random().nextInt(19); // 0 ~ 99 랜덤
      var firstName = [
        '사랑하는',
        '귀여운',
        '멋진',
        '놀라운',
        '훌륭한',
        '조용한',
        '즐거운',
        '매력적인',
        '유쾌한',
        '달콤한',
        '신선한',
        '활발한',
        '밝은',
        '영리한',
        '용감한',
        '평화로운',
        '기묘한',
        '재미있는',
        '강인한',
        '아름다운'
      ];

      var lastName = [
        '체리',
        '수박',
        '토마토',
        '사과',
        '바나나',
        '포도',
        '오렌지',
        '키위',
        '망고',
        '파인애플',
        '복숭아',
        '자몽',
        '레몬',
        '라임',
        '블루베리',
        '딸기',
        '귤',
        '메론',
        '코코넛',
        '파파야'
      ];

      var randomName = firstName[firstInt] + lastName[lastInt];

      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;
      var uuid = const Uuid().v4();
      if (user != null) {
        await supabase.from('user').insert({
          'phone': null,
          'name': randomName,
          'email': email,
          'password': passwordHash,
          'store_name': '내 가게',
          'uid': user.id,
        }).select('*');
        const storage = FlutterSecureStorage();
        await storage.write(key: 'uid', value: uuid);

        await loadUserData();
      }

      return 'seccess';
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  // handleAuthChanged(firebaseUser) async {
  //   //get user data from firestore
  //   if (firebaseUser?.uid != null) {
  //     firestoreUser.bindStream(streamFirestoreUser());
  //   }
  //   if (firebaseUser == null) {
  //     Get.offAll(() => LoginPage());
  //   } else {
  //     Get.offAll(() => HomePage());
  //   }
  // }

  // //Streams the firestore user from the firestore collection
  // Stream<UserModel> streamFirestoreUser() {
  //   print('streamFirestoreUser()');

  //   return firebaseFirestore
  //       .doc('/users/${firebaseUser.value!.uid}')
  //       .snapshots()
  //       .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  // }

  // // Sign out
  Future<void> signOu() async {
    // Create storage
    const storage = FlutterSecureStorage();
    // Read value
    final value = await storage.deleteAll();
    return supabase.auth.signOut();
  }

  Future changeCetificationPassword(String afterPassword) async {
    await supabase.from('user').update(
        {'certification_password': afterPassword}).eq('uid', user.value!.uid);
    await loadUserData();
  }

  Future changeAddRatio(int afterRatio) async {
    await supabase
        .from('user')
        .update({'add_ratio': afterRatio}).eq('uid', user.value!.uid);
    await loadUserData();
  }
}
