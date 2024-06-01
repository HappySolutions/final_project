import 'package:final_project/pages/categories_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../helpers/sql_helper.dart';
import '../widgets/grid_view_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool result = false;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    result = await GetIt.I.get<SqlHelper>().createTables();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      drawer: Container(),
      appBar: AppBar(),
      body: Scaffold(
        body: Column(
          children: [
            Container(
                color: Colors.red, child: Text('Hello from the other side')),
          ],
        ),
      ),
    );
  }
}
