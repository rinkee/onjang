class DemoCustomerScreenArgs {
  final Map<String, Object> customerData;
  final Function updateCustomerList;

  DemoCustomerScreenArgs(
      {required this.customerData, required this.updateCustomerList});
}
