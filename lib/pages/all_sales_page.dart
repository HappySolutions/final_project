import 'package:data_table_2/data_table_2.dart';
import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/widgets/app_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

class AllSalesPage extends StatefulWidget {
  const AllSalesPage({super.key});

  @override
  State<AllSalesPage> createState() => _AllSalesPageState();
}

class _AllSalesPageState extends State<AllSalesPage> {
  List<Order>? orders;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      Select O.*, C.name as clientName, C.phone as clientPhone from orders O
      Inner JOIN clients C
      On O.clientId = C.id
      
      
      """);
      if (data.isNotEmpty) {
        orders = [];

        for (var item in data) {
          orders?.add(Order.fromJson(item));
        }
      } else {
        orders = [];
      }
    } catch (e) {
      print('Error in get Orders $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: AppTable(
            minWidth: 800,
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Label')),
              DataColumn(label: Text('Total Price')),
              DataColumn(label: Text('Discount')),
              DataColumn(label: Text('Client Name')),
              DataColumn(label: Text('Client Phone')),
              DataColumn(label: Text('Actions')),
            ],
            source: OrdersDataSource(
              orders: orders,
              onDelete: (order) async {
                await onDeleteOrder(order);
              },
              onShow: (order) async {
                await onShowOrder(order);
              },
            ),
          ),
        ),
      ),
    );
  }

//TODO update onShowOrder function
  Future<void> onShowOrder(Order order) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (context, setStateEx) {
            return Dialog(
              child: (orders?.isEmpty ?? false)
                  ? const Center(
                      child: Text('NO date found'),
                    )
                  : Column(
                      children: [
                        ListView(
                          children: [
                            for (var order in orders!)
                              ListTile(
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('order product ${order.label}'),
                                  ],
                                ),
                                title: const Text('No name'),
                                leading: Image.network(''),
                              ),
                          ],
                        ),
                      ],
                    ),
            );
          });
        });
    setState(() {});
  }

  Future<void> onDeleteOrder(Order order) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title:
                    const Text('Are you Sure you want to delete this order??'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Delete'),
                  ),
                ]);
          });

      if (dialogResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        await sqlHelper.db!
            .delete('orders', where: 'id =?', whereArgs: [order.id]);
        getOrders();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error on deleting order ${order.label} this order may contain related products'),
        backgroundColor: Colors.red,
      ));
      print('===============> Error is $e');
    }
  }
}

class OrdersDataSource extends DataTableSource {
  List<Order>? orders;
  void Function(Order)? onShow;
  void Function(Order)? onDelete;
  OrdersDataSource(
      {required this.orders, required this.onDelete, required this.onShow});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${orders?[index].id}')),
      DataCell(Text('${orders?[index].label}')),
      DataCell(Text('${orders?[index].totalPrice}')),
      DataCell(Text('${orders?[index].discount}')),
      DataCell(Text('${orders?[index].clientName}')),
      DataCell(Text('${orders?[index].clientPhone}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
