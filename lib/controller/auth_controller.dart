import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';
import 'package:jangboo_flutter/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/login/login_screen.dart';
import 'package:jangboo_flutter/mainScreen.dart';
import 'package:jangboo_flutter/model/user_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  // Rxn<User> firebaseUser = Rxn<User>();
  // Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  // RxBool isLoggedIn = false.obs;
  final Rx<UserModel?> userData = Rx<UserModel?>(null);
  final userName = ''.obs;
  final storeName = ''.obs;
  final uid = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _checkLogin();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // _setupAuthListener();
    _checkLogin();
    //run every time auth state changes
    // ever(firebaseUser, handleAuthChanged);
    // firebaseUser.bindStream(user);
  }

  _checkLogin() async {
    // Create storage
    const storage = FlutterSecureStorage();
    // Read value
    final value = await storage.read(key: 'uid');
    if (value == null || value.isEmpty) {
      Get.offAll(const LoginScreen());
      print(value);
    } else {
      print(value);
      uid.value = value;

      await fetchUserData(uid.value);

      Get.offAll(const HomeScreenDesktop());
    }
  }

  void _setupAuthListener() {
    final authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      // final Session? session = data.session;
      if (event == AuthChangeEvent.signedIn) {
        fetchUserData(supabase.auth.currentUser!.id);
        Get.offAll(const HomeScreenDesktop());
        print('crtUser : ${supabase.auth.currentUser}');
      } else {
        if (event == AuthChangeEvent.signedOut) {
          print('go to login');
          Get.offAll(const LoginScreen());
        }
      }
      final session = supabase.auth.currentSession;
      if (session != null) {
        print('go to Home with session');
        fetchUserData(session.user.id);
        Get.offAll(const HomeScreenDesktop());
      } else {
        print('go to login with session');

        Get.offAll(const LoginScreen());
      }
    });
    // supabase.auth.onAuthStateChange.listen((data) {
    //   final event = data.event;
    //   if (event == AuthChangeEvent.signedIn) {
    //     Get.off(const HomeScreenDesktop());
    //     print('crtUser : ${supabase.auth.currentUser}');
    //   } else {
    //     if (event == AuthChangeEvent.signedOut) {
    //       Get.off(const LoginScreen());
    //     }
    //   }
    // });
  }

  fetchUserData(uid) {
    var getUserData =
        supabase.from('user').select().eq('uid', uid).then((value) async {
      if (value.isNotEmpty) {
        userData.value = UserModel.fromJson(value.first);
        // 로컬 저장소에 저장
        const storage = FlutterSecureStorage();
        await storage.write(key: 'uid', value: userData.value!.uid);

        userName.value = value.first['name'];
        storeName.value = value.first['store_name'];
        print('connect user data');
        print(userName.value);
        print(storeName.value);
      }
    });
  }

  Future logIn({required String email, required String password}) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;
      await fetchUserData(user!.id);
      return res;
    } catch (e) {
      return e;
    }
  }

  Future signUp(
      {required String phone,
      required String password,
      required String name,
      required String passwordHash,
      required String store_name}) async {
    try {
      // final AuthResponse res = await supabase.auth.signUp(
      //   email: phone,
      //   password: password,
      // );
      // final Session? session = res.session;
      // final User? user = res.user;
      var uuid = const Uuid().v4();
      await supabase.from('user').insert({
        'phone': phone,
        'name': name,
        'password': passwordHash,
        'store_name': store_name,
        'uid': uuid,
      }).select('*');
      const storage = FlutterSecureStorage();
      await storage.write(key: 'uid', value: uuid);
      uid.value = uuid;

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
  Future<void> signOut() async {
    // Create storage
    const storage = FlutterSecureStorage();
    // Read value
    final value = await storage.deleteAll();
    return supabase.auth.signOut();
  }
}
