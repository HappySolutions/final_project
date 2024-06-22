// ignore_for_file: non_constant_identifier_names

import 'package:data_table_2/data_table_2.dart';
import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:final_project/pages/categories_ops_page.dart';
import 'package:final_project/widgets/app_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesPage2 extends StatefulWidget {
  const CategoriesPage2({super.key});

  @override
  State<CategoriesPage2> createState() => _CategoriesPage2State();
}

class _CategoriesPage2State extends State<CategoriesPage2> {
  List<PosCategory>? categories;
  int? sortColumnIndex;
  bool isAscending = true;
  bool isSorted = true;

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
    var _chosenSubCounty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const CategoriesOpsPage()));

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
                var sqlHelper = GetIt.I.get<SqlHelper>();
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
              child: AppTable(
                sortArrowBuilder: (bool ascending, bool sorted) {
                  ascending = isAscending;
                  if (ascending) {
                    return const Icon(Icons.arrow_downward,
                        color: Colors.white);
                  } else {
                    return const Icon(Icons.arrow_upward, color: Colors.white);
                  }
                },
                sortAscending: isAscending,
                sortColumnIndex: sortColumnIndex,
                columns: [
                  DataColumn(
                    label: const Text('Id'),
                    onSort: (columnIndex, ascending) {
                      ascending = isAscending;
                      setState(() {});
                      if (!ascending) {
                        categories!.sort((a, b) => a.id!.compareTo(b.id!));
                        isSorted = true;
                        isAscending = true;
                        // sortAscending();
                      } else {
                        categories!.sort((b, a) => a.id!.compareTo(b.id!));
                        isSorted = false;
                        isAscending = false;
                        // sortDescending();
                      }
                    },
                  ),
                  const DataColumn(
                    label: Text('Name'),
                  ),
                  const DataColumn(label: Text('Description')),
                  const DataColumn(label: Text('Actions')),
                ],
                source: CategoriesDataSource(
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sortAscending() {
    for (var i = 0; i < categories!.length; i++) {
      if (i + 1 == categories!.length) break;
      if (categories![i].id! < categories![(i + 1)].id!) {
        continue;
      } else {
        var temp = categories![i];
        categories![i] = categories![(i + 1)];
        categories![(i + 1)] = temp;
        sortAscending();
      }
    }
    isSorted = true;
    isAscending = true;
  }

  void sortDescending() {
    for (var i = categories!.length; i < 0; i--) {
      if (i + 1 == categories!.length) break;
      if (categories![i].id! > categories![(i + 1)].id!) {
        continue;
      } else {
        var temp = categories![i];
        categories![i] = categories![(i + 1)];
        categories![(i + 1)] = temp;

        sortDescending();
      }
    }
    isSorted = false;
    isAscending = false;
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
        content: Text(
            'Error on deleting category ${category.name} this category may contain related products'),
        backgroundColor: Colors.red,
      ));
      print('===============> Error is $e');
    }
  }
}

class CategoriesDataSource extends DataTableSource {
  List<PosCategory>? categories;
  void Function(PosCategory)? onUpdate;
  void Function(PosCategory)? onDelete;
  CategoriesDataSource({
    required this.categories,
    required this.onUpdate,
    required this.onDelete,
  });
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
