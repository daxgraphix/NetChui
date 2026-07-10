import 'package:net_chui/services/report_service.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import '../app/app_state.dart';
import '../services/network_analysis_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/offline_overlay.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  final _service = NetworkAnalysisService();
  final _hostController = TextEditingController(text: 'google.com');
  final List<DiagnosticLog> _logs = [];
  bool _isRunning = false;
  String _currentTool = '';

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  void _runDnsLookup() async {
    setState(() {
      _logs.clear();
      _isRunning = true;
      _currentTool = 'DNS Lookup';
    });

    try {
      final results = await _service.dnsLookup(_hostController.text);
      if (!mounted) return;
      setState(() {
        if (results.isEmpty) {
          _logs.add(DiagnosticLog(
            label: 'Result',
            value: 'No records found for ${_hostController.text}',
            isError: true,
            type: DiagnosticType.dns,
          ));
        } else {
          for (var res in results) {
            _logs.add(DiagnosticLog(
              label: res['type']!,
              value: res['address']!,
              type: DiagnosticType.dns,
              metadata: res,
            ));
          }
        }
        _isRunning = false;
      });
      
      await AppState.instance.logToolResult(
        'DIAGNOSTICS_DNS',
        'DNS Lookup: ${_hostController.text}',
        '${results.length} records found',
        {'host': _hostController.text, 'results': results},
        category: 'CONNECTIVITY',
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunning = false;
          _logs.add(DiagnosticLog(
            label: 'Error',
            value: e.toString(),
            isError: true,
            type: DiagnosticType.dns,
          ));
        });
      }
    }
  }

  Future<void> _runPortScan() async {
    setState(() {
      _logs.clear();
      _isRunning = true;
      _currentTool = 'Port Scan';
    });

    try {
      final results = await _service.scanCommonPorts(_hostController.text);
      if (!mounted) return;
      setState(() {
        if (results.isEmpty) {
          _logs.add(DiagnosticLog(
            label: 'Status',
            value: 'No common open ports found on ${_hostController.text}',
            isError: true,
            type: DiagnosticType.portScan,
          ));
        } else {
          for (var res in results) {
            _logs.add(DiagnosticLog(
              label: 'PORT ${res['port']}',
              value: '${res['service']} (${res['status']})',
              type: DiagnosticType.portScan,
              metadata: res,
            ));
          }
        }
        _isRunning = false;
      });

      await AppState.instance.logToolResult(
        'DIAGNOSTICS_PORTSCAN',
        'Port Scan: ${_hostController.text}',
        '${results.length} ports open',
        {'host': _hostController.text, 'results': results},
        category: 'SECURITY',
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunning = false;
          _logs.add(DiagnosticLog(
            label: 'Scan Failed',
            value: e.toString(),
            isError: true,
            type: DiagnosticType.portScan,
          ));
        });
      }
    }
  }


  Future<void> _runWhois() async {
    setState(() {
      _logs.clear();
      _isRunning = true;
      _currentTool = 'WHOIS';
    });

    try {
      final result = await _service.whoisLookup(_hostController.text);
      if (!mounted) return;
      setState(() {
        _logs.add(DiagnosticLog(
          label: 'WHOIS Info',
          value: 'Retrieved record for ${_hostController.text}',
          type: DiagnosticType.whois,
          metadata: {'raw': result},
        ));
        _isRunning = false;
      });

      await AppState.instance.logToolResult(
        'DIAGNOSTICS_WHOIS',
        'WHOIS: ${_hostController.text}',
        'Record retrieved',
        {'host': _hostController.text, 'result': result},
        category: 'SECURITY',
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunning = false;
          _logs.add(DiagnosticLog(
            label: 'WHOIS Error',
            value: e.toString(),
            isError: true,
            type: DiagnosticType.whois,
          ));
        });

        await AppState.instance.logToolResult(
          'DIAGNOSTICS_WHOIS_ERROR',
          'WHOIS Failed: ${_hostController.text}',
          e.toString(),
          {'host': _hostController.text, 'error': e.toString()},
          category: 'SECURITY',
          severity: 2,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: s.diagnostics,
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
                    const SizedBox(height: Spacing.lg),
                  ],
                  _buildInputCard(s),
                  const SizedBox(height: Spacing.xl),
                  Row(
                    children: [
                      _buildToolButton(s.dnsLookup, Icons.dns_rounded, _runDnsLookup),
                      const SizedBox(width: Spacing.md),
                      _buildToolButton(s.portScan, Icons.security_rounded, _runPortScan),
                      const SizedBox(width: Spacing.md),
                      _buildToolButton('WHOIS', Icons.info_outline_rounded, _runWhois),
                    ],
                  ),
                  const SizedBox(height: Spacing.xl),
                  _SectionHeader(
                    title: _isRunning ? 'RUNNING ${_currentTool.toUpperCase()}...' : s.results.toUpperCase(),
                  ),
                  const SizedBox(height: Spacing.md),
                ]),
              ),
            ),
            if (_logs.isEmpty && !_isRunning)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: context.netChui.card,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.netChui.border),
                        ),
                        child: Icon(Icons.terminal_rounded, size: 48, color: context.netChui.subtle),
                      ),
                      const SizedBox(height: 16),
                      Text(s.noResultsYet, style: TextStyle(color: context.netChui.muted, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final log = _logs[index];
                      final Color statusColor = log.isError
                          ? AppColors.accent
                          : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.success
                              : AppColors.success);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.sm),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          onTap: () => _showLogDetails(log),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 4, height: 16,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${log.label}:',
                                  style: TextStyle(
                                    color: context.netChui.muted,
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    log.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: context.netChui.text,
                                      fontFamily: 'JetBrainsMono',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.chevron_right_rounded, size: 18, color: context.netChui.subtle),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _logs.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(AppLocalizations s) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _hostController,
        style: const TextStyle(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          labelText: s.targetHost,
          hintText: 'e.g. google.com',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.language_rounded, color: context.netChui.accent),
          floatingLabelStyle: TextStyle(color: context.netChui.accent),
        ),
      ),
    );
  }

  Widget _buildToolButton(String label, IconData icon, VoidCallback onPressed) {
    final colors = context.netChui;
    final bool isThisRunning = _isRunning && _currentTool.contains(label.split(' ')[0]);
    
    return Expanded(
      child: GlassCard(
        padding: EdgeInsets.zero,
        onTap: _isRunning ? null : onPressed,
        borderColor: isThisRunning ? colors.accent : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: (isThisRunning ? colors.accent : colors.subtle).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon, 
                  size: 20, 
                  color: isThisRunning ? colors.accent : colors.text.withValues(alpha: 0.8)
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                label, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11, 
                  fontWeight: FontWeight.w800,
                  color: isThisRunning ? colors.accent : colors.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetails(DiagnosticLog log) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DiagnosticDetailModal(log: log, service: _service),
    );
  }
}

