// ignore_for_file: prefer_is_empty, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:final_project/pages/categories_ops_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<PosCategory> myCategories = <PosCategory>[];
  List<PosCategory>? filteredCategory;
  bool sort = true;

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filteredCategory!.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        filteredCategory!.sort((a, b) => b.name!.compareTo(a.name!));
      }
    }
  }

  @override
  void initState() {
    filteredCategory = myCategories;
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const CategoriesOpsPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: double.infinity,
            child: Theme(
              data: ThemeData.light()
                  .copyWith(cardColor: Theme.of(context).canvasColor),
              child: PaginatedDataTable(
                headingRowColor: WidgetStateProperty.all(Colors.blue),
                sortColumnIndex: 0,
                sortAscending: sort,
                source: RowSource(
                  myData: myCategories,
                  count: myCategories.length,
                ),
                rowsPerPage: 8,
                columnSpacing: 8,
                columns: [
                  DataColumn(
                      label: const Text(
                        "Id",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          sort = !sort;
                        });

                        onsortColum(columnIndex, ascending);
                      }),
                  const DataColumn(
                    label: Text(
                      "Name",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  const DataColumn(
                    label: Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  void getCategories() async {
    try {
      var data = await GetIt.I.get<SqlHelper>().db!.query('categories');
      if (data.isNotEmpty) {
        for (var item in data) {
          myCategories.add(PosCategory.fromJson(item));
          print(data);
          print(myCategories);
        }
      }
      setState(() {});
    } catch (e) {
      print('=======> error is $e');
    }
  }
}

// class CategoriesDataSource extends DataGridSource {

//   CategoriesDataSource({List<PosCategory>? categories}) {
//     _categories = categories!
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<int>(columnName: 'id', value: e.id),
//               DataGridCell<String>(columnName: 'name', value: e.name),
//               DataGridCell<String>(
//                   columnName: 'description', value: e.description),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _categories = [];

//   @override
//   List<DataGridRow> get rows => _categories;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((dataGridCell) {
//       return Container(
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.all(16.0),
//         child: Text(dataGridCell.value.toString()),
//       );
//     }).toList());
//   }
// }

class RowSource extends DataTableSource {
  var myData;
  final count;
  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(
    cells: [
      DataCell(Text(data.id.toString())),
      DataCell(Text(data.name.toString())),
      DataCell(Text(data.description.toString())),
    ],
  );
}
