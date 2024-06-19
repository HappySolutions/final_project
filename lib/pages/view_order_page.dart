import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/models/order_item.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ViewOrderPage extends StatefulWidget {
  final Order? order;
  const ViewOrderPage({this.order, super.key});

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  List<OrderItem>? selectedOrderItems;

  @override
  void initState() {
    getOrderItems();
    super.initState();
  }

  void getOrderItems() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
     Select OPI.productCount as productCount, P.name as productName from orderProductItems OPI
      Inner JOIN products P
      On P.id = OPI.productId
      """);

      if (data.isNotEmpty) {
        selectedOrderItems = [];

        for (var item in data) {
          selectedOrderItems?.add(OrderItem.fromJson(item));
        }
      } else {
        selectedOrderItems = [];
      }
    } catch (e) {
      print('Error in get Order items $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'OrderItems',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            for (var orderItem in selectedOrderItems ?? [])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(
                      '${orderItem.product.name ?? 'No name'}, ${orderItem.productCount}X'),
                  leading: Image.network(orderItem.product.image ?? ''),
                  trailing: Text(
                      '${orderItem.productCount * orderItem.product.price}'),
                ),
              ),
            const Text(
              'Total Price: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
