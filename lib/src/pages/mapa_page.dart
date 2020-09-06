import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qrscanner/src/models/scan_model.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = MapController();

  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.my_location ),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),

      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante( context, scan ),

    );
  }

  Widget _crearBotonFlotante(BuildContext context, ScanModel scan){

    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){

        if (tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
          print(tipoMapa);
        } else if(tipoMapa == 'dark-v10') {
          tipoMapa = 'light-v10';
          print(tipoMapa);
        } else if(tipoMapa == 'light-v10') {
          tipoMapa = 'outdoors-v11';
          print(tipoMapa);
        } else if(tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-streets-v11';
          print(tipoMapa);
        } else {
          tipoMapa = 'streets-v11';
          print(tipoMapa);
        }

        setState((){});

        map.move(scan.getLatLng(), 30);

        Future.delayed(Duration(milliseconds: 50), (){
          map.move(scan.getLatLng(), 15);
        });

      },
    );

  }

  Widget _crearFlutterMap(ScanModel scan) {

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores( scan )
      ],
    );

  }

  LayerOptions _crearMapa(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
      '{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoibGFsZWphbmRybyIsImEiOiJja2VxYXlhNnkwemY0MzRudDR2bXdpc2ZpIn0.ZjKOcm_-laN_fmq_9z8isA',
        'id': 'mapbox/$tipoMapa', 
        /*
         mapbox/streets-v11
         mapbox/outdoors-v11
         mapbox/light-v10
         mapbox/dark-v10
         mapbox/satellite-v9
         mapbox/satellite-streets-v11
        */
      }
    );
  }

  _crearMarcadores(ScanModel scan) {

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (BuildContext context ) => Container(
            child: Icon(
              Icons.location_on,
              size: 50.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]
    );

  }
}