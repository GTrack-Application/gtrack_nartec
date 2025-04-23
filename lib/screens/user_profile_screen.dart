// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/screens/home/auth/services/nfc/register_nfc_dialog.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // appBar: AppBar(
      //   backgroundColor: AppColors.white,
      //   elevation: 0,
      //   title: const Text(
      //     'User Profile',
      //     style: TextStyle(
      //       color: AppColors.black,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //     onPressed: () => Navigator.pop(context),
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: AppColors.black,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: FutureBuilder(
          future: _loadUserData(),
          builder: (context, AsyncSnapshot<Map<String, String?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: AppColors.danger,
                  ),
                ),
              );
            } else {
              final userData = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: const Center(
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: 40,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userData['userName'] ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData['userEmail'] ?? 'No email available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildCard(
                      'Personal Information',
                      [
                        _buildProfileItem('User Name', userData['userName']),
                        _buildProfileItem('User Email', userData['userEmail']),
                        _buildProfileItem(
                            'Current User', userData['currentUser']),
                      ],
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      'GS1 Information',
                      [
                        _buildProfileItem('GS1 User ID', userData['gs1UserId']),
                        _buildProfileItem('GS1 Prefix', userData['gs1Prefix']),
                      ],
                      Icons.business_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      'Settings',
                      [
                        _buildSwitchItem(
                          'Enable NFC',
                          userData['nfcEnabled'] == 'true',
                          (value) async {
                            await AppPreferences.setNfcEnabled(value);
                            setState(() {});
                          },
                        ),
                      ],
                      Icons.settings_outlined,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children, IconData icon) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) async {
              if (newValue == true && label == 'Enable NFC') {
                // When enabling NFC, show the registration dialog
                final nfcNumber = await showDialog<String>(
                  context: context,
                  builder: (context) => RegisterNFCDialog(
                    isNfcEnabled: true,
                  ),
                );

                if (nfcNumber != null) {
                  // NFC registration was successful
                  print('Registered NFC number: $nfcNumber');
                  onChanged(newValue); // Update the switch state
                } else {
                  return;
                }
              } else {
                // For turning off NFC, call the API to disable it
                if (label == 'Enable NFC' && newValue == false) {
                  await _disableNFC();
                }
                // Update the switch state
                onChanged(newValue);
              }
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData() async {
    // Load all relevant user data from AppPreferences
    return {
      'userName': await AppPreferences.getUserName(),
      'userEmail': await AppPreferences.getUserEmail(),
      'currentUser': await AppPreferences.getCurrentUser(),
      'gs1UserId': await AppPreferences.getGs1UserId(),
      'gs1Prefix': await AppPreferences.getGs1Prefix(),
      'nfcEnabled': (await AppPreferences.getNfcEnabled()).toString(),
    };
  }

  // Add this new method to disable NFC
  Future<void> _disableNFC() async {
    // Store the context check result before async operations
    final currentContext = context;
    final isContextValid = mounted;

    final token = await AppPreferences.getToken();
    final userId = await AppPreferences.getUserId();

    try {
      final response = await http.put(
        Uri.parse('${AppUrls.gtrack}/api/memberSubUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode({'isNFCEnabled': false}),
      );

      print(response.body);

      // Check if the widget is still mounted before using context
      if (isContextValid && mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AppPreferences.setNfcEnabled(false);
          AppSnackbars.success(
            currentContext,
            'NFC disabled successfully',
          );
        } else {
          AppSnackbars.danger(
            currentContext,
            'Failed to disable NFC',
          );
        }
      }
    } catch (e) {
      // Check if the widget is still mounted before using context
      if (isContextValid && mounted) {
        AppSnackbars.danger(
          currentContext,
          'Error disabling NFC: $e',
        );
      }
    }
  }
}
