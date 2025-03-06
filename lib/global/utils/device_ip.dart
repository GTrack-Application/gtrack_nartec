import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Gets the local IP address of the device.
/// This function tries multiple methods to retrieve the IP address.
/// Returns the IP address as a string, or an empty string if unable to determine IP.
Future<String> getLocalIP() async {
  try {
    // Method 1: NetworkInterface (most reliable for getting local network IP)
    return await _getLocalIPFromNetworkInterface();
  } catch (e) {
    try {
      // Method 2: Try to get public IP if local IP fails
      return await getPublicIP();
    } catch (e) {
      debugPrint('Error getting IP address: $e');
      return '';
    }
  }
}

/// Gets the public/external IP address of the device.
/// Uses external services to determine public IP.
/// Returns the public IP as a string or empty string if unsuccessful.
Future<String> getPublicIP() async {
  try {
    // Try multiple services in case one fails
    final services = [
      'https://api.ipify.org',
      'https://api64.ipify.org',
      'https://checkip.amazonaws.com',
    ];

    for (final service in services) {
      try {
        final response = await http
            .get(Uri.parse(service))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          // Clean up response (remove newlines, etc.)
          return response.body.trim();
        }
      } catch (_) {
        // Try next service
        continue;
      }
    }

    // If all external services fail, try another approach
    return await _getLocalIPFromNetworkInterface();
  } catch (e) {
    debugPrint('Error getting public IP: $e');
    return '';
  }
}

/// Gets the local IP address using NetworkInterface
/// This tries to find the most appropriate non-loopback IPv4 address
Future<String> _getLocalIPFromNetworkInterface() async {
  try {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );

    // First, try to find interfaces that are likely to be the main connection
    // like Wi-Fi or Ethernet (commonly named en0, wlan0, eth0)
    final priorityInterfaces = ['en0', 'wlan0', 'eth0', 'wlp', 'enp'];

    // Check priority interfaces first
    for (var name in priorityInterfaces) {
      for (var interface in interfaces) {
        if (interface.name.toLowerCase().contains(name.toLowerCase())) {
          for (var addr in interface.addresses) {
            if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
              return addr.address;
            }
          }
        }
      }
    }

    // If no priority interface found, just get the first non-loopback IPv4 address
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
          return addr.address;
        }
      }
    }

    // If no suitable address found, return a fallback
    return '0.0.0.0';
  } catch (e) {
    debugPrint('Error getting local IP from network interface: $e');
    return '';
  }
}
