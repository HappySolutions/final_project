import 'package:final_project/helpers/sql_helper.dart';
import 'package:final_project/models/pos_category.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesDropDown extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;
  const CategoriesDropDown(
      {this.selectedValue, required this.onChanged, super.key});

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  List<PosCategory>? categories;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('categories');
      categories = [];
      if (data.isNotEmpty) {
        for (var item in data) {
          categories?.add(PosCategory.fromJson(item));
        }
      } else {
        categories = [];
      }
    } catch (e) {
      print('Error in get Categories $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return categories == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (categories?.isEmpty ?? false)
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
                            hint: const Text('Select Category'),
                            items: [
                              for (var category in categories!)
                                DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name ?? 'No Name'),
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
