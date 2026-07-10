import 'package:flutter/material.dart';
import 'package:net_chui/models/speed_test_server.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/models/test_size.dart';

class AppSettings {
  const AppSettings({
    this.onboardingDone = false,
    this.themeMode = ThemeMode.light,
    this.serverId = 'cloudflare',
    this.testSize = TestSize.standard,
    this.testMode = TestMode.full,
    this.dailyReminderEnabled = false,
    this.reminderHour = 9,
    this.reminderMinute = 0,
  });

  final bool onboardingDone;
  final ThemeMode themeMode;
  final String serverId;
  final TestSize testSize;
  final TestMode testMode;
  final bool dailyReminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  AppSettings copyWith({
    bool? onboardingDone,
    ThemeMode? themeMode,
    String? serverId,
    TestSize? testSize,
    TestMode? testMode,
    bool? dailyReminderEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return AppSettings(
      onboardingDone: onboardingDone ?? this.onboardingDone,
      themeMode: themeMode ?? this.themeMode,
      serverId: serverId ?? this.serverId,
      testSize: testSize ?? this.testSize,
      testMode: testMode ?? this.testMode,
      dailyReminderEnabled:
          dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  Map<String, dynamic> toJson() => {
        'onboardingDone': onboardingDone,
        'themeMode': themeMode.index,
        'serverId': serverId,
        'testSize': testSize.name,
        'testMode': testMode.name,
        'dailyReminderEnabled': dailyReminderEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      onboardingDone: json['onboardingDone'] as bool? ?? false,
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 1],
      serverId: json['serverId'] as String? ?? SpeedTestServer.cloudflare.id,
      testSize: TestSize.values.firstWhere(
        (s) => s.name == json['testSize'],
        orElse: () => TestSize.standard,
      ),
      testMode: TestMode.values.firstWhere(
        (m) => m.name == json['testMode'],
        orElse: () => TestMode.full,
      ),
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? false,
      reminderHour: json['reminderHour'] as int? ?? 9,
      reminderMinute: json['reminderMinute'] as int? ?? 0,
    );
  }
}
