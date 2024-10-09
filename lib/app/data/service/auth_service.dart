import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthService extends GetxService {
  final _supabase = Supabase.instance.client;

  late final GetStorage _storage;

  Future<AuthService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }

  String? get userId => _storage.read('user_id');

  Future<bool> isLoggedIn() async {
    return userId != null;
  }

  Future<User?> getCurrentUser() async {
    if (await isLoggedIn()) {
      return _supabase.auth.currentUser;
    }
    return null;
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write('user_id', userId);
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
        // const storage = FlutterSecureStorage();
        // await storage.write(key: 'uid', value: uuid);
        saveUserId(user.id);
        final _userCtr = Get.find<UserController>();
        await _userCtr.loadUserData();
      }

      return 'seccess';
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future logIn({required String email, required String password}) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;

      if (session == null) {
        return false;
      }
      await saveUserId(session.user.id);
      UserController _authCtr = Get.find<UserController>();
      await _authCtr.loadUserData();
      // Get.offNamed(Routes.home);
      return true;

      // await fetchUserData(session.user.id);
      // Get.offAll(const LoginScreen());

      // var key = utf8.encode(password);
      // var passwordHash = sha256.convert(key).toString();

      // await supabase
      //     .from('user')
      //     .select()
      //     .eq('email', email)
      //     .eq('password', passwordHash)
      //     .then((value) {
      //   print(value);
      //   if (value.isNotEmpty) {
      //     // print(value[0]['uid']);
      //     fetchUserData(value[0]['uid']);
      //     Get.offAll(() => const HomeScreenDesktop());
      //   }
      // });

      // return res;
    } catch (e) {
      print('login E : {$e}');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.remove('user_id');
    await _supabase.auth.signOut();
    // Get.offAllNamed(Routes.introduce);
  }
}
