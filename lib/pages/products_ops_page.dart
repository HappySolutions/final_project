import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_product.dart';
import 'package:final_project/widgets/app_eleveted_button.dart';
import 'package:final_project/widgets/app_text_form_feild.dart';
import 'package:final_project/widgets/categories_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class ProductsOpsPage extends StatefulWidget {
  final PosProduct? product;
  const ProductsOpsPage({this.product, super.key});

  @override
  State<ProductsOpsPage> createState() => _ProductsOpsPageState();
}

class _ProductsOpsPageState extends State<ProductsOpsPage> {
  late TextEditingController nameTextFeildController;
  late TextEditingController descriptionTextFeildController;
  late TextEditingController priceTextFeildController;
  late TextEditingController stockTextFeildController;
  late TextEditingController imageTextFeildController;
  int? selectedCategoryId;
  bool? isAvailable;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nameTextFeildController =
        TextEditingController(text: widget.product?.name ?? '');
    descriptionTextFeildController =
        TextEditingController(text: widget.product?.description ?? '');
    priceTextFeildController =
        TextEditingController(text: '${widget.product?.price ?? ''}');
    stockTextFeildController =
        TextEditingController(text: '${widget.product?.stock ?? ''}');
    imageTextFeildController =
        TextEditingController(text: widget.product?.image ?? '');
    selectedCategoryId = widget.product?.categoryId;
    isAvailable = widget.product?.isAvailable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add New' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
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
                AppTextFormFeild(
                  labelText: 'Image URL',
                  controller: imageTextFeildController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormFeild(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        labelText: 'Price',
                        controller: priceTextFeildController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AppTextFormFeild(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        labelText: 'Stock',
                        controller: stockTextFeildController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter valid stock';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CategoriesDropDown(
                  selectedValue: selectedCategoryId,
                  onChanged: (value) {
                    selectedCategoryId = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('Is product availbale'),
                    const SizedBox(width: 10),
                    Switch(
                      value: isAvailable ?? false,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                AppElevatedButton(
                  label: widget.product == null ? 'Submit' : 'Edit Product',
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
        //Add Product logic
        if (widget.product == null) {
          sqlHelper.db!.insert(
              'products',
              conflictAlgorithm: ConflictAlgorithm.replace,
              {
                'name': nameTextFeildController.text,
                'description': descriptionTextFeildController.text,
                'price': double.parse(priceTextFeildController.text),
                'stock': double.parse(stockTextFeildController.text),
                'image': imageTextFeildController.text,
                'categoryId': selectedCategoryId,
                'isAvaliable': isAvailable ?? false,
              });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Product Added Successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          Navigator.pop(context, true);
        } else //update product logic
        {
          sqlHelper.db!.update(
              'products',
              {
                'name': nameTextFeildController.text,
                'description': descriptionTextFeildController.text,
                'price': double.parse(priceTextFeildController.text),
                'stock': double.parse(stockTextFeildController.text),
                'image': imageTextFeildController.text,
                'categoryId': selectedCategoryId,
                'isAvaliable': isAvailable ?? false,
              },
              where: 'id =?',
              whereArgs: [widget.product?.id]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                widget.product == null
                    ? 'Product added Successfully'
                    : 'Product updated Successfully',
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
