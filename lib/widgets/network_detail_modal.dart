import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/services/network_analysis_service.dart';
import 'package:net_chui/widgets/base_modal.dart';

class NetworkDetailModal extends StatefulWidget {
  const NetworkDetailModal({super.key, required this.info});
  final dynamic info;

  @override
  State<NetworkDetailModal> createState() => _NetworkDetailModalState();
}

class _NetworkDetailModalState extends State<NetworkDetailModal> {
  Map<String, dynamic>? _geoData;
  bool _loadingGeo = false;
  final _analysisService = NetworkAnalysisService();

  @override
  void initState() {
    super.initState();
    _fetchPublicIpGeo();
  }

  Future<void> _fetchPublicIpGeo() async {
    setState(() => _loadingGeo = true);
    final details = await _analysisService.getIpDetails('');
    if (mounted) {
      setState(() {
        _geoData = details;
        _loadingGeo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    final info = widget.info;
    
    return BaseModal(
      title: s.networkDetails,
      icon: Icons.signal_cellular_alt_rounded,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONNECTION',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ModalRow(label: s.connection, value: AppState.instance.connectionLabel),
            if (info.carrierName != null) ModalRow(label: s.carrier, value: info.carrierName!),
            if (info.networkGeneration != null) ModalRow(label: s.radio, value: info.networkGeneration!),
            if (info.wifiSsid != null) ModalRow(label: s.ssid, value: info.wifiSsid!.replaceAll('"', '')),
            if (info.wifiBssid != null) ModalRow(label: 'BSSID', value: info.wifiBssid!, isMono: true),
            if (info.ipAddress != null) ModalRow(label: s.ipAddress, value: info.ipAddress!, isMono: true),
            if (info.frequency != null) ModalRow(label: s.frequency, value: '${(info.frequency! / 1000).toStringAsFixed(1)} GHz (${info.frequency} MHz)'),
            
            const Divider(height: 32),
            const Text(
              'SIGNAL QUALITY',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _SignalStrengthRow(rssi: info.rssi),
            
            const Divider(height: 32),
            const Text(
              'PUBLIC NETWORK INFO',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (_loadingGeo)
              LinearProgressIndicator(color: context.netChui.accent)
            else if (_geoData != null && _geoData!['status'] != 'fail') ...[
              ModalRow(label: 'Public IP', value: _geoData!['query'] ?? 'Unknown', isMono: true),
              ModalRow(label: 'ISP', value: _geoData!['isp'] ?? 'Unknown'),
              ModalRow(label: 'Location', value: '${_geoData!['city'] ?? ''}, ${_geoData!['country'] ?? ''}'),
              ModalRow(label: 'AS', value: _geoData!['as'] ?? 'Unknown', isMono: true),
            ] else
              Text(
                'Could not retrieve public IP details.',
                style: TextStyle(color: context.netChui.muted, fontSize: 13, fontStyle: FontStyle.italic),
              ),
              
            const Divider(height: 32),
            const Text(
              'HARDWARE & DEVICE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (info.brand != null || info.model != null) 
              ModalRow(label: s.device, value: '${info.brand ?? ''} ${info.model ?? ''}'.trim()),
            if (info.osVersion != null) ModalRow(label: s.os, value: info.osVersion!),
            
            const Divider(height: 32),
            const Text(
              'RECOMMENDATION',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildRecommendation(info),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(dynamic info) {
    final rssi = info.rssi;
    String text;
    IconData icon;
    Color color;

    if (rssi == null) {
      text = 'Maintain a stable connection to get better insights.';
      icon = Icons.info_outline;
      color = Colors.grey;
    } else if (rssi >= -60) {
      text = 'Your signal is excellent. You should experience peak performance.';
      icon = Icons.check_circle_outline;
      color = AppColors.green;
    } else if (rssi >= -75) {
      text = 'Signal is good, but slight interference might occur. Avoid obstructions.';
      icon = Icons.wifi_tethering_rounded;
      color = AppColors.blue;
    } else if (rssi >= -85) {
      text = 'Signal is fair. Consider moving closer to the source for better stability.';
      icon = Icons.warning_amber_rounded;
      color = AppColors.orange;
    } else {
      text = 'Signal is weak. Expect drops or slow speeds. A repeater or moving closer is recommended.';
      icon = Icons.signal_wifi_bad_rounded;
      color = AppColors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: context.netChui.text.withValues(alpha: 0.8), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalStrengthRow extends StatelessWidget {
  const _SignalStrengthRow({required this.rssi});
  final int? rssi;

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    final colors = context.netChui;
    String quality;
    Color color;
    double progress;

    if (rssi == null) {
      quality = 'Unknown';
      color = Colors.grey;
      progress = 0;
    } else if (rssi! >= -60) {
      quality = s.excellent;
      color = AppColors.success;
      progress = 1.0;
    } else if (rssi! >= -70) {
      quality = s.statusGood;
      color = AppColors.secondary;
      progress = 0.75;
    } else if (rssi! >= -80) {
      quality = s.statusFair;
      color = AppColors.warning;
      progress = 0.5;
    } else {
      quality = s.statusPoor;
      color = AppColors.accent;
      progress = 0.25;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.signalStrength,
              style: TextStyle(
                color: colors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${rssi ?? '—'} dBm ($quality)',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: color,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.border.withValues(alpha: 0.1),
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}


