// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:zebra_rfid_sdk_plugin/zebra_event_handler.dart';
import 'package:zebra_rfid_sdk_plugin/zebra_rfid_sdk_plugin.dart';

class MappingRFIDScreen extends StatefulWidget {
  const MappingRFIDScreen({super.key});

  @override
  _MappingRFIDScreenState createState() => _MappingRFIDScreenState();
}

class _MappingRFIDScreenState extends State<MappingRFIDScreen> {
  String? _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Map<String?, RfidData> rfidDatas = {};
  ReaderConnectionStatus connectionStatus = ReaderConnectionStatus.UnConnection;
  addDatas(List<RfidData> datas) async {
    for (var item in datas) {
      var data = rfidDatas[item.tagID];
      if (data != null) {
        data.count;
        data.count = data.count + 1;
        data.peakRSSI = item.peakRSSI;
        data.relativeDistance = item.relativeDistance;
      } else {
        rfidDatas.addAll({item.tagID: item});
      }
    }
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ZebraRfidSdkPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.pink,
          title: Text(
            'Status  ${connectionStatus.index}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                'Running on: $_platformVersion\n',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Count: ${rfidDatas.length.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: PrimaryButtonWidget(
                      backgroungColor: AppColors.green,
                      text: "Read",
                      onPressed: () async {
                        ZebraRfidSdkPlugin.setEventHandler(
                          ZebraEngineEventHandler(
                            readRfidCallback: (datas) async {
                              addDatas(datas);
                            },
                            errorCallback: (err) {
                              ZebraRfidSdkPlugin.toast(err.errorMessage);
                            },
                            connectionStatusCallback: (status) {
                              setState(() {
                                connectionStatus = status;
                              });
                            },
                          ),
                        );
                        ZebraRfidSdkPlugin.connect();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: PrimaryButtonWidget(
                      backgroungColor: Colors.amber,
                      onPressed: () async {
                        setState(() {
                          rfidDatas = {};
                        });
                      },
                      text: "Clear",
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: PrimaryButtonWidget(
                      backgroungColor: AppColors.danger,
                      text: "Stop",
                      onPressed: () async {
                        ZebraRfidSdkPlugin.disconnect();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var key = rfidDatas.keys.toList()[index];
                      return ListTile(
                          title: Text(rfidDatas[key]?.tagID ?? 'null'));
                    },
                    itemCount: rfidDatas.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