enum DiagnosticType { dns, portScan, whois, generic }

class DiagnosticLog {
  final String label;
  final String value;
  final bool isError;
  final DiagnosticType type;
  final Map<String, dynamic>? metadata;

  DiagnosticLog({
    required this.label,
    required this.value,
    this.isError = false,
    this.type = DiagnosticType.generic,
    this.metadata,
  });
}

class _DiagnosticDetailModal extends StatefulWidget {
  const _DiagnosticDetailModal({required this.log, required this.service});
  final DiagnosticLog log;
  final NetworkAnalysisService service;

  @override
  State<_DiagnosticDetailModal> createState() => _DiagnosticDetailModalState();
}

class _DiagnosticDetailModalState extends State<_DiagnosticDetailModal> {
  Map<String, dynamic>? _extendedData;
  bool _loadingExtended = false;

  @override
  void initState() {
    super.initState();
    if (widget.log.metadata?['ip'] != null) {
      _fetchIpDetails();
    }
  }

  Future<void> _fetchIpDetails() async {
    setState(() => _loadingExtended = true);
    final details = await widget.service.getIpDetails(widget.log.metadata!['ip']);
    if (mounted) {
      setState(() {
        _extendedData = details;
        _loadingExtended = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    final colors = context.netChui;

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
                  color: (widget.log.isError ? AppColors.accent : AppColors.success).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.log.type == DiagnosticType.dns
                      ? Icons.dns_rounded
                      : widget.log.type == DiagnosticType.portScan
                          ? Icons.security_rounded
                          : widget.log.type == DiagnosticType.whois
                              ? Icons.info_outline_rounded
                              : Icons.terminal_rounded,
                  color: widget.log.isError ? AppColors.accent : AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.log.label,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                    ),
                    Text(
                      widget.log.type.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        color: colors.muted,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),
          _SectionHeader(title: s.resultData.toUpperCase()),
          const SizedBox(height: Spacing.md),
          GlassCard(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.lg),
            child: Text(
              widget.log.value,
              style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          if (widget.log.type == DiagnosticType.whois && widget.log.metadata?['raw'] != null) ...[
            const SizedBox(height: Spacing.xl),
            const _SectionHeader(title: 'WHOIS RECORD'),
            const SizedBox(height: Spacing.md),
            GlassCard(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  widget.log.metadata!['raw'],
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono', 
                    fontSize: 12, 
                    fontWeight: FontWeight.w500,
                    color: colors.text.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ],
          if (widget.log.metadata != null && widget.log.metadata!.isNotEmpty && widget.log.type != DiagnosticType.whois) ...[
            const SizedBox(height: Spacing.xl),
            _SectionHeader(title: s.metadata.toUpperCase()),
            const SizedBox(height: Spacing.md),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
              child: Column(
                children: widget.log.metadata!.entries
                  .where((e) => e.key != 'raw')
                  .map((e) => _DetailRow(label: e.key, value: e.value.toString())).toList(),
              ),
            ),
          ],
          if (_loadingExtended)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.xl),
              child: LinearProgressIndicator(color: colors.accent, backgroundColor: colors.accent.withValues(alpha: 0.1)),
            ),
          if (_extendedData != null) ...[
            const SizedBox(height: Spacing.xl),
            _SectionHeader(title: s.extendedInfo.toUpperCase()),
            const SizedBox(height: Spacing.md),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
              child: Column(
                children: [
                  if (_extendedData!['status'] == 'fail')
                    Padding(
                      padding: const EdgeInsets.all(Spacing.sm),
                      child: Text(
                        'Lookup failed: ${_extendedData!['message'] ?? 'Unknown error'}',
                        style: const TextStyle(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    )
                  else ...[
                    if (_extendedData!['isp'] != null) _DetailRow(label: 'ISP', value: _extendedData!['isp'].toString()),
                    if (_extendedData!['org'] != null) _DetailRow(label: 'Org', value: _extendedData!['org'].toString()),
                    if (_extendedData!['country'] != null)
                      _DetailRow(
                        label: s.location,
                        value: '${_extendedData!['city'] ?? ''}, ${_extendedData!['regionName'] ?? ''} ${_extendedData!['country'] ?? ''}'.trim(),
                      ),
                    if (_extendedData!['timezone'] != null) _DetailRow(label: 'Timezone', value: _extendedData!['timezone'].toString()),
                    if (_extendedData!['lat'] != null && _extendedData!['lon'] != null)
                      _DetailRow(label: 'Coords', value: '${_extendedData!['lat']}, ${_extendedData!['lon']}', isMono: true),
                    if (_extendedData!['as'] != null) _DetailRow(label: 'AS', value: _extendedData!['as'].toString(), isMono: true),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: Spacing.xxxl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Copy logic
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text(s.copyResult),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ReportService.instance.shareDiagnosticLog(
                      widget.log.label,
                      widget.log.type.name.toUpperCase(),
                      widget.log.value,
                      widget.log.metadata,
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: Text(s.share),
                ),
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: context.netChui.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.netChui.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: context.netChui.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.isMono = false});
  final String label;
  final String value;
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label[0].toUpperCase() + label.substring(1),
            style: TextStyle(color: colors.muted, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: colors.text,
                fontFamily: isMono ? 'JetBrainsMono' : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
