import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;
  final int? sortColumnIndex;
  final bool? sortAscending;
  Widget Function(bool, bool)? sortArrowBuilder;
  double minWidth;
  AppTable(
      {required this.columns,
      required this.source,
      this.minWidth = 600,
      this.sortColumnIndex,
      this.sortAscending,
      this.sortArrowBuilder,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.black, size: 26),
      ),
      child: PaginatedDataTable2(
        sortArrowAlwaysVisible: true,
        sortArrowBuilder: sortArrowBuilder,
        onPageChanged: (index) {
          // print
        },
        hidePaginator: false,
        empty: const Center(
          child: Text('No Data Found'),
        ),
        minWidth: minWidth,
        fit: FlexFit.tight,
        isHorizontalScrollBarVisible: true,
        rowsPerPage: 5,
        horizontalMargin: 20,
        checkboxHorizontalMargin: 12,
        columnSpacing: 20,
        wrapInCard: false,
        renderEmptyRowsInTheEnd: false,
        headingTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        headingRowColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        border: TableBorder(
            top: const BorderSide(color: Colors.black),
            bottom: BorderSide(color: Colors.grey[300]!),
            left: BorderSide(color: Colors.grey[300]!),
            right: BorderSide(color: Colors.grey[300]!),
            verticalInside: BorderSide(color: Colors.grey[300]!),
            horizontalInside: const BorderSide(color: Colors.grey, width: 1)),
        columns: columns,
        source: source,
        sortColumnIndex: sortColumnIndex,
        sortAscending: true,
      ),
    );
  }
}
