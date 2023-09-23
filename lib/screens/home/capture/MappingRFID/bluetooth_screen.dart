// ignore_for_file: library_private_types_in_public_api, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() {
    flutterBlue.startScan();
    flutterBlue.scanResults.listen((results) {
      setState(() {
        devices = results.cast<BluetoothDevice>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name),
                  subtitle: Text(devices[index].id.toString()),
                  onTap: () async {
                    try {
                      await devices[index].connect();
                      if (devices[index].state ==
                          BluetoothDeviceState.connected) {
                        // Connection successful, you can now interact with the device.
                        // You may want to navigate to a new screen or perform actions here.
                        debugPrint('Connected to ${devices[index].name}');

                        // Once connected, you can discover services and characteristics of the device
                        // by calling devices[index].discoverServices(). You can then interact with
                        // the specific services and characteristics provided by the device.

                        // For example, you can discover services like this:
                        // await devices[index].discoverServices();

                        // You can listen for changes in the device's state as well:
                        // devices[index].state.listen((state) {
                        //   if (state == BluetoothDeviceState.disconnected) {
                        //     // Handle disconnection
                        //     print('Disconnected from ${devices[index].name}');
                        //   }
                        // });
                      } else {
                        print('Failed to connect to ${devices[index].name}');
                      }
                    } catch (e) {
                      print('Error connecting to device: $e');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
