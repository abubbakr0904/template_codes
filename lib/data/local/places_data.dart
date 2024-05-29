import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:template_codes/data/model/region_model.dart';
import 'package:template_codes/data/network_responce/network_responce.dart';

class PlacesDatabase {
  static final PlacesDatabase instance = PlacesDatabase._init();

  PlacesDatabase._init();

  factory PlacesDatabase() {
    return instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createAndInitializeDatabase();
      return _database!;
    }
  }

  Future<Database> createAndInitializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final databaseFilePath = join(databasePath, 'my_database.db');

    final database = await openDatabase(databaseFilePath, version: 1,
        onCreate: (Database db, int version) async {
          // Read and execute SQL script here
          final scriptContent =
          await rootBundle.loadString('assets/sql/places.sql');
          final statements = scriptContent.split(';');

          for (final statement in statements) {
            if (statement.trim().isNotEmpty) {
              await db.execute(statement);
            }
          }
        });

    return database; // Return the created database
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    final db = await instance.database;
    return await db.rawQuery(query);
  }

  // Future<List<RegionModel>> searchRegionsByName(String query) async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'regions',
  //     where: 'name LIKE ?',
  //     whereArgs: ['%$query%'],
  //   );
  //   return maps.map((e) => RegionModel.fromJson(e)).toList();
  // }

  // Future<List<RegionModel>> searchDistrictsByName(String query) async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'districts',
  //     where: 'name LIKE ?',
  //     whereArgs: ['%$query%'],
  //   );
  //   return maps.map((e) => RegionModel.fromJson(e)).toList();
  // }

  // Future<List<RegionModel>> searchQuartersByName(String query) async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'quarters',
  //     where: 'name LIKE ?',
  //     whereArgs: ['%$query%'],
  //   );
  //   return maps.map((e) => RegionModel.fromJson(e)).toList();
  // }

  // Future<List<RegionModel>> getDistrictById({required int id}) async {
  //   List<RegionModel> districtsById = [];
  //   final db = await instance.database;
  //   districtsById = (await db
  //       .query('districts', where: 'region_id LIKE ?', whereArgs: ['%$id']))
  //       .map((e) => RegionModel.fromJson(e))
  //       .toList();
  //   return districtsById;
  // }

  // Future<List<RegionModel>> getQuarterById({required int id}) async {
  //   List<RegionModel> quarterById = [];
  //   final db = await instance.database;
  //   quarterById = (await db.query('quarters',
  //       where: 'district_id LIKE ?', whereArgs: ['%$id']))
  //       .map((e) => RegionModel.fromJson(e))
  //       .toList();
  //
  //   return quarterById;
  // }

  Future<NetworkResponse> getAllRegions() async {
    NetworkResponse networkResponse = NetworkResponse();
    try{
      List<RegionModel> allRegions = [];
      final db = await instance.database;
      allRegions = (await db.query('regions'))
          .map((e) => RegionModel.fromJson(e))
          .toList();
      networkResponse.data = allRegions;
      return networkResponse;
    }
    catch(error){
      networkResponse.errorText = error.toString();
      return networkResponse;
    }
  }

  // Future<List<RegionModel>> getRegionById({required int id}) async {
  //   List<RegionModel> regionsById = [];
  //   final db = await instance.database;
  //   regionsById =
  //       (await db.query('regions', where: 'id LIKE ?', whereArgs: ['%$id']))
  //           .map((e) => RegionModel.fromJson(e))
  //           .toList();
  //   return regionsById;
  // }

  Future<NetworkResponse> getAllDistricts() async {
    NetworkResponse networkResponse = NetworkResponse();
    try{
      List<RegionModel> allDistricts = [];
      final db = await instance.database;
      allDistricts = (await db.query('districts'))
          .map((e) => RegionModel.fromJson(e))
          .toList();
      networkResponse.data = allDistricts;
      return networkResponse;
    }
    catch(error){
      networkResponse.errorText = error.toString();
      return networkResponse;
    }
  }

  Future<NetworkResponse> getAllQuarters() async {
    NetworkResponse networkResponse = NetworkResponse();

    try{
      List<RegionModel> allQuarters = [];
      final db = await instance.database;
      allQuarters = (await db.query('quarters'))
          .map((e) => RegionModel.fromJson(e))
          .toList();
      networkResponse.data = allQuarters;
      return networkResponse;
    }
    catch(error){
      networkResponse.errorText = error.toString();
      return networkResponse;
    }
  }
}