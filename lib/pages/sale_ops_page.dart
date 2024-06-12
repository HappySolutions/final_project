import 'dart:async';

import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/client.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/models/order_item.dart';
import 'package:final_project/models/pos_product.dart';
import 'package:final_project/widgets/app_eleveted_button.dart';
import 'package:final_project/widgets/clients_dro_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class SaleOpsPage extends StatefulWidget {
  final Client? client;
  final Order? order;
  const SaleOpsPage({this.client, this.order, super.key});

  @override
  State<SaleOpsPage> createState() => _SaleOpsPageState();
}

class _SaleOpsPageState extends State<SaleOpsPage> {
  List<PosProduct>? products;
  List<OrderItem>? selectedOrderItems;
  String? orderLabel;
  int? selectedClientId;
  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      Select P.*, C.name as categoryName, C.description as categoryDescription from products P
      Inner JOIN categories C
      On P.categoryId = C.id
      
      
      """);
      if (data.isNotEmpty) {
        products = [];

        for (var item in data) {
          products?.add(PosProduct.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      print('Error in get Products $e');
    }
    setState(() {});
  }

  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() {
    getProducts();
    orderLabel = widget.order == null
        ? '#OR${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.label;
    selectedClientId = widget.client?.id;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Add New Sale' : 'Update Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Label: $orderLabel',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClientsDropDown(
                        selectedValue: selectedClientId,
                        onChanged: (value) {
                          selectedClientId = value;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return StatefulBuilder(
                                      builder: (context, setStateEx) {
                                    return Dialog(
                                      child: (products?.isEmpty ?? false)
                                          ? const Center(
                                              child: Text('NO date found'),
                                            )
                                          : Column(
                                              children: [
                                                Expanded(
                                                  child: ListView(
                                                    children: [
                                                      for (var product
                                                          in products!)
                                                        ListTile(
                                                          subtitle: getOrderItem(
                                                                      product
                                                                          .id!) !=
                                                                  null
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (getOrderItem(product.id!)!.productCount ==
                                                                            0)
                                                                          return;
                                                                        getOrderItem(product.id!)
                                                                            ?.productCount = getOrderItem(product.id!)!
                                                                                .productCount! -
                                                                            1;
                                                                        setStateEx(
                                                                            () {});
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .remove),
                                                                    ),
                                                                    Text(
                                                                        '${getOrderItem(product.id!)?.productCount}'),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (getOrderItem(product.id!)!.productCount ==
                                                                            getOrderItem(product.id!)!.product!.stock)
                                                                          return;
                                                                        getOrderItem(product.id!)
                                                                            ?.productCount = getOrderItem(product.id!)!
                                                                                .productCount! +
                                                                            1;
                                                                        setStateEx(
                                                                            () {});
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .add),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                          title: Text(
                                                              product.name ??
                                                                  'No name'),
                                                          leading: Image
                                                              .network(product
                                                                      .image ??
                                                                  ''),
                                                          trailing: IconButton(
                                                            onPressed: () {
                                                              if (getOrderItem(
                                                                      product
                                                                          .id!) !=
                                                                  null) {
                                                                onDeletOrderItem(
                                                                    product
                                                                        .id!);
                                                              } else {
                                                                onAddOrderItem(
                                                                    product);
                                                              }
                                                              setStateEx(() {});
                                                            },
                                                            icon: getOrderItem(
                                                                        product
                                                                            .id!) ==
                                                                    null
                                                                ? const Icon(
                                                                    Icons.add)
                                                                : const Icon(
                                                                    Icons
                                                                        .delete),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AppElevatedButton(
                                                    label: 'Back',
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                    );
                                  });
                                });
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Add Products',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Card(
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
                    Text(
                      'Total Price: $calcualteTotalPrice',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    //TODO add discount text here
                  ],
                ),
              )),
              AppElevatedButton(
                label: 'Add Order',
                onPressed: () async {
                  await onSetOrder();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSetOrder() async {
    try {
      if (selectedOrderItems == null ||
          (selectedOrderItems?.isEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'You must add order items',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var orderId = await sqlHelper.db!
          .insert('orders', conflictAlgorithm: ConflictAlgorithm.replace, {
        'label': orderLabel,
        'totalPrice': calcualteTotalPrice,
        'discount': 0,
        'clientId': selectedClientId,
      });
      var batch = sqlHelper.db!.batch();

      for (var orderItem in selectedOrderItems!) {
        batch.insert('orderProductItems', {
          'orderId': orderId,
          'productId': orderItem.productId,
          'productCount': 'orderItem.productCount'
        });
      }
      var result = await batch.commit();
      print('=======> $result');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Order Created Successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '==========> Error is $e',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  double get calcualteTotalPrice {
    var totalPrice = 0.0;
    for (var orderItem in selectedOrderItems ?? []) {
      totalPrice = totalPrice +
          ((orderItem.productCount ?? 0) * (orderItem.product.price ?? 0));
    }
    return totalPrice;
  }

  void onAddOrderItem(PosProduct product) {
    var orderItem = OrderItem();
    orderItem.product = product;
    orderItem.productCount = 1;
    orderItem.productId = product.id;
    selectedOrderItems ??= [];
    selectedOrderItems!.add(orderItem);
    setState(() {});
  }

  void onDeletOrderItem(int productId) {
    for (var i = 0; i < (selectedOrderItems!.length); i++) {
      if (selectedOrderItems![i].productId == productId) {
        selectedOrderItems!.removeAt(i);
      }
    }
    setState(() {});
  }

  OrderItem? getOrderItem(int productId) {
    for (var orderItem in selectedOrderItems ?? []) {
      if (orderItem.productId == productId) {
        return orderItem;
      }
    }
    return null;
  }
}
