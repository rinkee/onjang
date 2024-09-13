import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final _supabase = Supabase.instance.client;
  final _storage = GetStorage();

  Future<AuthService> init() async {
    await GetStorage.init();
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

  Future logIn({required String email, required String password}) async {
    try {
      print('login');
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;

      if (session == null) {
        return;
      }
      await saveUserId(session.user.id);
      UserController _authCtr = Get.find<UserController>();
      await _authCtr.loadUserData();
      Get.offNamed(Routes.Home);
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
      return e;
    }
  }

  Future<void> logout() async {
    await _storage.remove('user_id');
    await _supabase.auth.signOut();
    Get.offAllNamed(Routes.Introduce);
  }
}
