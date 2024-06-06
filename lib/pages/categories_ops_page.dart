// ignore_for_file: prefer_const_constructors

import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:final_project/widgets/app_eleveted_button.dart';
import 'package:final_project/widgets/app_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class CategoriesOpsPage extends StatefulWidget {
  PosCategory? posCategory;
  CategoriesOpsPage({this.posCategory, super.key});

  @override
  State<CategoriesOpsPage> createState() => _CategoriesOpsPageState();
}

class _CategoriesOpsPageState extends State<CategoriesOpsPage> {
  late TextEditingController nameTextFeildController;
  late TextEditingController descriptionTextFeildController;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nameTextFeildController =
        TextEditingController(text: widget.posCategory?.name ?? '');
    descriptionTextFeildController =
        TextEditingController(text: widget.posCategory?.description ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.posCategory == null ? 'Add New' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                labelText: 'description',
                controller: descriptionTextFeildController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter valid description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppElevatedButton(
                label: widget.posCategory == null ? 'Submit' : 'Edit Category',
                onPressed: () async {
                  await onSubmit();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    try {
      var sqlHelper = GetIt.I
          .get<SqlHelper>()
          .db!
          .insert('categories', conflictAlgorithm: ConflictAlgorithm.replace, {
        'name': nameTextFeildController.text,
        'description': descriptionTextFeildController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Category Added Successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '==========> Error is $e',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
