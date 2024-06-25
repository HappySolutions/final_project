import 'package:data_table_2/data_table_2.dart';
import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:final_project/models/pos_product.dart';
import 'package:final_project/pages/products_ops_page.dart';
import 'package:final_project/widgets/app_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<PosProduct>? products;
  List<PosCategory>? categories;

  int? sortColumnIndex;
  bool isAscending = true;
  bool isSorted = true;
  String? _chosenCategory;

  @override
  void initState() {
    getProducts();
    getCategories();

    super.initState();
  }

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

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('categories');
      categories = [];
      if (data.isNotEmpty) {
        for (var item in data) {
          categories?.add(PosCategory.fromJson(item));
        }
      } else {
        categories = [];
      }
    } catch (e) {
      print('Error in get Categories $e');
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
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => const ProductsOpsPage()));

                if (result ?? false) {
                  getProducts();
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                onChanged: (text) async {
                  if (text == '') {
                    getProducts();
                    return;
                  }
                  var sqlHelper = GetIt.I.get<SqlHelper>();
                  var data = await sqlHelper.db!.rawQuery("""
                  SELECT * From products
                  where name like '%$text%' OR description like '%$text%'
                  """);
                  if (data.isNotEmpty) {
                    products = [];
                    for (var item in data) {
                      products?.add(PosProduct.fromJson(item));
                    }
                  } else {
                    products = [];
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  labelText: 'Search',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              categories == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (categories?.isEmpty ?? false)
                      ? const Center(
                          child: Text('No Categories Found'),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    child: DropdownButton(
                                      value: _chosenCategory,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      hint: const Text('Filter By Category'),
                                      items: [
                                        for (var category in categories!)
                                          DropdownMenuItem<String>(
                                            value: category.name,
                                            child: Text(
                                                category.name ?? 'No Name'),
                                          ),
                                      ],
                                      onChanged: (value) {
                                        _chosenCategory = value;
                                        products = products!
                                            .where((element) => element
                                                .categoryName!
                                                .contains(_chosenCategory!))
                                            .toList();
                                        if (products!.isEmpty) {
                                          getProducts();
                                          return;
                                        }
                                        setState(() {});
                                      },
                                    )),
                              ),
                            ),
                          ],
                        ),
              const SizedBox(height: 20),
              Expanded(
                child: AppTable(
                  minWidth: 1100,
                  sortArrowBuilder: (bool ascending, bool sorted) {
                    ascending = isAscending;
                    sorted = isSorted;
                    if (ascending) {
                      return const Icon(Icons.arrow_upward,
                          color: Colors.white);
                    } else {
                      return const Icon(Icons.arrow_downward,
                          color: Colors.white);
                    }
                  },
                  sortAscending: isAscending,
                  sortColumnIndex: sortColumnIndex,
                  columns: [
                    const DataColumn(label: Text('Id')),
                    DataColumn(
                      label: const Text('Name'),
                      onSort: (columnIndex, ascending) {
                        ascending = isAscending;
                        if (!ascending) {
                          products!.sort((a, b) => a.name!.compareTo(b.name!));
                          isSorted = true;
                          isAscending = true;
                        } else {
                          products!.sort((b, a) => a.name!.compareTo(b.name!));
                          isSorted = false;
                          isAscending = false;
                        }
                        setState(
                          () {},
                        );
                      },
                    ),
                    const DataColumn(label: Text('Description')),
                    DataColumn(
                      label: const Text('Price'),
                      onSort: (columnIndex, ascending) {
                        ascending = isAscending;
                        if (!ascending) {
                          products!
                              .sort((a, b) => a.price!.compareTo(b.price!));
                          isSorted = true;
                          isAscending = true;
                        } else {
                          products!
                              .sort((b, a) => a.price!.compareTo(b.price!));
                          isSorted = false;
                          isAscending = false;
                        }
                        setState(
                          () {},
                        );
                      },
                    ),
                    const DataColumn(label: Text('Stock')),
                    const DataColumn(label: Text('isAvailable')),
                    const DataColumn(label: Text('Image')),
                    const DataColumn(label: Text('Cat Name')),
                    const DataColumn(label: Text('Cat Description')),
                    const DataColumn(label: Text('Actions')),
                  ],
                  source: ProductsDataSource(
                    products: products,
                    onUpdate: (product) async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  ProductsOpsPage(product: product)));
                      if (result ?? false) {
                        getProducts();
                      }
                    },
                    onDelete: (product) async {
                      await onDeleteProduct(product);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void sortAscending() {
    for (var i = products!.length; i < 0; i--) {
      if (i + 1 == products!.length) break;
      if (products![i].price! < products![(i + 1)].price!) {
        continue;
      } else {
        var temp = products![i];
        products![i] = products![(i + 1)];
        products![(i + 1)] = temp;
        sortAscending();
      }
    }
    isSorted = true;
    isAscending = true;
  }

  void sortDescending() {
    for (var i = products!.length; i < 0; i--) {
      if (i + 1 == products!.length) break;
      if (products![i].price! > products![(i + 1)].price!) {
        continue;
      } else {
        var temp = products![i];
        products![i] = products![(i + 1)];
        products![(i + 1)] = temp;
        sortDescending();
      }
    }
    isSorted = false;
    isAscending = false;
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

class ProductsDataSource extends DataTableSource {
  List<PosProduct>? products;
  void Function(PosProduct)? onUpdate;
  void Function(PosProduct)? onDelete;
  ProductsDataSource(
      {required this.products, required this.onUpdate, required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${products?[index].id}')),
      DataCell(Text('${products?[index].name}')),
      DataCell(Text('${products?[index].description}')),
      DataCell(Text('${products?[index].price}')),
      DataCell(Text('${products?[index].stock}')),
      DataCell(Text('${products?[index].isAvailable}')),
      DataCell(Center(child: Image.network(products?[index].image ?? ''))),
      DataCell(Text('${products?[index].categoryName}')),
      DataCell(Text('${products?[index].categoryDescription}')),
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
