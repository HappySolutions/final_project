// ignore_for_file: prefer_is_empty, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:final_project/pages/categories_ops_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // List<PosCategory> categories = <PosCategory>[];

  // late CategoriesDataSource categoryDataSource;
  bool sort = true;
  List<PosCategory>? filterData;
  List<PosCategory> myData = [
    PosCategory(10001, 'James', 'Project Lead'),
    PosCategory(10002, 'adam', 'Project Lead'),
    PosCategory(10003, 'Jon', 'Project Lead'),
    PosCategory(10004, 'Jan', 'Project Lead'),
    PosCategory(10005, 'Happyy', 'Project Lead'),
    PosCategory(10006, 'Happyy', 'Project Lead'),
    PosCategory(10007, 'Happyy', 'Project Lead'),
    PosCategory(10008, 'Happyy', 'Project Lead'),
    PosCategory(10009, 'Happyy', 'Project Lead'),
    PosCategory(10010, 'Happyy', 'Project Lead'),
    PosCategory(10011, 'Happyy', 'Project Lead'),
    PosCategory(10012, 'Happyy', 'Project Lead'),
    PosCategory(10013, 'Happyy', 'Project Lead'),
    PosCategory(10014, 'Happyy', 'Project Lead'),
  ];

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        filterData!.sort((a, b) => b.name!.compareTo(a.name!));
      }
    }
  }

  @override
  void initState() {
    // categories = getCategory();
    // categoryDataSource = CategoriesDataSource(categories: categories);
    filterData = myData;

    getCategories();
    super.initState();
  }

  // List<PosCategory> getCategory() {
  //   return [
  //     PosCategory(10001, 'James', 'Project Lead'),
  //     PosCategory(10002, 'adam', 'Project Lead'),
  //     PosCategory(10003, 'Jon', 'Project Lead'),
  //     PosCategory(10004, 'Jan', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //     PosCategory(10005, 'Happyy', 'Project Lead'),
  //   ];
  // }

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
                // header: Container(
                //   padding: const EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Colors.grey,
                //       ),
                //       borderRadius: BorderRadius.circular(12)),
                //   child: TextField(
                //     decoration: const InputDecoration(
                //         hintText: "Enter something to filter"),
                //     onChanged: (value) {
                //       setState(() {
                //         myData = filterData!
                //             .where((element) => element.name!.contains(value))
                //             .toList();
                //       });
                //     },
                //   ),
                // ),

                source: RowSource(
                  myData: myData,
                  count: myData.length,
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

      // SfDataGrid(
      //   columnWidthMode: ColumnWidthMode.auto,
      //   rowHeight: 50,
      //   rowsPerPage: 5,
      //   gridLinesVisibility: GridLinesVisibility.horizontal,
      //   source: categoryDataSource,
      //   columns: <GridColumn>[
      //     GridColumn(
      //         columnName: 'id',
      //         label: Container(
      //             padding: EdgeInsets.all(16.0),
      //             alignment: Alignment.centerLeft,
      //             child: Text(
      //               'ID',
      //             ))),
      //     GridColumn(
      //         columnName: 'name',
      //         label: Container(
      //             padding: EdgeInsets.all(16.0),
      //             alignment: Alignment.centerLeft,
      //             child: Text('Name'))),
      //     GridColumn(
      //         columnName: 'description',
      //         width: 120,
      //         label: Container(
      //             padding: EdgeInsets.all(16.0),
      //             alignment: Alignment.centerLeft,
      //             child: Text('Description'))),
      //   ],
      // ),
      ////////////////////////////////
      // HorizontalDataTable(
      //   leftHandSideColumnWidth: 100,
      //   rightHandSideColumnWidth: 100,
      //   isFixedHeader: true,
      //   isFixedFooter: true,
      //   headerWidgets: _getTitleWidget(),
      //   leftSideItemBuilder: _generateFirstColumnRow,
      //   rightSideItemBuilder: _generateRightHandSideColumnRow,
      //   itemCount: 1,
      //   rowSeparatorWidget: const Divider(
      //     color: Colors.black38,
      //     height: 1.0,
      //     thickness: 0.0,
      //   ),
      //   leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      //   rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      //   itemExtent: 55,
      // ),

      //   ),
      // ),
    );
  }

  void getCategories() async {
    // try {
    //   var data = await GetIt.I.get<SqlHelper>().db!.query('categories');
    //   if (data.isNotEmpty) {
    //     for (var item in data) {
    //       categories!.add(PosCategory.fromJson(item));
    //       print(data);
    //       print(categories);
    //     }
    //   } else {
    //     categories = [PosCategory(100, 'test name', 'test description')];
    //   }
    //   setState(() {});
    // } catch (e) {
    //   print('=======> error is $e');
    // }
  }

  // List<Widget> _getTitleWidget() {
  //   return [
  //     _getTitleItemWidget('id', 100),
  //     _getTitleItemWidget('name', 100),
  //     _getTitleItemWidget('description', 200),
  //   ];
  // }

  // Widget _getTitleItemWidget(String label, double width) {
  //   return Container(
  //     width: width,
  //     height: 56,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //     child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  //   );
  // }

  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   return Container(
  //     width: 100,
  //     height: 52,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //     child: const Text('categories![0].name'),
  //   );
  // }

  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         width: 200,
  //         height: 52,
  //         padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //         child: Text('id'),
  //       ),
  //       Container(
  //         width: 100,
  //         height: 52,
  //         padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //         child: Text('name'),
  //       ),
  //       Container(
  //         width: 200,
  //         height: 52,
  //         padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //         child: Text('description'),
  //       ),
  //     ],
  //   );
  // }
}

class CategoriesDataSource extends DataGridSource {
  CategoriesDataSource({List<PosCategory>? categories}) {
    _categories = categories!
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'description', value: e.description),
            ]))
        .toList();
  }

  List<DataGridRow> _categories = [];

  @override
  List<DataGridRow> get rows => _categories;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

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
