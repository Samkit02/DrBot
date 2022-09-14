import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "key";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class PlaceDetailWidget extends StatefulWidget {
  late String placeId;

  PlaceDetailWidget(this.placeId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlaceDetailState();
  }
}

class PlaceDetailState extends State<PlaceDetailWidget> {
  late GoogleMapController mapController;
  late PlacesDetailsResponse place;
  bool isLoading = false;
  late String errorLoading;

  @override
  void initState() {
    fetchPlaceDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyChild;
    String title;
    if (isLoading) {
      title = "Loading";
      bodyChild = Center(
        child: CircularProgressIndicator(),
      );
    }
    // else if (errorLoading != null) {
    //   title = "";
    //   bodyChild = Center(
    //     child: Text(errorLoading),
    //   );
    // }
    else {
      final placeDetail = place.result;
      final location = place.result.geometry!.location;
      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);

      title = placeDetail.name;
      bodyChild = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: SizedBox(
            height: 500.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(target: center, zoom: 15.0),
              markers: Set<Marker>.of(markers.values),
            ),
          )),
          Expanded(
            child: buildPlaceDetailList(placeDetail),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: bodyChild);
  }

  void fetchPlaceDetail() async {
    setState(() {
      this.isLoading = true;
      this.errorLoading = '';
    });

    PlacesDetailsResponse place =
        await _places.getDetailsByPlaceId(widget.placeId);
    print(place.result.name);
    print(place);
    print(place.status);
    print(place.isInvalid);
    print(place.isNotFound);

    if (mounted) {
      setState(() {
        this.isLoading = false;
        if (place.status == "OK") {
          this.place = place;
        } else {
          this.errorLoading = place.errorMessage!;
        }
      });
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final placeDetail = place.result;
    final MarkerId markerId = MarkerId(placeDetail.name);
    final location = place.result.geometry!.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);
    Marker markerOptions = Marker(
        position: center,
        infoWindow: InfoWindow(
            title: placeDetail.name, snippet: "${placeDetail.formattedAddress}"),
        markerId: (markerId));
    setState(() {
      // adding a new marker to map
      markers[markerId] = markerOptions;
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 15.0)));
  }

  String buildPhotoURL(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${kGoogleApiKey}";
  }

  ListView buildPlaceDetailList(PlaceDetails placeDetail) {
    List<Widget> list = [];
    if (placeDetail.photos != null) {
      final photos = placeDetail.photos;
      list.add(SizedBox(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.only(right: 1.0),
                    child: SizedBox(
                      height: 100,
                      child: Image.network(
                          buildPhotoURL(photos[index].photoReference)),
                    ));
              })));
    }

    list.add(
      Padding(
          padding:
              EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            placeDetail.name,
            style: Theme.of(context).textTheme.subtitle1,
          )),
    );

    if (placeDetail.formattedAddress != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedAddress ?? '',
              style: Theme.of(context).textTheme.bodyText2,
            )),
      );
    }

    if (placeDetail.types.first != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 0.0),
            child: Text(
              placeDetail.types.first.toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.formattedPhoneNumber != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedPhoneNumber ?? '',
              style: Theme.of(context).textTheme.button,
            )),
      );
    }

    if (placeDetail.openingHours != null) {
      final openingHour = placeDetail.openingHours;
      var text = '';
      if (openingHour!.openNow) {
        text = 'Opening Now';
      } else {
        text = 'Closed';
      }
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.website != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.website ?? '',
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.rating != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              "Rating: ${placeDetail.rating}",
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: list,
    );
  }
}
