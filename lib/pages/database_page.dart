import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:final_project/widgets/app_eleveted_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppElevatedButton(
                label: 'BackUp Database',
                onPressed: () async {
                  final dbFolder = await getDatabasesPath();
                  File source1 = File('$dbFolder/pos.db');

                  Directory copyTo =
                      Directory("storage/emulated/0/Sqlite Backup");
                  if ((await copyTo.exists())) {
                    print("Path exist");
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                  } else {
                    print("not exist");
                    if (await Permission.storage.request().isGranted) {
                      // Either the permission was already granted before or the user just granted it.
                      await copyTo.create();
                    } else {
                      print('Please give permission');
                    }
                  }

                  String newPath = "${copyTo.path}/pos.db";
                  await source1.copy(newPath);

                  setState(() {
                    message = 'Successfully Copied DB';
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppElevatedButton(
                label: 'Delete Database',
                onPressed: () async {
                  var databasesPath = await getDatabasesPath();
                  var dbPath = ('$databasesPath/pos.db');
                  await deleteDatabase(dbPath);
                  setState(() {
                    message = 'Successfully deleted DB';
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppElevatedButton(
                label: 'Restore Database',
                onPressed: () async {
                  var databasesPath = await getDatabasesPath();
                  var dbPath = ('$databasesPath/pos.db');

                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File source = File(result.files.single.path!);
                    await source.copy(dbPath);
                    setState(() {
                      message =
                          'Successfully Restored DB you will need to restart the Application';
                    });
                  } else {
                    print('cancled');
                  }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
