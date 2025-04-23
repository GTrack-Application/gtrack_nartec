// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';

class RegisterNFCDialog extends StatefulWidget {
  const RegisterNFCDialog({
    super.key,
    required this.isNfcEnabled,
  });

  final bool isNfcEnabled;

  @override
  State<RegisterNFCDialog> createState() => _RegisterNFCDialogState();
}

class _RegisterNFCDialogState extends State<RegisterNFCDialog> {
  bool _isScanning = false;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _startNFCScan();
  }

  Future<void> _startNFCScan() async {
    setState(() => _isScanning = true);

    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (!isAvailable) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('NFC is not available on this device')),
          );
        }
        return;
      }

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final nfcData = tag.data;

            // Extract serial number from NFC data
            String? serialNumber;

            // For ISO 14443-4 tags
            if (nfcData['iso14443-4'] != null) {
              final identifier = nfcData['iso14443-4']['identifier'];
              if (identifier != null) {
                serialNumber = identifier
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':')
                    .toUpperCase();
              }
            }

            // Alternative method to get identifier (works with most NFC tags)
            if (serialNumber == null && nfcData['nfca'] != null) {
              final identifier = nfcData['nfca']['identifier'];
              if (identifier != null) {
                serialNumber = identifier
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':')
                    .toUpperCase();
              }
            }

            if (serialNumber != null && mounted) {
              setState(() {
                _isScanning = false;
                _isRegistering = true;
              });

              // Register the NFC card with the user
              await _registerNFCCard(serialNumber);
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to read NFC card')),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error reading NFC: $e')),
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _registerNFCCard(String nfcNumber) async {
    final token = await AppPreferences.getToken();
    final userId = await AppPreferences.getUserId();
    try {
      final response = await http.put(
        Uri.parse('${AppUrls.gtrack}/api/memberSubUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode({
          'isNFCEnabled': widget.isNfcEnabled,
          'nfcNumber': nfcNumber,
        }),
      );

      if (mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context, nfcNumber);
          AppPreferences.setNfcEnabled(true);
          AppSnackbars.success(
            context,
            'NFC card registered successfully',
          );
        } else {
          Navigator.pop(context);
          AppSnackbars.danger(
            context,
            'Failed to register NFC card: ${response.body}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppSnackbars.danger(
          context,
          'Error registering NFC card: $e',
        );
      }
    }
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRegistering ? 'Registering NFC Card...' : 'Ready to Register?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 120,
              height: 120,
              child: _isRegistering
                  ? const CircularProgressIndicator(
                      color: AppColors.primary,
                    )
                  : Image.asset('assets/icons/nfc.png'),
            ),
            const SizedBox(height: 20),
            Text(
              _isRegistering
                  ? 'Please wait while we register your NFC card'
                  : 'Hold or Tap your phone\nnear the NFC card to register',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.grey,
                ),
                onPressed: _isRegistering
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
