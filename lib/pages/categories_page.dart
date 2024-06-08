// ignore_for_file: non_constant_identifier_names

import 'package:data_table_2/data_table_2.dart';
import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:final_project/pages/categories_ops_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesPage2 extends StatefulWidget {
  const CategoriesPage2({super.key});

  @override
  State<CategoriesPage2> createState() => _CategoriesPage2State();
}

class _CategoriesPage2State extends State<CategoriesPage2> {
  List<PosCategory>? categories;

  @override
  void initState() {
    getCategories();
    super.initState();
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
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => CategoriesOpsPage()));

              if (result ?? false) {
                getCategories();
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
                  getCategories();
                  return;
                }
                var sqlHelper = await GetIt.I.get<SqlHelper>();
                var data = await sqlHelper.db!.rawQuery("""
                  SELECT * From categories
                  where name like '%$text%' OR description like '%$text%'
                  """);
                if (data.isNotEmpty) {
                  categories = [];
                  for (var item in data) {
                    categories?.add(PosCategory.fromJson(item));
                  }
                } else {
                  categories = [];
                }
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: const OutlineInputBorder(),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: 'Search',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: const IconThemeData(color: Colors.black, size: 26),
                ),
                child: PaginatedDataTable2(
                  onPageChanged: (index) {
                    // print
                  },
                  // availableRowsPerPage: const <int>[1],
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
                      categories: categories,
                      onUpdate: (category) async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    CategoriesOpsPage(posCategory: category)));
                        if (result ?? false) {
                          getCategories();
                        }
                      },
                      onDelete: (category) async {
                        await onDeleteCategory(category);
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteCategory(PosCategory category) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title:
                    const Text('Are you Sure you want to delete this category'),
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
            .delete('categories', where: 'id =?', whereArgs: [category.id]);
        getCategories();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error on deleting category ${category.name}'),
        backgroundColor: Colors.red,
      ));
      print('===============> Error is $e');
    }
  }
}

class DataSource extends DataTableSource {
  List<PosCategory>? categories;
  void Function(PosCategory)? onUpdate;
  void Function(PosCategory)? onDelete;
  DataSource(
      {required this.categories,
      required this.onUpdate,
      required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${categories?[index].id}')),
      DataCell(Text('${categories?[index].name}')),
      DataCell(Text('${categories?[index].description}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onUpdate!(categories![index]);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              onDelete!(categories![index]);
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
