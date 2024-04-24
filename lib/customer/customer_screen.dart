import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

var enter_price = '';

class CustomerScreen extends StatefulWidget {
  CustomerScreen({super.key, required this.customer});
  CustomerModel customer;

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  var favorite = false;
  var mode = '사용하기';

  @override
  void initState() {
    favorite = widget.customer.favorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1000,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.customer.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('이름',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(
                        widget.customer.name,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (favorite) {
                          await supabase.from('customer').upsert({
                            'id': widget.customer.id,
                            'favorite': false,
                          });
                          favorite = false;
                        } else {
                          await supabase.from('customer').upsert({
                            'id': widget.customer.id,
                            'favorite': true,
                          });
                          favorite = true;
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: favorite
                                ? Colors.amber[100]
                                : Colors.grey[300]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color:
                                    favorite ? Colors.amber : Colors.grey[100],
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text('즐겨찾기 등록'),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
              const Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('잔액 ',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Row(
                    children: [
                      Text('${widget.customer.balance}원',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const Gap(10),
                      GestureDetector(
                          onTap: () async {
                            if (mode == "사용하기") {
                              mode = "충전하기";
                            } else {
                              mode = "사용하기";
                            }

                            // if (favorite) {
                            //   await supabase
                            //       .from('customer')
                            //       .upsert({ 'id': widget.customer.id, 'favorite': false,});
                            //   favorite = false;
                            // } else {
                            //   await supabase
                            //       .from('customer')
                            //       .upsert({ 'id': widget.customer.id, 'favorite': true,});
                            //   favorite = true;
                            // }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey[300]),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('충전하기'),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(children: [
              //   GestureDetector(
              //       onTap: () {
              //
              //
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.grey[100]),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
              //           child: Text('충전하기' ),
              //         ),)),
              //   SizedBox(width: 10,),
              //   GestureDetector(
              //       onTap: () {
              //
              //
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: sgColor),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
              //           child: Text('사용하기',style: TextStyle(color:Colors.white),),
              //         ),)),
              // ],),
              SizedBox(
                  height: 300,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Gap(
                              30,
                              color: Colors.blue,
                            ),
                            Text(
                              enter_price == '' ? '금액을 입력해주세요' : enter_price,
                              style: TextStyle(
                                  fontSize: enter_price == '' ? 24 : 30,
                                  color: enter_price == ''
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                            mode == '사용하기'
                                ? const UseButton()
                                : AddButton(
                                    customerId: widget.customer.id,
                                    beforeBalance: widget.customer.balance,
                                  ),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  number_padd(number: 1),
                                  number_padd(number: 2),
                                  number_padd(number: 3),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  number_padd(number: 4),
                                  number_padd(number: 5),
                                  number_padd(number: 6),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  number_padd(number: 7),
                                  number_padd(number: 8),
                                  number_padd(number: 9),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          enter_price = '';
                                          print(enter_price);
                                          setState(() {});
                                        },
                                        child: const Center(child: Text('C'))),
                                  ),
                                  number_padd(number: 0),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          enter_price = '';
                                          print(enter_price);
                                          setState(() {});
                                        },
                                        child: const Center(
                                            child: Text('remove'))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Expanded number_padd({required int number}) {
    return Expanded(
      child: InkWell(
          onTap: () {
            enter_price = enter_price + number.toString();
            print(enter_price);
            setState(() {});
          },
          child: Center(
              child: Text(
            number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
    );
  }
}

class UseButton extends StatelessWidget {
  const UseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Text(
              '사용하기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.customerId,
    required this.beforeBalance,
  });
  final int customerId;
  final int beforeBalance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          var addBalance = int.parse(enter_price);
          var newBalance = beforeBalance + addBalance;

          await supabase.from('customer').upsert({
            'id': customerId,
            'balance': newBalance,
          });
        },
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: sgColor),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Text(
              '충전하기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.number,
  });
  final String number;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          onTap: () {
            enter_price = enter_price + number;
            print(enter_price);
            setState() {}
          },
          child: Center(child: Text(number))),
    );
  }
}
