import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/client.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ClientsDropDown extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;
  const ClientsDropDown(
      {this.selectedValue, required this.onChanged, super.key});

  @override
  State<ClientsDropDown> createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
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
      print('Error in get clients $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return clients == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (clients?.isEmpty ?? false)
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
                            value: widget.selectedValue,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('Select Client'),
                            items: [
                              for (var client in clients!)
                                DropdownMenuItem(
                                  value: client.id,
                                  child: Text(client.name ?? 'No Name'),
                                ),
                            ],
                            onChanged: widget.onChanged),
                      ),
                    ),
                  ),
                ],
              );
  }
}
