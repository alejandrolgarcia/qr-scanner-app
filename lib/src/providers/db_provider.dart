// Configuracion de SQLite
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrscanner/src/models/scan_model.dart';
export 'package:qrscanner/src/models/scan_model.dart';

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

  // METODOS PARA CREAR REGISTROS
  nuevoScanRaw( ScanModel nuevoScan ) async {

    // espera a que la DB este lista
    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO Scans (id, tipo, valor) "
      "VALUES (${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }')"
    );
    return res;

  }

  nuevoScan( ScanModel nuevoScan ) async {

    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;

  }

  // SELECT - Obtener información
  Future<ScanModel> getScanId( int id ) async {

    final db = await database;
    final res = await db.query( 'Scans', where: 'id = ?', whereArgs: [id] );
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;

  }

  Future<List<ScanModel>> getAllScans() async {

    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                         ? res.map( (scan) => ScanModel.fromJson( scan ) ).toList()
                         : [];
    
    return list;

  }

  Future<List<ScanModel>> getScansForType( String tipo ) async {

    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                         ? res.map( (scan) => ScanModel.fromJson( scan ) ).toList()
                         : [];
    
    return list;

  }

  // Actualizar Registros
  Future<int> updateScan( ScanModel nuevoScan ) async {

    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id] );
    return res;

  }

  // Borrar registros
  Future<int> deleteScan( int id ) async {

    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;

  }

    Future<int> deleteAllScan() async {

    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;

  }

}