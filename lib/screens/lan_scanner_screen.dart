import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/app_logo.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../app/app_state.dart';
import '../services/network_analysis_service.dart';
import '../services/vendor_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/offline_overlay.dart';

class LanScannerScreen extends StatefulWidget {
  const LanScannerScreen({super.key});

  @override
  State<LanScannerScreen> createState() => _LanScannerScreenState();
}

class _LanScannerScreenState extends State<LanScannerScreen> {
  final _service = NetworkAnalysisService();
  final List<LanDevice> _devices = [];
  bool _isScanning = false;
  double _scanProgress = 0;

  void _startScan() {
    if (_isScanning) return;
    setState(() {
      _devices.clear();
      _isScanning = true;
      _scanProgress = 0;
    });

    _service.discoverDevicesWithProgress().listen(
      (event) async {
        if (event['device'] != null) {
          final device = event['device'] as LanDevice;
          setState(() {
            _devices.add(device);
          });

          // Async vendor lookup to avoid blocking
          if (device.vendor == null || device.vendor == 'Generic Device') {
            final vendor = await VendorService.instance.lookupVendor(device.ip); // Or MAC if we had it
            if (vendor != null && mounted) {
              setState(() {
                final index = _devices.indexWhere((d) => d.ip == device.ip);
                if (index != -1) {
                  _devices[index] = LanDevice(
                    ip: device.ip,
                    name: device.name,
                    isReachable: device.isReachable,
                    isLocalDevice: device.isLocalDevice,
                    openPorts: device.openPorts,
                    vendor: vendor,
                  );
                }
              });
            }
          }
        }
        if (event['progress'] != null) {
          setState(() {
            _scanProgress = (event['progress'] as num).toDouble();
          });
        }
      },
      onError: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppState.instance.strings.scanError(e.toString()))),
        );
      },
      onDone: () async {
        setState(() => _isScanning = false);
        // Log the scan result
        if (_devices.isNotEmpty) {
          await AppState.instance.logToolResult(
            'LAN_SCAN',
            'LAN Discovery',
            '${_devices.length} devices found',
            {'device_count': _devices.length, 'ips': _devices.map((d) => d.ip).toList()},
            category: 'SECURITY',
            severity: 0,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: AppState.instance.strings.lanScanner,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(Spacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (!AppState.instance.isOnline) ...[
                    OfflineOverlay(onRetry: () => setState(() {})),
                    const SizedBox(height: Spacing.md),
                  ],
                  Center(
                    child: GestureDetector(
                      onTap: _startScan,
                      child: Hero(
                        tag: 'app_logo',
                        child: AppLogo(
                          size: 80,
                          showBackground: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  if (_isScanning)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.md),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          backgroundColor: context.netChui.card.withValues(alpha: 0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(context.netChui.accent),
                          minHeight: 4,
                          value: _scanProgress > 0 ? _scanProgress : null,
                        ),
                      ),
                    ),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Spacing.md),
                          decoration: BoxDecoration(
                            color: context.netChui.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.netChui.accent.withValues(alpha: 0.2)),
                          ),
                          child: Icon(Icons.devices_rounded, color: context.netChui.accent, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppState.instance.strings.connectedDevices.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: context.netChui.muted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_devices.length} ${AppState.instance.strings.active}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_isScanning)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _startScan,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: context.netChui.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.refresh_rounded, size: 20, color: context.netChui.accent),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3, 
                              color: context.netChui.accent,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                ]),
              ),
            ),
            if (_devices.isEmpty && !_isScanning)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _devices.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDeviceCard(_devices[index]),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildShimmerCard(),
                        );
                      }
                    },
                    childCount: _isScanning ? _devices.length + 3 : _devices.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: !_isScanning && _devices.isEmpty
          ? FloatingActionButton.extended(
              onPressed: _startScan,
              label: Text(AppState.instance.strings.scanNetwork),
              icon: const Icon(Icons.search_rounded),
              backgroundColor: context.netChui.accent,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: context.netChui.card,
      highlightColor: context.netChui.border,
      child: GlassCard(
        height: 76,
        child: const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices_other_rounded, size: 64, color: context.netChui.subtle),
          const SizedBox(height: 16),
          Text(
            AppState.instance.strings.readyToScan,
            style: TextStyle(color: context.netChui.muted, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(LanDevice device) {
    final s = AppState.instance.strings;
    IconData deviceIcon;
    Color iconColor;
    String category;

    if (device.isLocalDevice) {
      deviceIcon = Icons.smartphone_rounded;
      iconColor = AppColors.success;
      category = s.personalDevice;
    } else if (device.vendor?.toLowerCase().contains('apple') ?? false) {
      deviceIcon = Icons.laptop_mac_rounded;
      iconColor = context.netChui.text;
      category = s.appleDevice;
    } else if (device.vendor?.toLowerCase().contains('samsung') ?? false) {
      deviceIcon = Icons.phone_android_rounded;
      iconColor = AppColors.info;
      category = s.mobileDevice;
    } else if (device.vendor?.toLowerCase().contains('amazon') ?? false || (device.vendor?.toLowerCase().contains('google') ?? false)) {
      deviceIcon = Icons.smart_button_rounded;
      iconColor = AppColors.warning;
      category = s.smartHome;
    } else {
      deviceIcon = Icons.devices_rounded;
      iconColor = AppColors.secondary;
      category = s.genericDevice;
    }

    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () => _showDeviceDetails(device),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: iconColor.withValues(alpha: 0.15)),
                ),
                child: Icon(
                  deviceIcon,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.ip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900, 
                        fontFamily: 'JetBrainsMono', 
                        fontSize: 16, 
                        letterSpacing: -0.8
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.name ?? category,
                      style: TextStyle(
                        color: context.netChui.text, 
                        fontWeight: FontWeight.w800, 
                        fontSize: 13,
                        letterSpacing: -0.2
                      ),
                    ),
                    if (device.vendor != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        device.vendor!.toUpperCase(),
                        style: TextStyle(
                          color: context.netChui.muted, 
                          fontSize: 9, 
                          fontWeight: FontWeight.w900, 
                          letterSpacing: 0.8
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (device.isLocalDevice)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
                  ),
                  child: Text(
                    AppState.instance.strings.you,
                    style: const TextStyle(
                      color: AppColors.success, 
                      fontSize: 10, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 0.5
                    ),
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right_rounded, size: 20, color: context.netChui.subtle),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  void _showDeviceDetails(LanDevice device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DeviceDetailModal(device: device, service: _service),
    );
  }
}

class _DeviceDetailModal extends StatefulWidget {
  const _DeviceDetailModal({required this.device, required this.service});
  final LanDevice device;
  final NetworkAnalysisService service;

  @override
  State<_DeviceDetailModal> createState() => _DeviceDetailModalState();
}

class _DeviceDetailModalState extends State<_DeviceDetailModal> {
  List<int> _openPorts = [];
  bool _isScanningPorts = false;
  double _portScanProgress = 0;

  @override
  void initState() {
    super.initState();
    _openPorts = List.from(widget.device.openPorts);
  }

  Future<void> _scanAllPorts() async {
    setState(() {
      _isScanningPorts = true;
      _portScanProgress = 0;
      _openPorts.clear();
    });
    
    final foundPorts = <int>[];
    final allResults = <Map<String, dynamic>>[];

    widget.service.scanCommonPortsStream(widget.device.ip, fullScan: true).listen(
      (result) {
        allResults.add(result);
        if (result['status'] == 'Open') {
          setState(() {
            foundPorts.add(result['port'] as int);
            _openPorts = List.from(foundPorts)..sort();
          });
        }
        setState(() {
          _portScanProgress = (result['progress'] as num).toDouble();
        });
      },
      onError: (e) async {
        if (!mounted) return;
        setState(() => _isScanningPorts = false);
        await AppState.instance.logToolResult(
          'LAN_PORT_SCAN_ERROR',
          'Port Scan Failed: ${widget.device.ip}',
          e.toString(),
          {'ip': widget.device.ip, 'error': e.toString()},
          category: 'SECURITY',
          severity: 1,
        );
      },
      onDone: () async {
        if (!mounted) return;
        setState(() => _isScanningPorts = false);
        
        await AppState.instance.logToolResult(
          'LAN_PORT_SCAN',
          'Port Scan: ${widget.device.ip}',
          '${foundPorts.length} ports open',
          {
            'ip': widget.device.ip,
            'hostname': widget.device.name,
            'results': allResults,
          },
          category: 'SECURITY',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    final s = AppState.instance.strings;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: colors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(Spacing.xl, Spacing.lg, Spacing.xl, Spacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: (widget.device.isLocalDevice ? AppColors.success : AppColors.secondary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.device.isLocalDevice ? Icons.smartphone_rounded : Icons.devices_rounded,
                  color: widget.device.isLocalDevice ? AppColors.success : AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.device.name ?? s.genericDevice,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                    ),
                    Text(
                      widget.device.ip,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'JetBrainsMono',
                        color: colors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.device.isLocalDevice)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    s.thisDevice,
                    style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),
          _SectionHeader(title: s.networkInfo.toUpperCase()),
          const SizedBox(height: Spacing.md),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
            child: Column(
              children: [
                _DetailRow(label: s.ipAddress, value: widget.device.ip, isMono: true),
                _DetailRow(label: s.hostname, value: widget.device.name ?? s.unknown),
                _DetailRow(
                  label: s.status, 
                  value: widget.device.isReachable ? s.online : s.offlineStatus, 
                  valueColor: widget.device.isReachable ? AppColors.success : AppColors.accent
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionHeader(title: s.openServices.toUpperCase()),
              if (!_isScanningPorts)
                TextButton.icon(
                  onPressed: _scanAllPorts,
                  icon: const Icon(Icons.search_rounded, size: 14),
                  label: Text(s.fullScan, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: colors.accent,
                    backgroundColor: colors.accent.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              else
                SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _portScanProgress,
                      minHeight: 4,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          if (_openPorts.isEmpty && !_isScanningPorts)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(s.noPortsDetected, style: TextStyle(color: colors.muted, fontSize: 13, fontStyle: FontStyle.italic)),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _openPorts.map((port) => _PortBadge(port: port)).toList(),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10, 
        fontWeight: FontWeight.w900, 
        letterSpacing: 1.5, 
        color: context.netChui.muted,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor, this.isMono = false});
  final String label;
  final String value;
  final Color? valueColor;
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.muted, fontSize: 13, fontWeight: FontWeight.w500)),
          Text(
            value, 
            style: TextStyle(
              fontWeight: FontWeight.w700, 
              fontSize: 14,
              color: valueColor ?? colors.text,
              fontFamily: isMono ? 'JetBrainsMono' : null,
            ),
          ),
        ],
      ),
    );
  }
}


class _PortBadge extends StatelessWidget {
  const _PortBadge({required this.port});
  final int port;

  String get _serviceName {
    return switch (port) {
      80 => 'HTTP',
      443 => 'HTTPS',
      21 => 'FTP',
      22 => 'SSH',
      135 => 'RPC',
      139 => 'NetBIOS',
      445 => 'SMB',
      8080 => 'HTTP-ALT',
      _ => 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 12,
      child: Column(
        children: [
          Text(port.toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          Text(_serviceName, style: TextStyle(fontSize: 10, color: context.netChui.muted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
