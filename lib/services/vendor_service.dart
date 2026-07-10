import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VendorService {
  static final VendorService _instance = VendorService._();
  static VendorService get instance => _instance;
  VendorService._();

  final Map<String, String> _cache = {};
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('vendor_cache');
    if (cachedData != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(cachedData);
        decoded.forEach((key, value) {
          _cache[key] = value.toString();
        });
      } catch (_) {}
    }
    _initialized = true;
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vendor_cache', jsonEncode(_cache));
  }

  Future<String?> lookupVendor(String? macOrBssid) async {
    if (macOrBssid == null || macOrBssid.isEmpty) return null;
    
    final cleanMac = macOrBssid.toUpperCase().replaceAll(':', '').substring(0, 6);
    
    await _init();
    if (_cache.containsKey(cleanMac)) {
      return _cache[cleanMac];
    }

    try {
      // Using macvendors.com API - simple and no registration for low volume
      final response = await http
          .get(Uri.parse('https://api.macvendors.com/$cleanMac'))
          .timeout(const Duration(seconds: 2));
      
      if (response.statusCode == 200) {
        final vendor = response.body.trim();
        _cache[cleanMac] = vendor;
        await _saveCache();
        return vendor;
      }
    } catch (_) {
      // Silently fail and return null or a generic guess
    }

    // Basic hardcoded fallback for very common vendors if API fails
    return _guessVendor(cleanMac);
  }

  String? _guessVendor(String prefix) {
    const common = {
      '00000C': 'Cisco',
      '000142': 'Cisco',
      '0003FF': 'Microsoft',
      '000502': 'Apple',
      '000D93': 'Apple',
      '0010FA': 'Apple',
      '001422': 'Dell',
      '00166B': 'Samsung',
      '0017F2': 'Apple',
      '001A11': 'Google',
      '001C23': 'Dell',
      '001D0F': 'TP-Link',
      '00212F': 'Cisco',
      '00236C': 'Apple',
      '0024E8': 'Samsung',
      '002500': 'Apple',
      '0026BB': 'Apple',
      '00E04C': 'Realtek',
      '28CFE9': 'Apple',
      '34159E': 'Samsung',
      '38CA84': 'Apple',
      '40831D': 'Samsung',
      '44650D': 'Amazon',
      '50C7BF': 'TP-Link',
      '600194': 'Espressif',
      '64006A': 'Samsung',
      '705A0F': 'Hewlett Packard',
      '70EE50': 'Netgear',
      '8416F9': 'TP-Link',
      '88E9FE': 'Apple',
      '9801A7': 'Apple',
      'A47733': 'Samsung',
      'AC8674': 'HP',
      'B827EB': 'Raspberry Pi',
      'C03F0E': 'Netgear',
      'C8D719': 'Cisco',
      'D83062': 'Apple',
      'DC5360': 'Samsung',
      'E4956E': 'TP-Link',
      'F4F26D': 'TP-Link',
      'FCFBFB': 'Cisco',
    };
    return common[prefix];
  }
}
