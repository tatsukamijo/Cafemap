import 'dart:async';

import 'dart:io' show File;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cafe_map/shopdata.dart';
import 'package:flutter/services.dart';

class DBHelper {
  static Database? _db;
  static final DBHelper instance = DBHelper._createInstance();

  DBHelper._createInstance();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb('cafe_map.db');
    return _db!;
  }

  // DBをコピー
  _initDb(String filepath) async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, filepath);

    await deleteDatabase(dbPath);
    ByteData data = await rootBundle.load('assets/cafe_map.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return await openDatabase(dbPath);
  }
  // 全てのデータをDBから取得してリストを返す
  Future<List<Shopdata>> getAllShopdata() async {
    final db = await instance.db;

    final orderBy = '${Shopfields.id} ASC';

    final result = await db.query('shop_data', orderBy: orderBy);

    return result.map((json) => Shopdata.fromJson(json)).toList();
  }

  // 指定したidのデータをDBから取得して返す
  Future<Shopdata> getShopdataById(int id) async {
    final db = await instance.db;

    final maps = await db.query(
      tableShop,
      columns: Shopfields.values,
      where: '${Shopfields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Shopdata.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // 指定したidのデータをdelete. 今回はアプリからDBに変更加えないので使わない
  Future<int> delete(int id) async {
    final db = await instance.db;

    return await db.delete(
      tableShop,
      where: '${Shopfields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.db;

    db.close();
  }
}

