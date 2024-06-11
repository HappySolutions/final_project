import 'package:data_table_2/data_table_2.dart';
import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/client.dart';
import 'package:final_project/pages/clients_ops_page.dart';
import 'package:final_project/widgets/app_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Client>? clients;

  @override
  void initState() {
    getClients();
    super.initState();
  }

  void getClients() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('clients');
      clients = [];
      if (data.isNotEmpty) {
        for (var item in data) {
          clients?.add(Client.fromJson(item));
        }
      } else {
        clients = [];
      }
    } catch (e) {
      print('Error in get Clients $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const ClientsOpsPage()));

              if (result ?? false) {
                getClients();
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
                  getClients();
                  return;
                }
                var sqlHelper = GetIt.I.get<SqlHelper>();
                var data = await sqlHelper.db!.rawQuery("""
                  SELECT * From clients
                  where name like '%$text%' OR address like '%$text%'
                  """);
                if (data.isNotEmpty) {
                  clients = [];
                  for (var item in data) {
                    clients?.add(Client.fromJson(item));
                  }
                } else {
                  clients = [];
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
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Email')),
                ],
                source: ClientsDataSource(
                  clients: clients,
                  onUpdate: (client) async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ClientsOpsPage(client: client)));
                    if (result ?? false) {
                      getClients();
                    }
                  },
                  onDelete: (client) async {
                    await onDeleteCategory(client);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteCategory(Client client) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title:
                    const Text('Are you Sure you want to delete this client'),
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
            .delete('clients', where: 'id =?', whereArgs: [client.id]);
        getClients();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error on deleting client ${client.name} this client may have recent order'),
        backgroundColor: Colors.red,
      ));
      print('===============> Error is $e');
    }
  }
}

class ClientsDataSource extends DataTableSource {
  List<Client>? clients;
  void Function(Client)? onUpdate;
  void Function(Client)? onDelete;
  ClientsDataSource(
      {required this.clients, required this.onUpdate, required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${clients?[index].id}')),
      DataCell(Text('${clients?[index].name}')),
      DataCell(Text('${clients?[index].email}')),
      DataCell(Text('${clients?[index].phone}')),
      DataCell(Text('${clients?[index].address}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onUpdate!(clients![index]);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              onDelete!(clients![index]);
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clients?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
