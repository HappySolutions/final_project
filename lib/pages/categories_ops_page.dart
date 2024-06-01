import 'package:final_project/models/pos_category.dart';
import 'package:flutter/material.dart';

class CategoriesOpsPage extends StatefulWidget {
  final PosCategory? posCategory;
  const CategoriesOpsPage({this.posCategory, super.key});

  @override
  State<CategoriesOpsPage> createState() => _CategoriesOpsPageState();
}

class _CategoriesOpsPageState extends State<CategoriesOpsPage> {
  var nameTextFeildController = TextEditingController();
  var descriptionTextFeildController = TextEditingController();
  var formKey = GlobalKey<FormState>();
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
          child: const Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
