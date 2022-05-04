import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'place_detail.dart';

const kGoogleApiKey = "AIzaSyAb08AF5S_s4bQGFNFchFN4F9jT_TzskL4";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {

    Widget expandedChild;
    if (isLoading) {
      expandedChild = const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      expandedChild = Center(
        child: Text(errorMessage ?? 'hello'),
      );
    } else {
      expandedChild = buildPlacesList();
    }

    return Scaffold(
      key: homeScaffoldKey,
      backgroundColor: const Color(0xffECF1FA),
      appBar: AppBar(
        title: Text('Chemist Near Me'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset(
            //   'assets/logo.png',
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 8.0),
            //   child: Text(
            //     'Location',
            //     style: TextStyle(
            //       fontFamily: 'Lato',
            //       fontSize: 24,
            //       color: Color(0xff181461),
            //       fontWeight: FontWeight.w700,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            ///
            SizedBox(
              height: 500.0,
              child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers.values),
              initialCameraPosition: const CameraPosition(
                  target: LatLng(0.0, 0.0)
              ),
              ),
            ),
            Expanded(
                child: buildPlacesList(),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    getNearbyPlaces(center!);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  Future<LatLng?> getUserLocation() async {
    LocationManager.LocationData _locationData;
    Map<String, double>? currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      _locationData = await location.getLocation();
      final lat = _locationData.latitude;
      final lng = _locationData.longitude;
      final center = LatLng(lat!, lng!);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final location = Location(lat: center.latitude, lng: center.longitude);
    final result = await _places.searchByText('chemist near me', location: location);
    print(result);
    print(result.results.first.name);
    print(result.results.first);
    print(result.results.length);
    print(result.status);
    print(result.isInvalid);
    print(result.isNotFound);
    setState(() {
      if (result.status == "OK") {
        places = result.results;
        print(places);
        print(places.length);
        for (var f in result.results) {
          final Marker markerOptions = Marker(
              position: LatLng(f.geometry!.location.lat, f.geometry!.location.lng),
              infoWindow: InfoWindow(title: f.name, snippet: f.types.first),
              markerId: MarkerId(f.name)
          );
          setState(() {
            // adding a new marker to map
            markers[MarkerId(f.name)] = markerOptions;
          });
        }
      } else {
        errorMessage = result.errorMessage;
      }

      isLoading = false;
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    final snackBar = SnackBar(
      content: Text(response.errorMessage ?? ''),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> showDetailPlace(String placeId) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
    );
  }

  Widget buildPlacesList() {
    print('length : ${places.length}');

    return isLoading == true ? errorMessage != null ?  Center(
      child: Text(errorMessage ?? 'hello'),
    ) : Center(child: CircularProgressIndicator()) : ListView(
        shrinkWrap: true,
        children: places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        )
      ];
      if (f.formattedAddress != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.formattedAddress ?? '${f.formattedAddress}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ));
      }

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.vicinity ?? '${f.vicinity}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ));
      }

      if (f.types.first != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: Theme.of(context).textTheme.caption,
          ),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showDetailPlace(f.placeId);
            },
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList());
  }
}
