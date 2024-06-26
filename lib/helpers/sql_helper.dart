import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  Database? db;

  Future<void> registerForeignKeys() async {
    await db!.rawQuery('PRAGMA foreign_keys = on');
    var result = await db!.rawQuery('PRAGMA foreign_keys');
    print(result);
  }

  Future<bool> createTables() async {
    try {
      await registerForeignKeys();

      var batch = db!.batch();

      batch.rawQuery("""
      PRAGMA foreign_keys
      """);

      batch.execute("""
      Create table If not exists categories(
      id integer primary key,
      name text,
      description text
      )""");
      batch.execute("""
      Create table If not exists products(
      id integer primary key,
      name text,
      description text,
      price double,
      stock integer,
      isAvaliable boolean,
      image text,
      categoryId integer,
      foreign key (categoryId) REFERENCES categories(id)
      ON DELETE RESTRICT
      )""");
      batch.execute("""
      Create table If not exists clients(
      id integer primary key,
      name text,
      email text,
      phone text,
      address text
      )""");
      batch.execute("""
      Create table If not exists orders(
      id integer primary key,
      label text,
      totalPrice real,
      discount real,
      clientId integer,
      foreign key (clientId) REFERENCES clients(id)
      ON DELETE RESTRICT
      )""");
      batch.execute("""
      Create table If not exists orderProductItems(
      orderId integer,
      productCount integer,
      productId integer,
      foreign key (productId) REFERENCES products(id)
      ON DELETE RESTRICT
      )""");
      batch.execute("""
      Create table If not exists exchangeRate(
      id integer primary key,
      usd double,
      egp double
      )""");

      var result = await batch.commit();

      print('tables Created Successfully: $result');
      return true;
    } catch (e) {
      print('error in create tables $e');
      return false;
    }
  }

  Future<void> initDb() async {
    try {
      if (kIsWeb) {
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('pos.db');
        var sqliteVersion =
            (await db!.rawQuery('select sqlite_version()')).first.values.first;

        print('===================> Db Created and version is $sqliteVersion');
      } else {
        db = await openDatabase(
          'pos.db',
          version: 1,
          onCreate: (db, version) {
            print('=================== Db Created');
          },
        );
        String path = await getDatabasesPath();
        print('>>>>>>>>>>>>>>>>>>>>> $path');
      }
    } catch (e) {
      print('error in create db : $e');
    }
  }
}
