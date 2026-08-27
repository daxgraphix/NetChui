import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:net_chui/models/history_entry.dart';
import 'package:intl/intl.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/services/storage_service.dart';

class ReportService {
  static final ReportService instance = ReportService._();
  ReportService._();

  final ScreenshotController screenshotController = ScreenshotController();

  Future<Uint8List?> captureWidget(Widget widget) async {
    try {
      return await screenshotController.captureFromWidget(
        Material(child: widget),
        delay: const Duration(milliseconds: 200),
      );
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  Future<void> shareImage(Uint8List bytes, String name) async {
    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/$name.png').create();
    await imagePath.writeAsBytes(bytes);
    
    await Share.shareXFiles([XFile(imagePath.path)], text: AppState.instance.strings.networkReport);
  }

  Future<void> generateAndSharePdf(HistoryEntry entry) async {
    final bytes = await _buildHistoryPdf(entry);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/NetChui_Report_${entry.id}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: AppState.instance.strings.pdfReport);
  }

  Future<void> generateHealthReport() async {
    final state = AppState.instance;
    final s = state.strings;
    final now = DateTime.now();
    final dateStr = DateFormat.yMMMMd('en').add_jm().format(now);
    
    // Fetch recent signal history for the report
    final signalLogs = await StorageService.instance.getSignalHistory(
      DateTime.now().subtract(const Duration(hours: 24))
    );
    final signalValues = signalLogs.map((l) => l.signalDbm ?? -100.0).toList();

    // Captured state to pass to isolate
    final healthScore = state.networkHealthScore;
    final healthLabel = state.networkHealthLabel;
    final hardwareInfo = state.hardwareInfo;
    final connectionLabel = state.connectionLabel;

    final bytes = await compute(_buildHealthReportPdf, {
      'healthScore': healthScore,
      'healthLabel': healthLabel,
      'hardwareInfo': hardwareInfo,
      'connectionLabel': connectionLabel,
      'dateStr': dateStr,
      'signalValues': signalValues,
      'strings': {
        'healthAudit': s.healthAudit,
        'overallHealthScore': s.overallHealthScore,
        'deviceInfo': s.deviceInfo,
        'model': s.model,
        'os': s.os,
        'connection': s.connection,
        'networkStability': s.networkStability,
        'signalStrength': s.signalStrength,
        'ssid': s.ssid,
        'carrier': s.carrier,
        'automatedReportBy': s.automatedReportBy,
      }
    });

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/NetChui_Health_Report_${now.millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: s.healthReport);
  }

  static Future<Uint8List> _buildHealthReportPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final s = data['strings'] as Map<String, String>;
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(s['healthAudit']!, 
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                    pw.Text(data['dateStr'], style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              
              // Health Score Section
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(s['overallHealthScore']!, 
                            style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                        pw.SizedBox(height: 5),
                        pw.Text('${data['healthScore']}/100', 
                            style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.red900,
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: pw.Text(data['healthLabel'], 
                          style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 30),
              pw.Text(s['deviceInfo']!, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _staticPdfRow(s['model']!, data['hardwareInfo'].model ?? 'Unknown'),
              _staticPdfRow(s['os']!, 'Android ${data['hardwareInfo'].osVersion}'),
              _staticPdfRow(s['connection']!, data['connectionLabel']),
              
              pw.SizedBox(height: 20),
              pw.Text(s['networkStability']!, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _staticPdfRow(s['signalStrength']!, '${data['hardwareInfo'].rssi ?? "Unknown"} dBm'),
              _staticPdfRow(s['ssid']!, data['hardwareInfo'].wifiSsid ?? 'N/A'),
              _staticPdfRow(s['carrier']!, data['hardwareInfo'].carrierName ?? 'N/A'),

              // Signal Trend Simulation in PDF (Bar chart)
              pw.SizedBox(height: 20),
              pw.Text('Signal History (Past 24h)', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 50,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: List.generate((data['signalValues'] as List).length.clamp(0, 40), (index) {
                    final values = data['signalValues'] as List<double>;
                    // Normalize dBm to height (e.g., -100 to -30 range)
                    final dbm = values[index];
                    final normalizedHeight = ((dbm + 100).clamp(0, 70) / 70) * 50;
                    return pw.Expanded(
                      child: pw.Container(
                        margin: const pw.EdgeInsets.symmetric(horizontal: 0.5),
                        height: normalizedHeight,
                        decoration: pw.BoxDecoration(
                          color: dbm < -80 ? PdfColors.red300 : (dbm < -70 ? PdfColors.orange300 : PdfColors.green300),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              pw.Spacer(),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(s['automatedReportBy']!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }


  static pw.Widget _staticPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> generateComprehensiveReport() async {
    final state = AppState.instance;
    final s = state.strings;
    final now = DateTime.now();
    final dateStr = DateFormat.yMMMMd('en').add_jm().format(now);

    final bytes = await compute(_buildComprehensiveReportPdf, {
      'hardware': state.hardwareInfo,
      'connectionLabel': state.connectionLabel,
      'healthScore': state.networkHealthScore,
      'healthLabel': state.networkHealthLabel,
      'lastTest': state.lastHistoryEntry,
      'downloadTrend': state.downloadTrend,
      'dateStr': dateStr,
      'strings': {
        'comprehensiveReport': s.comprehensiveReport,
        'currentDeviceConnection': s.currentDeviceConnection,
        'device': s.device,
        'brand': s.brand,
        'os': s.os,
        'connection': s.connection,
        'healthScore': s.overallHealthScore,
        'latestSpeedTest': s.latestSpeedTest,
        'download': s.download,
        'upload': s.upload,
        'ping': s.ping,
        'jitter': s.jitter,
        'provider': s.provider,
        'testDate': s.testDate,
        'noSpeedTestData': s.noSpeedTestData,
        'networkTrends7Days': s.networkTrends7Days,
        'averageDownload': s.averageDownload,
        'generatedBy': s.generatedBy,
      }
    });

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/NetChui_Full_Report_${now.millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: s.comprehensiveReport);
  }

  static Future<Uint8List> _buildComprehensiveReportPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final hardware = data['hardware'];
    final lastTest = data['lastTest'] as HistoryEntry?;
    final downloadTrend = data['downloadTrend'] as List<double>;
    final s = data['strings'] as Map<String, String>;
    const langCode = 'en';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(s['comprehensiveReport']!, 
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text(data['dateStr'], style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(s['currentDeviceConnection']!, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.Bullet(text: '${s['device']}: ${hardware.model} (${hardware.brand})'),
            pw.Bullet(text: '${s['os']}: Android ${hardware.osVersion}'),
            pw.Bullet(text: '${s['connection']}: ${data['connectionLabel']}'),
            pw.Bullet(text: '${s['healthScore']}: ${data['healthScore']}/100 (${data['healthLabel']})'),
            
            pw.SizedBox(height: 20),
            pw.Text(s['latestSpeedTest']!, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            if (lastTest != null) ...[
               pw.Bullet(text: '${s['download']}: ${lastTest.result.downloadMbps?.toStringAsFixed(2)} Mbps'),
               pw.Bullet(text: '${s['upload']}: ${lastTest.result.uploadMbps?.toStringAsFixed(2)} Mbps'),
               pw.Bullet(text: '${s['ping']}: ${lastTest.result.pingMs?.toStringAsFixed(0)} ms'),
               pw.Bullet(text: '${s['jitter']}: ${lastTest.result.jitterMs?.toStringAsFixed(1)} ms'),
               pw.Bullet(text: '${s['provider']}: ${lastTest.result.isp ?? "N/A"}'),
               pw.Bullet(text: '${s['testDate']}: ${DateFormat.yMMMMd(langCode).add_jm().format(lastTest.timestamp)}'),
            ] else 
               pw.Text(s['noSpeedTestData']!),

            pw.SizedBox(height: 20),
            pw.Text(s['networkTrends7Days']!, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.Text('${s['averageDownload']}: ${downloadTrend.isEmpty ? "N/A" : (downloadTrend.reduce((a, b) => a + b) / downloadTrend.length).toStringAsFixed(2)} Mbps'),
            
            pw.SizedBox(height: 40),
            pw.Footer(
              trailing: pw.Text(s['generatedBy']!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }


  Future<void> shareDiagnosticLog(String title, String type, String value, Map<String, dynamic>? metadata) async {
    final s = AppState.instance.strings;
    final StringBuffer buffer = StringBuffer();
    buffer.writeln(s.diagnosticReport);
    buffer.writeln('-------------------------');
    buffer.writeln('${s.type}: $type');
    buffer.writeln('${s.date}: ${DateFormat.yMMMMd('en').add_jm().format(DateTime.now())}');
    buffer.writeln('${s.status}: $title');
    buffer.writeln('\n${s.results}:');
    buffer.writeln(value);
    
    if (metadata != null && metadata.isNotEmpty) {
      buffer.writeln('\n${s.metadata}:');
      metadata.forEach((key, val) {
        if (key != 'raw') {
          buffer.writeln('$key: $val');
        }
      });
    }
    
    buffer.writeln('\n${s.generatedBy}');
    
    await Share.share(buffer.toString(), subject: '${s.diagnosticReport}: $title');
  }

  Future<void> exportAllData() async {
    final logs = await StorageService.instance.loadNetworkLogs();
    final history = await StorageService.instance.loadHistory();
    final packageInfo = await PackageInfo.fromPlatform();
    
    final data = {
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
      'network_logs': logs.map((l) => {
        'id': l.id,
        'timestamp': l.timestamp.toIso8601String(),
        'type': l.type,
        'category': l.category,
        'severity': l.severity,
        'title': l.title,
        'subtitle': l.subtitle,
        'signalDbm': l.signalDbm,
        'recommendation': l.recommendation,
        'rawData': l.rawData,
      }).toList(),
      'history_entries': history.map((h) => {
        'id': h.id,
        'timestamp': h.timestamp.toIso8601String(),
        'connection_type': h.connectionType,
        'server_id': h.serverId,
        'test_mode': h.testMode.toString(),
        'test_size': h.testSizeName,
        'isp': h.isp,
        'download': h.downloadMbps,
        'upload': h.uploadMbps,
        'ping': h.pingMs,
        'ping_min': h.pingMinMs,
        'ping_max': h.pingMaxMs,
        'jitter': h.jitterMs,
        'public_ip': h.publicIp,
        'location_hint': h.locationHint,
        'country_code': h.countryCode,
        'download_ping': h.downloadPingMs,
        'upload_ping': h.uploadPingMs,
      }).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/netchui_export_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles([XFile(file.path)], text: 'NetChui Data Export');
  }

  Future<void> printPdf(HistoryEntry entry) async {
    final bytes = await _buildHistoryPdf(entry);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }

  Future<Uint8List> _buildHistoryPdf(HistoryEntry entry) async {
    final s = AppState.instance.strings;
    final langCode = 'en';
    final pdf = pw.Document();
    final dateStr = DateFormat.yMMMMd(langCode).add_jm().format(entry.timestamp);
    final r = entry.result;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(s.speedTestReport, 
                          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                      pw.Text(dateStr, style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      _buildPdfMetric(s.download.toUpperCase(), r.downloadMbps?.toStringAsFixed(1) ?? "—", 'Mbps'),
                      _buildPdfMetric(s.upload.toUpperCase(), r.uploadMbps?.toStringAsFixed(1) ?? "—", 'Mbps'),
                      _buildPdfMetric(s.ping.toUpperCase(), r.pingMs?.round().toString() ?? "—", 'ms'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Header(level: 1, text: s.connectionDetails, textStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Divider(),
                pw.SizedBox(height: 10),
                _buildPdfRow(s.serviceProvider, r.isp ?? s.unknown),
                _buildPdfRow(s.location, r.locationHint ?? s.unknown),
                _buildPdfRow(s.type, entry.connectionType),
                pw.SizedBox(height: 20),
                pw.Header(level: 1, text: s.latencyMetrics, textStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Divider(),
                pw.SizedBox(height: 10),
                _buildPdfRow(s.minLatency, '${r.pingMinMs?.toStringAsFixed(1) ?? "—"} ms'),
                _buildPdfRow(s.maxLatency, '${r.pingMaxMs?.toStringAsFixed(1) ?? "—"} ms'),
                _buildPdfRow(s.jitter, '${r.jitterMs?.toStringAsFixed(1) ?? "—"} ms'),
                _buildPdfRow(s.loadedDownload, '${r.downloadPingMs?.toStringAsFixed(1) ?? "—"} ms'),
                _buildPdfRow(s.loadedUpload, '${r.uploadPingMs?.toStringAsFixed(1) ?? "—"} ms'),
                pw.Spacer(),
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(s.automatedReportBy, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<void> generateFilteredReport({
    String? category,
    int? minSeverity,
  }) async {
    final s = AppState.instance.strings;
    final logs = await StorageService.instance.loadNetworkLogs(
      category: category,
      minSeverity: minSeverity,
    );

    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = DateFormat.yMMMMd('en').add_jm().format(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(s.diagnosticReport,
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('${s.filter}: ${category ?? s.all} | ${s.minSeverity}: ${minSeverity ?? 0}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            pw.SizedBox(height: 20),
            if (logs.isEmpty)
              pw.Center(child: pw.Text(s.noLogsFound))
            else
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.red900),
                cellAlignment: pw.Alignment.centerLeft,
                headers: [s.time, s.type, s.category, s.severity, s.description],
                data: logs.map((log) => [
                  DateFormat('HH:mm').format(log.timestamp),
                  log.type,
                  log.category,
                  log.severity.toString(),
                  '${log.title ?? ""}: ${log.subtitle ?? ""}',
                ]).toList(),
              ),
            pw.SizedBox(height: 40),
            pw.Footer(
              trailing: pw.Text(s.generatedBy,
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    final fileName = 'NetChui_Filtered_Report_${now.millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: s.diagnosticReport);
  }

  Future<void> generateSecurityReport() async {
    final state = AppState.instance;
    final s = state.strings;
    final logs = await StorageService.instance.loadNetworkLogs(category: 'SECURITY');
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = DateFormat.yMMMMd('en').add_jm().format(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(s.securityAudit, 
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900)),
                  pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(s.networkPerimeterAnalysis, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.Bullet(text: '${s.ssid}: ${state.hardwareInfo.wifiSsid ?? s.unknown}'),
            pw.Bullet(text: '${s.ipAddress}: ${state.hardwareInfo.ipAddress ?? s.unknown}'),
            
            pw.SizedBox(height: 20),
            pw.Text(s.recentSecurityEvents, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            if (logs.isEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Text(s.noSecurityEvents, style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              )
            else
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.orange900),
                headers: [s.time, s.action, s.severity, s.details],
                data: logs.map((log) => [
                  DateFormat('MM/dd HH:mm').format(log.timestamp),
                  log.title ?? log.type,
                  log.severity >= 2 ? s.severityHigh : (log.severity == 1 ? s.severityMedium : s.severityLow),
                  log.subtitle ?? "",
                ]).toList(),
              ),
            
            pw.SizedBox(height: 20),
            pw.Text(s.securityRecommendations, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.Bullet(text: s.recScanDevices),
            pw.Bullet(text: s.recDisableUpnp),
            pw.Bullet(text: s.recWpa3),
            
            pw.SizedBox(height: 40),
            pw.Footer(
              trailing: pw.Text(s.automatedSecurityAudit, 
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/NetChui_Security_Audit_${now.millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: s.securityAudit);
  }


  pw.Widget _buildPdfMetric(String label, String value, String unit) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
        pw.SizedBox(height: 5),
        pw.Text(value, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
        pw.Text(unit, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
      ],
    );
  }

  pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
