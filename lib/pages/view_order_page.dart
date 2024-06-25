import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/models/order_item.dart';
import 'package:final_project/models/pos_product.dart';
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

  late double total;
  @override
  void initState() {
    total = widget.order!.totalPrice! - widget.order!.discount!;
    getOrderItems();
    super.initState();
  }

  void getOrderItems() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();

      var data = await sqlHelper.db!.rawQuery("""
      Select OPI.*, P.name as productName, P.price as productPrice from orderProductItems OPI
      Inner JOIN products P
      On OPI.productId = P.id
      """);
      // [widget.order!.id]);
      // 'SELECT * FROM orderProductItems WHERE orderId=?',

      print(data);

      if (data.isNotEmpty) {
        selectedOrderItems = [];

        for (var item in data) {
          selectedOrderItems?.add(OrderItem.fromJson(item));
        }

        var data2 = await sqlHelper.db!.rawQuery(
            'SELECT * FROM products WHERE id=?',
            [selectedOrderItems![0].productId]);
        print(data2);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.order?.label}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details:',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            // for (var orderItem in selectedOrderItems ?? [])
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 5),
            //   child: Card(
            //     child:
            //     ListTile(
            //       title: Text(
            //           '${orderItem.product.name ?? 'No name'}, ${orderItem.productCount}X'),
            //       leading: Image.network(orderItem.product.image ?? ''),
            //       trailing: Text(
            //           '${orderItem.productCount * orderItem.product.price}'),
            //     ),
            //   ),
            // ),
            Text(
              'Total Price: $total',
              style: const TextStyle(
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
