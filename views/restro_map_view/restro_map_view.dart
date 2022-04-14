import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/widgets/display/restro/restro_info.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestroMapView extends StatelessWidget {
  final Restro restro;
  const RestroMapView({required this.restro, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StaticAppBar(
          title: "在地圖上尋找",
          leading: GTIconButton(
              foregroundColor: StandardColor.yellow,
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Stack(fit: StackFit.expand, children: [
          GoogleMap(
              compassEnabled: false,
              trafficEnabled: false,
              liteModeEnabled: false,
              buildingsEnabled: false,
              indoorViewEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              initialCameraPosition:
                  CameraPosition(zoom: 18, target: restro.location),
              myLocationEnabled: false,
              markers: {
                Marker(markerId: MarkerId(restro.id), position: restro.location)
              }),
          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              left: 0,
              child: SafeArea(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5, color: StandardColor.lightYellow),
                          color: Colors.white,
                          borderRadius: StandardSize.generalChipBorderRadius,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.06),
                                blurRadius: 10,
                                spreadRadius: 10)
                          ]),
                      child: RestroInfo(restro: restro, trim: true))))
        ]));
  }
}
