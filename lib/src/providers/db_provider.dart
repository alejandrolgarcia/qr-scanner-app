// Configuracion de SQLite
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  // Constructor privado
  DBProvider._();

  Future<Database> get database async {

    // Si ya existe se retorna la instancia
    if( _database != null ) return _database;

    // Si no existe se crea la instancia
    _database = await initDB();
    return _database;

  }

  initDB() async {

    // Obtener path de la db
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScansDB.db');

    // Crear la DB en SQLite
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')'
        );

      }
    );

  }

}