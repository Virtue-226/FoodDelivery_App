import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // Location _locationTracker = Location();
  // StreamSubscription _locationSubcription;
  // Marker marker;
  // Circle circle;
  // GoogleMapController _controller;

   static final CameraPosition initialLocation = CameraPosition(
     target: LatLng(37.42796133580604,-127.085749655962),
     zoom: 14.4746,
     );

  //    Future<Uint8List> getMarker() async {
  //      ByteData byteData = await DefaultAssetBundle.of(context).load("");
  //      return byteData.buffer.asUint8List();
  //    }

  //    void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData){
  //      LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
  //      this.setState(() {
  //        marker = Marker(
  //          markerId: MarkerId(""),
  //          position: latlng,
  //          rotation: newLocalData.heading,
  //          draggable: false,
  //          zIndex:  2,
  //          flat: true,
  //          anchor: Offset(0.5,0.5),
  //          icon: BitmapDescriptor.fromBytes(imageData)

  //        );
  //        circle = Circle(
  //          circleId: CircleId(""),
  //          radius: newLocalData.accuracy,
  //          zIndex: 1,
  //          strokeColor: Colors.blue,
  //          center: latlng,
  //          fillColor: Colors.blue.withAlpha(70)
  //          );
  //      });
  // }
  //  void getCurrentLocation() async{
  //    try {
  //     Uint8List imageData = await getMarker() ;
  //     var location = await _locationTracker.getLocation();

  //     updateMarkerAndCircle(location, imageData);
  //     if(_locationSubcription != null){
  //      _locationSubcription.cancel();
  //     }
  //     _locationSubcription = _locationTracker.onChangedLocation().listen((newLocalData){
  //       if(_controller != null){
  //         _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //           bearing:192.8334901395799,
  //           target: LatLng(newLocalData.latitude, newLocalData.longitude),
  //           tilt: 0,
  //           zoom: 18.00 )));
  //           updateMarkerAndCircle(newLocalData, imageData);
  //       }
  //     }); } catch(e){
  //       if(e.code =="PERMISSION _DENIED"){
  //         debugPrint("Permission Denied");
  //       }
  //     }
  //    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Order",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      // body: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height:MediaQuery.of(context).size.height,
      //   color: Colors.grey.shade300,

          body: GoogleMap(
        initialCameraPosition: initialLocation,
        mapType: MapType.normal,
        // markers: Set.of((marker != null)? [marker]: []),
        // circles : Set.of((circle != null)? [circle]: []),
        // onMapCreated: (GoogleMapController controller){
        //   _controller = controller;
        // },
      ),
    //   floatingActionButton : FloatingActionButton(
    //      child: Icon(Icons.location_searching),
    //      onPressed: (){
    //        getCurrentLocation();
    //      }
    //       ,)
     );
  }
}
