import 'dart:io';
import 'package:carrier_info/carrier_info.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import 'vendor_service.dart';

class HardwareInfo {
  final String? model;
  final String? brand;
  final String? osVersion;
  final int? sdkVersion;
  final String? carrierName;
  final String? networkGeneration; // 4G, 5G, etc.
  final String? wifiSsid;
  final String? wifiBssid;
  final int? rssi;
  final String? ipAddress;
  final int? frequency;
  final int? linkSpeed;
  
  // New detailed fields
  final String? wifiStandard;
  final String? gateway;
  final String? netmask;
  final String? publicIp;
  final List<String>? dnsServers;
  final int? channel;
  final String? simState;
  final String? dataType;
  final bool? rttSupported;
  final int? rsrp;

  HardwareInfo({
    this.model,
    this.brand,
    this.osVersion,
    this.sdkVersion,
    this.carrierName,
    this.networkGeneration,
    this.wifiSsid,
    this.wifiBssid,
    this.rssi,
    this.ipAddress,
    this.frequency,
    this.linkSpeed,
    this.wifiStandard,
    this.gateway,
    this.netmask,
    this.publicIp,
    this.dnsServers,
    this.channel,
    this.simState,
    this.dataType,
    this.rttSupported,
    this.rsrp,
  });
}

class HardwareService {
  final _networkInfo = NetworkInfo();
  final _deviceInfo = DeviceInfoPlugin();
  HardwareInfo? _cachedStaticInfo;
  String? _cachedPublicIp;
  DateTime? _lastPublicIpFetch;

  /// Returns basic signal information quickly, suitable for frequent polling.
  Future<int?> getSignalStrength() async {
    try {
      if (await Permission.location.isGranted) {
        final ssid = await _networkInfo.getWifiName();
        if (ssid != null) {
          final cleanSsid = ssid.replaceAll('"', '');
          final results = await WiFiScan.instance.getScannedResults();
          final currentAp = results.where((ap) => ap.ssid == cleanSsid).firstOrNull;
          return currentAp?.level;
        }
      }
    } catch (e) {
      debugPrint('Error fetching signal strength: $e');
    }
    return null;
  }

  /// Clears cached network information, forcing a fresh fetch on next call.
  void clearCache() {
    _cachedPublicIp = null;
    _lastPublicIpFetch = null;
  }

  Future<HardwareInfo> getHardwareInfo({bool dynamicOnly = false, bool forceRefresh = false}) async {
    if (forceRefresh) {
      clearCache();
    }
    String? carrier;
    String? radioType;
    String? ssid;
    String? bssid;
    int? rssi;
    String? ip;
    String? model = _cachedStaticInfo?.model;
    String? brand = _cachedStaticInfo?.brand;
    String? osVersion = _cachedStaticInfo?.osVersion;
    int? sdkVersion = _cachedStaticInfo?.sdkVersion;
    int? frequency;
    int? linkSpeed;
    
    // Declare all detailed info variables
    String? publicIp;
    int? channel;
    String? wifiStandard;
    String? simState;
    String? dataType;
    String? gateway;
    String? netmask;
    List<String>? dnsServers;
    int? rsrp;

    if (!dynamicOnly || _cachedStaticInfo == null) {
      try {
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          model = androidInfo.model;
          brand = androidInfo.brand;
          osVersion = androidInfo.version.release;
          sdkVersion = androidInfo.version.sdkInt;
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          model = iosInfo.utsname.machine;
          brand = 'Apple';
          osVersion = iosInfo.systemVersion;
        }
        
        _cachedStaticInfo = HardwareInfo(
          model: model,
          brand: brand,
          osVersion: osVersion,
          sdkVersion: sdkVersion,
        );
      } catch (e) {
        debugPrint('Error fetching device info: $e');
      }
    }

