import 'package:flutter/material.dart';
import 'package:qrscanner/src/models/scan_model.dart';

// import 'package:barcode_scan/barcode_scan.dart';

import 'package:qrscanner/src/pages/direcciones_page.dart';
import 'package:qrscanner/src/pages/mapas_page.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever ),
            onPressed: (){},
          )
        ],
      ),

      body: _callPage(currentIndex),
      bottomNavigationBar: _myBottomNavigationBar(),
      // Propiedad establece el button en el centro
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: _scanQR,
        backgroundColor: Theme.of( context ).primaryColor,
      ),

    );
  }

  _scanQR() async {

    // https://github.com/alejandrolgarcia
    // geo:40.64717223609039,-73.8013209386719
    
    String futureString = 'https://github.com/alejandrolgarcia';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch(e) {
    //   futureString = e.toString();
    // }

    // Grabar en SQLite
    if( futureString != null ) {
      
      final scan = ScanModel( valor: futureString );
      DBProvider.db.nuevoScan( scan );

    }
    
  }

  Widget _callPage( int paginaActual ){

    switch ( paginaActual ) {
      case 0: return MapasPage();
      case 1: return DireccionesPage(); 
      default:
        return MapasPage();
    }

  }

  Widget _myBottomNavigationBar(){

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: ( index ) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.directions ),
          title: Text('Direcciones')
        ),
      ],


    );

  }
}