import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/Identify/GLN/GLNProductsModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GLNInformationScreen extends StatefulWidget {
  const GLNInformationScreen({super.key, required this.employees});

  final GLNProductsModel employees;

  @override
  State<GLNInformationScreen> createState() => _GLNInformationScreenState();
}

class _GLNInformationScreenState extends State<GLNInformationScreen> {
  double currentLat = 0;
  double currentLong = 0;

  // markers
  Set<Marker> markers = {};

  bool isLoaded = false;
  bool isMapMoving = false;

  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        print('Location permission granted');
      }
    }

    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.location]!.isGranted) {
    } else {}
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission().then((_) {
      setState(() {
        currentLat = double.parse(widget.employees.latitude.toString());
        currentLong = double.parse(widget.employees.longitude.toString());
        markers.add(
          Marker(
            markerId: MarkerId(widget.employees.id.toString()),
            position: LatLng(
              double.parse(widget.employees.latitude.toString()),
              double.parse(widget.employees.longitude.toString()),
            ),
            infoWindow: const InfoWindow(title: 'Location'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    markers.clear();
    super.dispose();
  }

  void _navigateToFullScreenMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenMap(
          currentLat: currentLat,
          currentLong: currentLong,
          markers: markers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: context.height() * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.skyBlue,
                  AppColors.skyBlue.withOpacity(0.5),
                  AppColors.skyBlue.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(color: AppColors.skyBlue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    finish(context);
                  },
                ),
                const Text(
                  'View GLN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
          10.height,
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: context.height() * 0.1,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(151, 235, 159, 1),
            ),
            child: ListTile(
              title: const Text(
                'Verifired By GS1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Image.asset(
                'assets/icons/gs1_check.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
          10.height,
          Container(
            height: context.height() * 0.2,
            width: context.width() * 1,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.employees.id!,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2, // Set the border width
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${AppUrls.baseUrlWith3093}${widget.employees.image?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_outlined),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("QR Code",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: PrettyQrView.data(
                        data: widget.employees.gLNBarcodeNumber ?? "null",
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Certificate",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        child: Image.asset('assets/icons/certificate.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          KeyValueInfoWidget(
            keyy: 'Product Id',
            value: widget.employees.productId ?? "null",
          ),
          KeyValueInfoWidget(
            keyy: 'Location Name',
            value: widget.employees.locationNameEn ?? "null",
          ),
          KeyValueInfoWidget(
            keyy: 'GLN Barcode Number',
            value: widget.employees.gLNBarcodeNumber ?? "null",
          ),
          KeyValueInfoWidget(
            keyy: 'GLN Identification',
            value: widget.employees.glnIdenfication ?? "null",
          ),
          KeyValueInfoWidget(
            keyy: 'Physical Location',
            value: widget.employees.physicalLocation ?? "null",
          ),
          10.height,
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.grey,
                    width: 1,
                  ),
                ),
                child: GestureDetector(
                  onVerticalDragStart: (_) {
                    setState(() {
                      isMapMoving = true;
                    });
                  },
                  onVerticalDragEnd: (_) {
                    setState(() {
                      isMapMoving = false;
                    });
                  },
                  child: IgnorePointer(
                    ignoring: isMapMoving,
                    child: !isLoaded
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GoogleMap(
                              onMapCreated: onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(currentLat, currentLong),
                                zoom: 14,
                              ),
                              mapType: MapType.normal,
                              scrollGesturesEnabled: true,
                              gestureRecognizers: <Factory<
                                  OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                              markers: markers,
                              buildingsEnabled: true,
                              compassEnabled: true,
                              indoorViewEnabled: true,
                              mapToolbarEnabled: true,
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => _navigateToFullScreenMap(context),
                  child: const Icon(Icons.fullscreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FullScreenMap extends StatelessWidget {
  final double currentLat;
  final double currentLong;
  final Set<Marker> markers;

  const FullScreenMap({
    Key? key,
    required this.currentLat,
    required this.currentLong,
    required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLat, currentLong),
          zoom: 14,
        ),
        markers: markers,
        buildingsEnabled: true,
        compassEnabled: true,
        indoorViewEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}

class KeyValueInfoWidget extends StatelessWidget {
  const KeyValueInfoWidget({
    super.key,
    required this.keyy,
    required this.value,
  });

  final String keyy;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(2),
              color: AppColors.primary,
              child: Text(
                keyy,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          10.width,
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(right: 10),
              color: Colors.grey.withOpacity(0.4),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
