import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';

import 'package:qrscanner/src/utils/scan_utils.dart' as utils;

class MapasPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot ){

        if( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if( scans.length == 0 ) {
          return Center(child: Text('No hay información'));
        } 

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              child: Icon( Icons.delete ),
              ),
            onDismissed: ( direction ) => scansBloc.borrarScan( scans[i].id ),
            child: ListTile(
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor ),
              title: Text(scans[i].valor),
              subtitle: Text('ID: ${ scans[i].id }'),
              trailing: Icon(Icons.keyboard_arrow_right, color:Colors.grey ),
              onTap: () => utils.launchURL(context, scans[i] ),
            ),
          )
        );
      },
    );
  }
}