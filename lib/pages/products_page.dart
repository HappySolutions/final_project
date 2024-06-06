import 'package:data_table_2/data_table_2.dart';
import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_product.dart';
import 'package:final_project/pages/products_ops_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<PosProduct>? products;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('products');
      products = [];
      if (data.isNotEmpty) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ProductsOpsPage()));

              if (result ?? false) {
                getProducts();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.black, size: 26),
          ),
          child: PaginatedDataTable2(
            onPageChanged: (index) {
              // print
            },
            hidePaginator: false,
            empty: const Center(
              child: Text('No Data Found'),
            ),
            minWidth: 600,
            fit: FlexFit.tight,
            isHorizontalScrollBarVisible: true,
            rowsPerPage: 15,
            horizontalMargin: 20,
            checkboxHorizontalMargin: 12,
            columnSpacing: 20,
            wrapInCard: false,
            renderEmptyRowsInTheEnd: false,
            headingTextStyle:
                const TextStyle(color: Colors.white, fontSize: 18),
            headingRowColor:
                WidgetStatePropertyAll(Theme.of(context).primaryColor),
            border: TableBorder.all(color: Colors.black),
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Actions')),
            ],
            source: DataSource(
                products: products,
                onUpdate: (product) async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ProductsOpsPage(product: product)));
                  if (result ?? false) {
                    getProducts();
                  }
                },
                onDelete: (product) async {
                  await onDeleteProduct(product);
                }),
          ),
        ),
      ),
    );
  }

  Future<void> onDeleteProduct(PosProduct product) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title:
                    const Text('Are you Sure you want to delete this product'),
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
            .delete('categories', where: 'id =?', whereArgs: [product.id]);
        getProducts();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error on deleting category ${product.name}'),
        backgroundColor: Colors.red,
      ));
      print('===============> Error is $e');
    }
  }
}

class DataSource extends DataTableSource {
  List<PosProduct>? products;
  void Function(PosProduct)? onUpdate;
  void Function(PosProduct)? onDelete;
  DataSource(
      {required this.products, required this.onUpdate, required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${products?[index].id}')),
      DataCell(Text('${products?[index].name}')),
      DataCell(Text('${products?[index].description}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onUpdate!(products![index]);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              onDelete!(products![index]);
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
