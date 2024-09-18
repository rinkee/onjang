class Routes {
  static const String initial = 'initial';
  static const String home = 'home';
  static const String customer = 'customer';
  static const String customerEdit = 'customerEdit';
  static const String customerInactive = 'customerInactive';
  static const String record = 'record';
  static const String userEdit = 'userEdit';
  static const String setting = 'setting';
  static const String introduce = 'introduce';
  static const String login = 'login';
  static const String signIn = 'signIn';
  static const String email = 'email';
  static const String password = 'password';
}

class Paths {
  static const String initial = '/';
  static const String home = '/home';
  static const String customer = 'customer';
  static const String customerEdit = ':id';
  static const String customerInactive = 'customer-inactive';
  static const String record = 'record/:id';
  static const String userEdit = 'user/edit';
  static const String setting = 'setting';
  static const String introduce = '/introduce';
  static const String login = '/login';
  static const String signIn = '/signin';
  static const String email = '/email';
  static const String password = '/password';

  // 중첩 경로를 위한 메서드
  // static String customerPath() => '$home/$customer';
  // static String customerEditPath(String id) => '${customerPath()}/$id';
  // static String recordPath(int id) => '$home/record/$id';

  // 필요에 따라 추가 메서드를 정의할 수 있습니다.
}
