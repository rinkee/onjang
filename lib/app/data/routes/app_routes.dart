part of './app_pages.dart';

abstract class Routes {
  static const initial = '/';
  static const introduce = '/introduce';

  //홈
  static const home = '/home';

  //고객
  static const customer = '/home/customer';
  static const customerInfo = '/home/customer/info';
  static const customerSetting = '/home/customer/setting';
  static const customerInactive = '/home/customer/inactive';
  static const record = '/home/customer/record';

  // 로그인
  static const login = '/login';
  static const signIn = '/signIn';
  static const email = '/introduce';
  static const password = '/password';

  // 유저
  static const user = '/user';
  static const userEdit = '/user/edit';

  //세팅
  static const setting = '/setting';

  // 데모
  static const demoHome = '/demoHome';
  static const demoCustomer = '/demoCustomer';
}
