import 'package:final_project/pages/all_sales_page.dart';
import 'package:final_project/pages/categories_page.dart';
import 'package:final_project/pages/clients_page.dart';
import 'package:final_project/pages/sale_ops_page.dart';
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Header of the Drawer
              Material(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top, bottom: 24),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Happy',
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                        Text(
                          '@happy.com',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Header Menu items
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Home'),
                    onTap: () {
                      /// Close Navigation drawer before
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.apps),
                    title: const Text('Categories'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoriesPage2()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.workspaces),
                    title: const Text('Products'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Clients'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClientsPage()),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.black45,
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('New Sale'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SaleOpsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: const Text('All Sales'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllSalesPage()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: (MediaQuery.of(context).size.height / 3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
            ],
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ClientsPage()));
                        }),
                    GridViewItem(
                        label: 'New Sale',
                        color: Colors.green,
                        iconData: Icons.point_of_sale,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SaleOpsPage()));
                        }),
                    GridViewItem(
                        label: 'All Sales',
                        color: Colors.orange,
                        iconData: Icons.calculate,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AllSalesPage()));
                        }),
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
