import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:net_chui/services/haptic_service.dart';

class LanDevice {
  final String ip;
  final String? name;
  final bool isReachable;
  final bool isLocalDevice;
  final List<int> openPorts;
  final String? vendor;

  LanDevice({
    required this.ip,
    this.name,
    this.isReachable = true,
    this.isLocalDevice = false,
    this.openPorts = const [],
    this.vendor,
  });
}

class PingDataWrapper {
  final String? ip;
  final String? hostname;
  final Duration? time;
  final String? error;

  PingDataWrapper({this.ip, this.hostname, this.time, this.error});
}

class LanScannerParams {
  final String subnet;
  final String currentIp;
  final SendPort sendPort;

  LanScannerParams(this.subnet, this.currentIp, this.sendPort);
}

class PortScannerParams {
  final String host;
  final Map<int, String> ports;
  final SendPort sendPort;

  PortScannerParams(this.host, this.ports, this.sendPort);
}

class NetworkAnalysisService {
  final _networkInfo = NetworkInfo();

  // --- LAN Discovery ---
  Stream<Map<String, dynamic>> discoverDevicesWithProgress() {
    final controller = StreamController<Map<String, dynamic>>();
    
    _runLanDiscovery(controller);
    
    return controller.stream;
  }

  void _runLanDiscovery(StreamController<Map<String, dynamic>> controller) async {
    final ip = await _networkInfo.getWifiIP();
    if (ip == null) {
      controller.close();
      return;
    }
    final subnet = ip.substring(0, ip.lastIndexOf('.'));
    
    controller.add({'progress': 0.0, 'device': LanDevice(ip: ip, name: 'This Device (You)', isLocalDevice: true)});
    
    final receivePort = ReceivePort();
    Isolate? isolate;

    controller.onCancel = () {
      receivePort.close();
      isolate?.kill();
    };

    isolate = await Isolate.spawn(_lanScannerIsolate, LanScannerParams(subnet, ip, receivePort.sendPort));

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        if (controller.isClosed) break;

        // Perform vendor lookup for new devices
        if (message['device'] != null) {
          // In a real scenario, we'd need the MAC address for accurate OUI lookup.
          // Since we don't have it easily via standard Dart APIs without native hooks,
          // we are using the IP as a key for the service which currently just 
          // performs a dummy/prefix lookup or hits an API.
        }

        controller.add(message);
        if (message['device'] != null) {
          HapticService.light();
        }
        if (message['progress'] == 1.0) {
          HapticService.success();
          receivePort.close();
          isolate.kill();
          controller.close();
          break;
        }
      }
    }
  }

  static void _lanScannerIsolate(LanScannerParams params) async {
    final subnet = params.subnet;
    final discoveredIps = <String>{params.currentIp};
    
    const int total = 254;
    int processed = 0;
    const int batchSize = 25;

    for (int i = 1; i <= 254; i += batchSize) {
      final futures = <Future<LanDevice?>>[];
      for (int j = i; j < i + batchSize && j <= 254; j++) {
        final targetIp = '$subnet.$j';
        if (discoveredIps.contains(targetIp)) {
          processed++;
          continue;
        }

        futures.add(() async {
          try {
            // Probe multiple common ports in parallel for faster and more reliable detection
            final portsToTry = [80, 443, 22, 135, 445, 8080];
            bool reachable = false;
            final openPorts = <int>[];

            final results = await Future.wait(
              portsToTry.map((port) => 
                Socket.connect(targetIp, port, timeout: const Duration(milliseconds: 200))
                  .then((s) { s.destroy(); return port; })
                  .catchError((_) => -1)
              )
            );

            for (var p in results) {
              if (p != -1) {
                reachable = true;
                openPorts.add(p);
              }
            }

            processed++;
            if (reachable) {
              String? host;
              String? vendor;
              try {
                // Reverse DNS with a slightly longer timeout as it can be slow on some LANs
                final reverse = await InternetAddress(targetIp).reverse().timeout(const Duration(milliseconds: 500));
                host = reverse.host;
                if (host == targetIp) host = null;
              } catch (_) {}

              // Basic OUI/Vendor inference for common hardware
              if (targetIp.endsWith('.1')) {
                vendor = 'Gateway/Router';
              } else if (host != null) {
                final h = host.toLowerCase();
                if (h.contains('apple')) {
                  vendor = 'Apple Device';
                } else if (h.contains('samsung')) {
                  vendor = 'Samsung Device';
                } else if (h.contains('google')) {
                  vendor = 'Google/Android Device';
                } else if (h.contains('amazon')) {
                  vendor = 'Amazon Echo/Kindle';
                } else if (h.contains('roku')) {
                  vendor = 'Roku';
                } else if (h.contains('sonos')) {
                  vendor = 'Sonos';
                } else if (h.contains('xbox')) {
                  vendor = 'Microsoft Xbox';
                } else if (h.contains('playstation')) {
                  vendor = 'Sony PlayStation';
                }
              }

              return LanDevice(ip: targetIp, name: host, openPorts: openPorts, vendor: vendor);
            }
          } catch (_) {
            processed++;
          }
          return null;
        }());
      }

      final results = await Future.wait(futures);
      // Small delay between batches to reduce CPU/Network spikes in isolate
      await Future.delayed(const Duration(milliseconds: 50));

      bool sentBatchUpdate = false;
      for (final device in results) {
        if (device != null) {
          discoveredIps.add(device.ip);
          params.sendPort.send({'progress': processed / total, 'device': device});
          sentBatchUpdate = true;
        }
      }
      
      // If no devices found in this batch, send a progress update to keep UI responsive
      if (!sentBatchUpdate) {
        params.sendPort.send({'progress': processed / total});
      }
    }
    params.sendPort.send({'progress': 1.0});
  }

  Stream<LanDevice> discoverDevices() async* {
    await for (final event in discoverDevicesWithProgress()) {
      if (event['device'] != null) {
        yield event['device'] as LanDevice;
      }
    }
  }

  // --- Wi-Fi Analysis ---
  Future<List<WiFiAccessPoint>> scanWifiNetworks() async {
    final canStart = await WiFiScan.instance.canStartScan();
    if (canStart != CanStartScan.yes) {
      // If it's not possible to start a scan, return what we have
      return await WiFiScan.instance.getScannedResults();
    }

    if (!(await Permission.location.request().isGranted)) {
      return [];
    }

    // Start scan
    final started = await WiFiScan.instance.startScan();
    if (!started) {
      return await WiFiScan.instance.getScannedResults();
    }

    // Wait for results with a timeout
    final completer = Completer<List<WiFiAccessPoint>>();
    StreamSubscription? subscription;
    
    subscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
      if (!completer.isCompleted) {
        completer.complete(results);
        subscription?.cancel();
      }
    });

    // Fallback timeout
    Future.delayed(const Duration(seconds: 5), () async {
      if (!completer.isCompleted) {
        completer.complete(await WiFiScan.instance.getScannedResults());
        subscription?.cancel();
      }
    });

    return completer.future;
  }

  Future<WiFiAccessPoint?> getCurrentAccessPoint() async {
    final ssid = await _networkInfo.getWifiName();
    if (ssid == null) return null;
    final results = await scanWifiNetworks();
    final cleanSsid = ssid.replaceAll('"', '');
    return results.where((ap) => ap.ssid == cleanSsid).firstOrNull;
  }

  Map<int, int> getChannelCrowding(List<WiFiAccessPoint> results) {
    final Map<int, int> crowding = {};
    for (var ap in results) {
      final channel = frequencyToChannel(ap.frequency);
      crowding[channel] = (crowding[channel] ?? 0) + 1;
    }
    return crowding;
  }

  int frequencyToChannel(int freq) {
    if (freq >= 2412 && freq <= 2484) {
      return (freq - 2407) ~/ 5;
    } else if (freq >= 5170 && freq <= 5825) {
      return (freq - 5000) ~/ 5;
    } else if (freq >= 5945 && freq <= 7125) {
      // 6GHz band (Wi-Fi 6E)
      return (freq - 5950) ~/ 5;
    }
    return 0;
  }

  double calculateDistance(int rssi, int freq) {
    // Basic Free Space Path Loss model approximation
    // distance = 10 ^ ((27.55 - (20 * log10(freq)) + abs(rssi)) / 20)
    final exp = (27.55 - (20 * (log(freq) / ln10)) + rssi.abs()) / 20.0;
    return double.parse(pow(10, exp).toStringAsFixed(1));
  }

  String getStandardName(WiFiStandards standard) {
    switch (standard) {
      case WiFiStandards.legacy: return 'Legacy (802.11a/b/g)';
      case WiFiStandards.n: return 'Wi-Fi 4 (802.11n)';
      case WiFiStandards.ac: return 'Wi-Fi 5 (802.11ac)';
      case WiFiStandards.ax: return 'Wi-Fi 6 (802.11ax)';
      case WiFiStandards.ad: return 'Wi-Fi 60GHz (802.11ad)';
      default: return 'Unknown';
    }
  }

  Future<Map<String, dynamic>?> getOptimizationRecommendation() async {
    final results = await scanWifiNetworks();
    if (results.isEmpty) return null;

    final currentAp = await getCurrentAccessPoint();
    if (currentAp == null) return null;

    final crowding = getChannelCrowding(results);
    final currentChannel = frequencyToChannel(currentAp.frequency);
    final currentCrowd = crowding[currentChannel] ?? 1;

    // Separate by band
    final is5GHz = currentAp.frequency > 4000;
    final channels = is5GHz 
      ? [36, 40, 44, 48, 149, 153, 157, 161] 
      : [1, 6, 11];

    int bestChannel = currentChannel;
    int minCrowd = currentCrowd;

    for (var ch in channels) {
      final crowd = crowding[ch] ?? 0;
      if (crowd < minCrowd) {
        minCrowd = crowd;
        bestChannel = ch;
      }
    }

    if (bestChannel != currentChannel) {
      return {
        'currentChannel': currentChannel,
        'recommendedChannel': bestChannel,
        'currentCrowd': currentCrowd,
        'recommendedCrowd': minCrowd,
        'band': is5GHz ? '5GHz' : '2.4GHz',
      };
    }

    return null;
  }

  // --- Diagnostics ---
  Future<List<Map<String, dynamic>>> scanCommonPorts(String host) async {
    final results = <Map<String, dynamic>>[];
    await for (final result in scanCommonPortsStream(host)) {
      if (result['status'] == 'Open') {
        results.add(result);
      }
    }
    return results..sort((a, b) => (a['port'] as int).compareTo(b['port'] as int));
  }

  Stream<Map<String, dynamic>> scanCommonPortsStream(String host, {bool fullScan = false}) {
    final controller = StreamController<Map<String, dynamic>>();
    
    _runPortScan(host, controller, fullScan: fullScan);
    
    return controller.stream;
  }

  void _runPortScan(String host, StreamController<Map<String, dynamic>> controller, {bool fullScan = false}) async {
    final ports = {
      21: 'FTP', 22: 'SSH', 23: 'Telnet', 25: 'SMTP', 53: 'DNS', 
      80: 'HTTP', 110: 'POP3', 143: 'IMAP', 443: 'HTTPS', 445: 'SMB', 
      631: 'IPP', 3306: 'MySQL', 3389: 'RDP', 5432: 'PostgreSQL', 
      5900: 'VNC', 8000: 'HTTP-Alt', 8080: 'HTTP-Alt', 8443: 'HTTPS-Alt',
      9000: 'Portainer/S3', 9090: 'Web-Console'
    };

    if (fullScan) {
      // Add more common service ports for a "full" scan
      final extendedPorts = {
        135: 'RPC', 137: 'NetBIOS', 138: 'NetBIOS', 139: 'NetBIOS',
        548: 'AFP', 873: 'Rsync', 993: 'IMAPS', 995: 'POP3S',
        1723: 'PPTP', 2049: 'NFS', 3000: 'Gitea/Grafana', 3260: 'iSCSI',
        5000: 'Synology', 5001: 'Synology-SSL', 5060: 'SIP', 6379: 'Redis',
        8008: 'HTTP-Alt', 8888: 'HTTP-Alt', 9100: 'Printer', 27017: 'MongoDB'
      };
      ports.addAll(extendedPorts);
    }
    
    final receivePort = ReceivePort();
    Isolate? isolate;

    controller.onCancel = () {
      receivePort.close();
      isolate?.kill();
    };

    isolate = await Isolate.spawn(_portScannerIsolate, PortScannerParams(host, ports, receivePort.sendPort));

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        if (controller.isClosed) break;
        controller.add(message);
        if (message['device'] != null) {
          HapticService.light();
        }
        if (message['progress'] == 1.0) {
          HapticService.success();
          receivePort.close();
          isolate.kill();
          controller.close();
          break;
        }
      }
    }
  }

  static void _portScannerIsolate(PortScannerParams params) async {
    final host = params.host;
    final ports = params.ports;
    final portList = ports.entries.toList();
    final total = portList.length;
    int completed = 0;

    // Use batching for port scanning to avoid overwhelming the network stack
    // Reduced batch size and adjusted timeout for better reliability in the isolate
    const int batchSize = 10;
    
    for (int i = 0; i < portList.length; i += batchSize) {
      final batch = portList.skip(i).take(batchSize);
      final futures = <Future<void>>[];

      for (var entry in batch) {
        futures.add(() async {
          try {
            // Use a slightly longer timeout for Port Scan compared to discovery for more accuracy
            final socket = await Socket.connect(host, entry.key, timeout: const Duration(milliseconds: 1500));
            params.sendPort.send({
              'port': entry.key, 
              'service': entry.value, 
              'status': 'Open', 
              'progress': ++completed / total
            });
            socket.destroy();
          } catch (_) {
            completed++;
            // Send periodic progress updates for closed ports to keep UI smooth
            if (completed % 2 == 0 || completed == total) {
              params.sendPort.send({
                'port': entry.key, 
                'service': entry.value, 
                'status': 'Closed', 
                'progress': completed / total
              });
            }
          }
        }());
      }
      await Future.wait(futures);
      // Small delay between batches to reduce CPU/Network spikes in isolate
      await Future.delayed(const Duration(milliseconds: 100));
    }

    params.sendPort.send({'progress': 1.0});
  }

  Future<List<Map<String, String>>> dnsLookup(String host) async {
    try {
      final addresses = await InternetAddress.lookup(host);
      return addresses.map((addr) => {
        'type': addr.type == InternetAddressType.IPv4 ? 'A' : 'AAAA',
        'address': addr.address,
      }).toList();
    } catch (e) { return []; }
  }

  Future<Map<String, dynamic>> getIpDetails(String ip) async {
    try {
      final url = ip.isEmpty ? 'https://ip-api.com/json/' : 'https://ip-api.com/json/$ip';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      return response.statusCode == 200 ? jsonDecode(response.body) : {'status': 'fail'};
    } catch (e) { return {'status': 'fail'}; }
  }

  Future<String> whoisLookup(String host) async {
    try {
      // Basic WHOIS usually requires a socket to a WHOIS server (e.g., whois.verisign-grs.com on port 43)
      // For mobile apps, it's often more reliable to use a web API or a specific WHOIS library
      // Here we'll simulate or use a public API if available, or just perform a rich DNS dig
      final response = await http.get(Uri.parse('https://rdap.org/domain/$host')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return 'WHOIS data not available via RDAP for $host';
    } catch (e) {
      return 'WHOIS Lookup Error: $e';
    }
  }

  Future<PingDataWrapper> testConnection(String host, {int port = 53}) async {
    final sw = Stopwatch()..start();
    try {
      final s = await Socket.connect(host, port, timeout: const Duration(seconds: 2));
      sw.stop();
      await s.close();
      return PingDataWrapper(ip: host, time: sw.elapsed);
    } catch (_) { 
       // Fallback without ping if needed, but for now just return error
       return PingDataWrapper(error: 'Connection failed');
    }
  }

  // --- Live Monitoring ---
  Stream<LiveNetworkStats> streamLiveNetworkStats({String host = '8.8.8.8', Duration interval = const Duration(seconds: 1)}) async* {
    final List<double> history = [];
    int totalPings = 0;
    int lostPings = 0;

    while (true) {
      final sw = Stopwatch()..start();
      totalPings++;
      try {
        final socket = await Socket.connect(host, 53, timeout: const Duration(seconds: 1));
        sw.stop();
        socket.destroy();
        
        final rtt = sw.elapsedMicroseconds / 1000.0;
        history.add(rtt);
        if (history.length > 30) history.removeAt(0);

        // Calculate jitter (average deviation)
        double jitter = 0;
        if (history.length > 1) {
          double sumDiff = 0;
          for (int i = 0; i < history.length - 1; i++) {
            sumDiff += (history[i+1] - history[i]).abs();
          }
          jitter = sumDiff / (history.length - 1);
        }

        yield LiveNetworkStats(
          pingMs: rtt,
          jitterMs: jitter,
          packetLossPercent: (lostPings / totalPings) * 100,
          recentPings: List.from(history),
        );
      } catch (_) {
        lostPings++;
        yield LiveNetworkStats(
          pingMs: -1, // Indicates loss
          jitterMs: 0,
          packetLossPercent: (lostPings / totalPings) * 100,
          recentPings: List.from(history),
        );
      }
      await Future.delayed(interval);
    }
  }

}

class LiveNetworkStats {
  final double pingMs;
  final double jitterMs;
  final double packetLossPercent;
  final List<double> recentPings;

  LiveNetworkStats({
    required this.pingMs,
    required this.jitterMs,
    required this.packetLossPercent,
    required this.recentPings,
  });
}
