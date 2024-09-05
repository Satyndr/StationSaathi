import "dart:io";
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:situm_flutter/sdk.dart';
import 'package:situm_flutter/wayfinding.dart';
import 'package:stationsathi/main.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapViewController? mapViewController;

  @override
  void initState() {
    super.initState();
    // Initialize SitumSdk class
    _useSitum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Situm Flutter'),
      ),
      body: Center(
        child: MapView(
          key: const Key("situm_map"),
          configuration: MapViewConfiguration(
            situmApiKey: situmApiKey,
            buildingIdentifier: buildingIdentifier,
          ),
          onLoad: _onLoad, onError: (MapViewError error) {  },
        ),
      ),
    );
  }

  void _onLoad(MapViewController controller) {
    mapViewController = controller;
    debugPrint("Situm> wayfinding> Map successfully loaded.");
    controller.onPoiSelected((poiSelectedResult) {
      debugPrint("Situm> wayfinding> Poi selected: ${poiSelectedResult.poi.name}");
    });
  }

  //Step 4 - Positioning
  void _useSitum() async {
    var situmSdk = SitumSdk();
    // Set up your credentials
    situmSdk.init();
    situmSdk.setApiKey(situmApiKey);
    // Set up location callbacks:
    situmSdk.onLocationUpdate((location) {
      debugPrint("Situm> sdk> Location updated: ${location.toMap().toString()}");
    });
    situmSdk.onLocationStatus((status) {
      debugPrint("Situm> sdk> Status: $status");
    });
    situmSdk.onLocationError((error) {
      debugPrint("Situm> sdk> Error: ${error.message}");
    });
    // Check permissions:
    var hasPermissions = await _requestPermissions();
    if (hasPermissions) {
      situmSdk.requestLocationUpdates(LocationRequest());
    } else {
      // Handle permissions denial.
      debugPrint("Situm> sdk> Permissions denied!");
    }
  }

  // Requests positioning permissions
  Future<bool> _requestPermissions() async {
    var permissions = <Permission>[
      Permission.locationWhenInUse,
    ];
    if (Platform.isAndroid) {
      permissions.addAll([
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ]);
    } else if (Platform.isIOS) {
      permissions.add(Permission.bluetooth);
    }
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }
}