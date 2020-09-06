import 'dart:async';

import 'package:qrscanner/src/bloc/validator.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal(){
    // Obtener Scans de la Base de Datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  // Obtener todos los Scans
  obtenerScans() async {
    _scansController.sink.add( await DBProvider.db.getAllScans() );
  }

  // Insertar Scans
  agregarScan( ScanModel scan ) {
    DBProvider.db.nuevoScan( scan );
    obtenerScans();
  }

  // Borrar scans
  borrarScan( int id ) async {
    await DBProvider.db.deleteScan( id );
    obtenerScans();
  }

  borrarScanTodos() async {
    await DBProvider.db.deleteAllScan();
    obtenerScans();
  }

}