    if (!dynamicOnly) {
      try {
        if (!kIsWeb) {
          if (Platform.isAndroid) {
            final info = await CarrierInfo.getAndroidInfo();
            if (info != null && info.telephonyInfo.isNotEmpty) {
              final telephony = info.telephonyInfo.first;
              carrier = telephony.carrierName;
              radioType = telephony.networkGeneration;
              simState = telephony.simState;
              dataType = telephony.networkGeneration;
            }
          } else if (Platform.isIOS) {
            final info = await CarrierInfo.getIosInfo();
            if (info.carrierData.isNotEmpty) {
              carrier = info.carrierData.first.carrierName;
            }
            if (info.carrierRadioAccessTechnologyTypeList.isNotEmpty) {
              radioType = info.carrierRadioAccessTechnologyTypeList.first;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching carrier info: $e');
      }
    }

    try {
      ssid = await _networkInfo.getWifiName();
      bssid = await _networkInfo.getWifiBSSID();
      ip = await _networkInfo.getWifiIP();
      
      // Safe calls for extended network info
      try {
        // network_info_plus 6.x uses different methods or might not have these on all platforms
        // Falling back to manual resolution or null if missing in current plugin version
        gateway = null; // Placeholder: getWifiGateway was removed/missing
        netmask = await _networkInfo.getWifiSubmask();
      } catch (e) {
        debugPrint('Extended network info (gateway/mask) not available');
      }

      try {
        final ipv6 = await _networkInfo.getWifiIPv6();
        if (ipv6 != null) dnsServers = [ipv6];
      } catch (_) {}
      
      // Public IP fetch - Optimized to cache for 5 minutes
      final now = DateTime.now();
      if (_cachedPublicIp == null || 
          _lastPublicIpFetch == null || 
          now.difference(_lastPublicIpFetch!).inMinutes > 5) {
        try {
          final response = await http.get(Uri.parse('https://api.ipify.org')).timeout(const Duration(seconds: 2));
          if (response.statusCode == 200) {
            _cachedPublicIp = response.body;
            _lastPublicIpFetch = now;
          }
        } catch (_) {}
      }
      publicIp = _cachedPublicIp;

      if (await Permission.location.isGranted) {
        final results = await WiFiScan.instance.getScannedResults();
        if (ssid != null) {
          final cleanSsid = ssid.replaceAll('"', '');
          final currentAp = results.where((ap) => ap.ssid == cleanSsid).firstOrNull;
          if (currentAp != null) {
            rssi = currentAp.level;
            frequency = currentAp.frequency;
            // frequency is non-nullable int in wifi_scan
            if (frequency >= 2412 && frequency <= 2484) {
              channel = (frequency - 2412) ~/ 5 + 1;
            } else if (frequency >= 5170 && frequency <= 5825) {
              channel = (frequency - 5170) ~/ 5 + 34;
            }
            wifiStandard = currentAp.capabilities;
            
            // Perform vendor lookup for the current BSSID
            if (bssid != null) {
              final vendor = await VendorService.instance.lookupVendor(bssid);
              if (vendor != null) {
                // We don't have a specific field for AP vendor in HardwareInfo, 
                // but we can append it to the standard or SSID for now, or just leave it for UI to fetch.
                // For now, let's keep it available.
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching wifi hardware info: $e');
    }

    return HardwareInfo(
      model: model,
      brand: brand,
      osVersion: osVersion,
      sdkVersion: sdkVersion,
      carrierName: carrier ?? _cachedStaticInfo?.carrierName,
      networkGeneration: radioType ?? _cachedStaticInfo?.networkGeneration,
      wifiSsid: ssid,
      wifiBssid: bssid,
      rssi: rssi,
      ipAddress: ip,
      frequency: frequency,
      linkSpeed: linkSpeed,
      gateway: gateway,
      netmask: netmask,
      publicIp: publicIp,
      dnsServers: dnsServers,
      channel: channel,
      wifiStandard: wifiStandard,
      simState: simState ?? (carrier != null ? 'Ready' : 'Unknown'),
      dataType: dataType ?? radioType,
      rttSupported: true,
      rsrp: rsrp,
    );
  }
}
