import 'package:final_project/pages/categories_page.dart';
import 'package:final_project/pages/products_page.dart';
import 'package:final_project/widgets/header_item.dart';
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
  bool showLoading = true;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    result = await GetIt.I.get<SqlHelper>().createTables();
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              height: (MediaQuery.of(context).size.height / 3),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Easy POS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: showLoading
                                ? Transform.scale(
                                    scale: .5,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 10,
                                    backgroundColor:
                                        result ? Colors.green : Colors.red,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const HeaderItem('Exchange Rate', '1USD = 50 Egp'),
                      const HeaderItem('Today\'s Sales', '1100 Egp'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xfffbfafb),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    GridViewItem(
                        label: 'Categories',
                        color: Colors.yellow,
                        iconData: Icons.category,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesPage2()));
                        }),
                    GridViewItem(
                        label: 'Product',
                        color: Colors.pink,
                        iconData: Icons.inventory_2,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProductsPage()));
                        }),
                    GridViewItem(
                        label: 'Clients',
                        color: Colors.lightBlue,
                        iconData: Icons.groups,
                        onTap: () {}),
                    GridViewItem(
                        label: 'New Sale',
                        color: Colors.green,
                        iconData: Icons.point_of_sale,
                        onTap: () {}),
                    GridViewItem(
                        label: 'All Sales',
                        color: Colors.orange,
                        iconData: Icons.calculate,
                        onTap: () {}),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
