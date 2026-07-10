import 'dart:convert';
import 'package:http/http.dart' as http;

class IpInfo {
  const IpInfo({this.ip, this.location, this.isp, this.countryCode});

  final String? ip;
  final String? location;
  final String? isp;
  final String? countryCode;
}

class IpInfoService {
  IpInfoService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<IpInfo> fetchFromTrace(String traceUrl) async {
    try {
      // First try to get basic trace info from the speed test server provider (e.g. Cloudflare)
      final traceResponse = await _client
          .get(Uri.parse(traceUrl))
          .timeout(const Duration(seconds: 5));
      
      String? ip;
      String? loc;
      
      if (traceResponse.statusCode >= 200 && traceResponse.statusCode < 400) {
        for (final line in traceResponse.body.split('\n')) {
          if (line.startsWith('ip=')) ip = line.substring(3).trim();
          if (line.startsWith('loc=')) loc = line.substring(4).trim();
        }
      }

      // Then supplement with ISP and better location from a GeoIP API
      final geoResponse = await _client
          .get(Uri.parse('https://ip-api.com/json/$ip'))
          .timeout(const Duration(seconds: 5));

      if (geoResponse.statusCode >= 200 && geoResponse.statusCode < 400) {
        final data = jsonDecode(geoResponse.body);
        return IpInfo(
          ip: ip ?? data['query'],
          location: loc ?? '${data['city']}, ${data['regionName']}',
          isp: data['isp'],
          countryCode: data['countryCode'],
        );
      }

      return IpInfo(ip: ip, location: loc);
    } on Object {
      return const IpInfo();
    }
  }

  void dispose() {}
}
