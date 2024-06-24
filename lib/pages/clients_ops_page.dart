import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/client.dart';
import 'package:final_project/widgets/app_eleveted_button.dart';
import 'package:final_project/widgets/app_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class ClientsOpsPage extends StatefulWidget {
  final Client? client;

  const ClientsOpsPage({super.key, this.client});

  @override
  State<ClientsOpsPage> createState() => _ClientsOpsPageState();
}

class _ClientsOpsPageState extends State<ClientsOpsPage> {
  late TextEditingController nameTextFeildController;
  late TextEditingController addressTextFeildController;
  late TextEditingController emailTextFeildController;
  late TextEditingController phoneTextFeildController;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nameTextFeildController =
        TextEditingController(text: widget.client?.name ?? '');
    addressTextFeildController =
        TextEditingController(text: widget.client?.address ?? '');

    emailTextFeildController =
        TextEditingController(text: widget.client?.email ?? '');

    phoneTextFeildController =
        TextEditingController(text: widget.client?.phone ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? 'Add New' : 'Edit Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                AppTextFormFeild(
                  labelText: 'name',
                  controller: nameTextFeildController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFormFeild(
                  labelText: 'address',
                  controller: addressTextFeildController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter valid address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFormFeild(
                  labelText: 'email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailTextFeildController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFormFeild(
                  labelText: 'phone',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: phoneTextFeildController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter valid phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AppElevatedButton(
                  label: widget.client == null ? 'Submit' : 'Edit Client',
                  onPressed: () async {
                    await onSubmit();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      if (formKey.currentState!.validate()) {
        //Add Category logic
        if (widget.client == null) {
          sqlHelper.db!
              .insert('clients', conflictAlgorithm: ConflictAlgorithm.replace, {
            'name': nameTextFeildController.text,
            'address': addressTextFeildController.text,
            'email': emailTextFeildController.text,
            'phone': phoneTextFeildController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Client Added Successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          Navigator.pop(context, true);
        } else //update category logic
        {
          sqlHelper.db!.update(
              'clients',
              {
                'name': nameTextFeildController.text,
                'address': addressTextFeildController.text,
                'email': emailTextFeildController.text,
                'phone': phoneTextFeildController.text,
              },
              where: 'id =?',
              whereArgs: [widget.client?.id]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                widget.client == null
                    ? 'Client added Successfully'
                    : 'Client updated Successfully',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '==========> Error is $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
