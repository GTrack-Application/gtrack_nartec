// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
// import 'package:solitaire/constants/constant.dart';
// import 'package:solitaire/cubit/auth/auth_cubit.dart';

class NFCScanDialog extends StatefulWidget {
  const NFCScanDialog({
    super.key,
    this.serialNumber,
    // required this.authCubit,
  });

  final String? serialNumber;
  // final AuthCubit authCubit;

  @override
  State<NFCScanDialog> createState() => _NFCScanDialogState();
}

class _NFCScanDialogState extends State<NFCScanDialog> {
  bool _isScanning = false;
  bool _isLoggingIn = false;

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
          AppSnackbars.danger(
            context,
            'NFC is not available on this device',
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

            // For ISO 14443-4 tags (as shown in your image)
            if (nfcData['iso14443-4'] != null) {
              // The identifier/serial number is usually in the historical bytes
              final identifier = nfcData['iso14443-4']['identifier'];
              if (identifier != null) {
                // Convert bytes to hex string and format it
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
              // Login with the NFC serial number
              await _loginWithNFC(serialNumber);
            } else {
              if (mounted) {
                Navigator.pop(context);
                AppSnackbars.danger(
                  context,
                  'Failed to read NFC serial number',
                );
              }
            }
          } catch (e) {
            if (mounted) {
              AppSnackbars.danger(
                context,
                'Error reading NFC: $e',
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppSnackbars.danger(
          context,
          'Error: $e',
        );
      }
    }
  }

  Future<void> _loginWithNFC(String nfcNumber) async {
    try {
      // Set loading state to true
      setState(() {
        _isScanning = false;
        _isLoggingIn = true;
      });

      final response = await http.post(
        Uri.parse('${AppUrls.gtrack}/api/memberSubUser/login/nfc'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'nfcNumber': nfcNumber}),
      );

      print(response.body);

      if (mounted) {
        Navigator.pop(context);

        if (response.statusCode == 200) {
          // Successful login
          final responseData = jsonDecode(response.body);
          // Handle successful login - e.g., store auth token, navigate to home page
          print('Login successful: $responseData');
          AppSnackbars.success(
            context,
            'Login successful',
          );

          AppNavigator.goToPage(
            context: context,
            screen: const HomeScreen(),
          );

          // You might want to add navigation or other success handling here
        } else {
          // Login failed
          AppSnackbars.danger(
            context,
            'Login failed: ${response.reasonPhrase}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppSnackbars.danger(
          context,
          'Login error: $e',
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
              _isLoggingIn ? 'Logging In...' : 'Ready to Scan?',
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
              child: _isLoggingIn
                  ? const CircularProgressIndicator(
                      color: AppColors.primary,
                    )
                  : Image.asset('assets/icons/nfc.png'),
            ),
            const SizedBox(height: 20),
            Text(
              _isLoggingIn
                  ? 'Please wait while we log you in'
                  : 'Hold or Tap your phone\nnear object to scan',
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
                onPressed: _isLoggingIn
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
