import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:pda_rfid_scanner/pda_rfid_scanner.dart';

class MappingRFIDScreen extends StatefulWidget {
  const MappingRFIDScreen({super.key});

  @override
  State<MappingRFIDScreen> createState() => _MappingRFIDScreenState();
}

class _MappingRFIDScreenState extends State<MappingRFIDScreen> {
  StreamSubscription? _streamSubscription;
  String _platformMessage = '';
  String status = 'off';

  void _enableEventReceiver() {
    _streamSubscription =
        PdaRfidScanner.channel.receiveBroadcastStream().listen(
      (dynamic event) {
        debugPrint('Received event: $event');
        setState(() {
          _platformMessage = event;
        });
      },
      onError: (dynamic error) {
        debugPrint('Received error: ${error.message}');
      },
      cancelOnError: true,
    );
  }

  void _disableEventReceiver() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
  }

  @override
  void initState() {
    _enableEventReceiver();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _disableEventReceiver();
  }

  powerOn() async {
    final value = await PdaRfidScanner.powerOn();
    setState(() {
      status = value;
    });
  }

  powerOff() async {
    final value = await PdaRfidScanner.powerOff();
    setState(() {
      status = value;
    });
  }

  startScan() async {
    final value = await PdaRfidScanner.scanStart();
    setState(() {
      status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Mapping RFID'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: PrimaryButtonWidget(
                    backgroungColor: AppColors.pink,
                    onPressed: () {
                      powerOn();
                    },
                    text: 'Power On',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: PrimaryButtonWidget(
                    backgroungColor: AppColors.pink,
                    onPressed: () {
                      powerOff();
                    },
                    text: "Power Off",
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: PrimaryButtonWidget(
                    backgroungColor: AppColors.pink,
                    onPressed: () {
                      startScan();
                    },
                    text: "Start Scan",
                  ),
                ),
                const SizedBox(height: 20),
                Text('Running on: \n $_platformMessage'),
                const SizedBox(height: 10),
                Text('The Scanned Value is: $status'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
