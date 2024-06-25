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
  List<OrderProducts>? selectedOrderItems;

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
      Select OPI.*, P.name as productName, P.price as productPrice, P.image as productImage from orderProductItems OPI
      Inner JOIN products P
      On OPI.productId = P.id
      """);
      // [widget.order!.id]);
      // 'SELECT * FROM orderProductItems WHERE orderId=?',

      print(data);

      if (data.isNotEmpty) {
        selectedOrderItems = [];

        for (var item in data) {
          selectedOrderItems?.add(OrderProducts.fromJson(item));
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
              'Order Products:',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            for (var orderItem in selectedOrderItems ?? [])
              if (orderItem.orderId == widget.order?.id)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    color: Colors.white60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            '${orderItem.productName ?? 'No name'}, ${orderItem.productCount}X'),
                        leading: Image.network(orderItem.productImage ?? ''),
                        trailing: Text(
                            '${orderItem.productCount * orderItem.productPrice}'),
                      ),
                    ),
                  ),
                ),
            const SizedBox(
              height: 20,
            ),
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
