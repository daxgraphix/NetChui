import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'NetChui'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Internet speed test'**
  String get tagline;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get startTest;

  /// No description provided for @testAgain.
  ///
  /// In en, this message translates to:
  /// **'Test again'**
  String get testAgain;

  /// No description provided for @testing.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get testing;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get offline;

  /// No description provided for @offlineHint.
  ///
  /// In en, this message translates to:
  /// **'It looks like you\'re not connected to the internet. Please check your Wi-Fi or mobile data.'**
  String get offlineHint;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Ping = HTTP latency · Data stays on your device'**
  String get poweredBy;

  /// No description provided for @ping.
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get ping;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @jitter.
  ///
  /// In en, this message translates to:
  /// **'Jitter'**
  String get jitter;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No tests yet'**
  String get noHistory;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @connectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Connection info'**
  String get connectionInfo;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @serviceProvider.
  ///
  /// In en, this message translates to:
  /// **'Service provider'**
  String get serviceProvider;

  /// No description provided for @testInfo.
  ///
  /// In en, this message translates to:
  /// **'Test info'**
  String get testInfo;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanning;

  /// No description provided for @signalStrength.
  ///
  /// In en, this message translates to:
  /// **'Signal strength'**
  String get signalStrength;

  /// No description provided for @signalStability.
  ///
  /// In en, this message translates to:
  /// **'Signal Stability (dBm)'**
  String get signalStability;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @networkDetails.
  ///
  /// In en, this message translates to:
  /// **'Network details'**
  String get networkDetails;

  /// No description provided for @loadedLatency.
  ///
  /// In en, this message translates to:
  /// **'Loaded latency'**
  String get loadedLatency;

  /// No description provided for @latencyDetails.
  ///
  /// In en, this message translates to:
  /// **'Latency details'**
  String get latencyDetails;

  /// No description provided for @downloadPing.
  ///
  /// In en, this message translates to:
  /// **'Download ping'**
  String get downloadPing;

  /// No description provided for @uploadPing.
  ///
  /// In en, this message translates to:
  /// **'Upload ping'**
  String get uploadPing;

  /// No description provided for @radio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get radio;

  /// No description provided for @carrier.
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get carrier;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @os.
  ///
  /// In en, this message translates to:
  /// **'OS'**
  String get os;

  /// No description provided for @ssid.
  ///
  /// In en, this message translates to:
  /// **'SSID'**
  String get ssid;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @runTestToGetRecs.
  ///
  /// In en, this message translates to:
  /// **'Run a speed test to get personalized network recommendations.'**
  String get runTestToGetRecs;

  /// No description provided for @rec4k.
  ///
  /// In en, this message translates to:
  /// **'4K Ultra HD Streaming'**
  String get rec4k;

  /// No description provided for @recGaming.
  ///
  /// In en, this message translates to:
  /// **'Competitive Gaming'**
  String get recGaming;

  /// No description provided for @recCloud.
  ///
  /// In en, this message translates to:
  /// **'Large Cloud Backups'**
  String get recCloud;

  /// No description provided for @recHd.
  ///
  /// In en, this message translates to:
  /// **'HD Video Streaming'**
  String get recHd;

  /// No description provided for @recVideoConf.
  ///
  /// In en, this message translates to:
  /// **'Video Conferencing'**
  String get recVideoConf;

  /// No description provided for @recWork.
  ///
  /// In en, this message translates to:
  /// **'Remote Work'**
  String get recWork;

  /// No description provided for @recBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Web Browsing'**
  String get recBrowsing;

  /// No description provided for @recMusic.
  ///
  /// In en, this message translates to:
  /// **'Music Streaming'**
  String get recMusic;

  /// No description provided for @recSocial.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get recSocial;

  /// No description provided for @recBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Connectivity'**
  String get recBasic;

  /// No description provided for @lanScanner.
  ///
  /// In en, this message translates to:
  /// **'LAN Scanner'**
  String get lanScanner;

  /// No description provided for @connectedDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected Devices'**
  String get connectedDevices;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @scanNetwork.
  ///
  /// In en, this message translates to:
  /// **'Scan Network'**
  String get scanNetwork;

  /// No description provided for @readyToScan.
  ///
  /// In en, this message translates to:
  /// **'Ready to scan your network'**
  String get readyToScan;

  /// No description provided for @genericDevice.
  ///
  /// In en, this message translates to:
  /// **'Generic Device'**
  String get genericDevice;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get you;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'THIS DEVICE'**
  String get thisDevice;

  /// No description provided for @networkInfo.
  ///
  /// In en, this message translates to:
  /// **'Network Info'**
  String get networkInfo;

  /// No description provided for @hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @openServices.
  ///
  /// In en, this message translates to:
  /// **'Open Services'**
  String get openServices;

  /// No description provided for @fullScan.
  ///
  /// In en, this message translates to:
  /// **'Full Scan'**
  String get fullScan;

  /// No description provided for @noPortsDetected.
  ///
  /// In en, this message translates to:
  /// **'No common ports detected'**
  String get noPortsDetected;

  /// No description provided for @offlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineStatus;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @statusExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get statusExcellent;

  /// No description provided for @statusGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get statusGood;

  /// No description provided for @statusFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get statusFair;

  /// No description provided for @statusPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get statusPoor;

  /// No description provided for @statusUnstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get statusUnstable;

  /// No description provided for @targetHost.
  ///
  /// In en, this message translates to:
  /// **'Target Host / IP'**
  String get targetHost;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'RESULTS'**
  String get results;

  /// No description provided for @noResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get noResultsYet;

  /// No description provided for @copyResult.
  ///
  /// In en, this message translates to:
  /// **'Copy Result'**
  String get copyResult;

  /// No description provided for @resultData.
  ///
  /// In en, this message translates to:
  /// **'RESULT DATA'**
  String get resultData;

  /// No description provided for @extendedInfo.
  ///
  /// In en, this message translates to:
  /// **'EXTENDED INFO'**
  String get extendedInfo;

  /// No description provided for @metadata.
  ///
  /// In en, this message translates to:
  /// **'METADATA'**
  String get metadata;

  /// No description provided for @channelUsage.
  ///
  /// In en, this message translates to:
  /// **'Channel Usage'**
  String get channelUsage;

  /// No description provided for @detectedNetworks.
  ///
  /// In en, this message translates to:
  /// **'Detected Networks'**
  String get detectedNetworks;

  /// No description provided for @optimalChannel.
  ///
  /// In en, this message translates to:
  /// **'Optimal Channel'**
  String get optimalChannel;

  /// No description provided for @bestAvailableChannel.
  ///
  /// In en, this message translates to:
  /// **'Best Available Channel'**
  String get bestAvailableChannel;

  /// No description provided for @hiddenNetwork.
  ///
  /// In en, this message translates to:
  /// **'Hidden Network'**
  String get hiddenNetwork;

  /// No description provided for @signalAndDistance.
  ///
  /// In en, this message translates to:
  /// **'SIGNAL & DISTANCE'**
  String get signalAndDistance;

  /// No description provided for @estimatedDistance.
  ///
  /// In en, this message translates to:
  /// **'Estimated Distance'**
  String get estimatedDistance;

  /// No description provided for @technicalSpecs.
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL SPECS'**
  String get technicalSpecs;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get security;

  /// No description provided for @capabilities.
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get capabilities;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @optimal.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get optimal;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @unstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get unstable;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @streamingAndVideo.
  ///
  /// In en, this message translates to:
  /// **'Streaming & Video'**
  String get streamingAndVideo;

  /// No description provided for @gaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get gaming;

  /// No description provided for @workAndProductivity.
  ///
  /// In en, this message translates to:
  /// **'Work & Productivity'**
  String get workAndProductivity;

  /// No description provided for @channelAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Channel Analyzer'**
  String get channelAnalyzer;

  /// No description provided for @diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnostics;

  /// No description provided for @dnsLookup.
  ///
  /// In en, this message translates to:
  /// **'DNS Lookup'**
  String get dnsLookup;

  /// No description provided for @portScan.
  ///
  /// In en, this message translates to:
  /// **'Port Scan'**
  String get portScan;

  /// No description provided for @dnsSpeedTest.
  ///
  /// In en, this message translates to:
  /// **'DNS Speed Test'**
  String get dnsSpeedTest;

  /// No description provided for @networkTools.
  ///
  /// In en, this message translates to:
  /// **'Network Tools'**
  String get networkTools;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @testSize.
  ///
  /// In en, this message translates to:
  /// **'Test size'**
  String get testSize;

  /// No description provided for @testMode.
  ///
  /// In en, this message translates to:
  /// **'Test type'**
  String get testMode;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @trend.
  ///
  /// In en, this message translates to:
  /// **'Download trend'**
  String get trend;

  /// No description provided for @vsLast.
  ///
  /// In en, this message translates to:
  /// **'vs last'**
  String get vsLast;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Let\'s try that again.'**
  String get errorGeneric;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'We can\'t reach our servers right now. Please try again in a moment.'**
  String get serverError;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all history?'**
  String get clearHistoryConfirm;

  /// No description provided for @allHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'All history and logs cleared'**
  String get allHistoryCleared;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'NetChui needs notification permission to remind you about daily speed tests. You can turn this off anytime in settings.'**
  String get notificationPermissionBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a speed test'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection today with NetChui'**
  String get reminderBody;

  /// No description provided for @testModeFull.
  ///
  /// In en, this message translates to:
  /// **'Full test'**
  String get testModeFull;

  /// No description provided for @testModePing.
  ///
  /// In en, this message translates to:
  /// **'Ping only'**
  String get testModePing;

  /// No description provided for @testModeDownload.
  ///
  /// In en, this message translates to:
  /// **'Download only'**
  String get testModeDownload;

  /// No description provided for @testModeUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload only'**
  String get testModeUpload;

  /// No description provided for @testSizeQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick (less data)'**
  String get testSizeQuick;

  /// No description provided for @testSizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get testSizeStandard;

  /// No description provided for @testSizeAccurate.
  ///
  /// In en, this message translates to:
  /// **'Accurate (more data)'**
  String get testSizeAccurate;

  /// No description provided for @measuringPing.
  ///
  /// In en, this message translates to:
  /// **'Measuring ping…'**
  String get measuringPing;

  /// No description provided for @measuringDownload.
  ///
  /// In en, this message translates to:
  /// **'Testing download…'**
  String get measuringDownload;

  /// No description provided for @measuringUpload.
  ///
  /// In en, this message translates to:
  /// **'Testing upload…'**
  String get measuringUpload;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Real-world speed'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Measure download, upload, and network delay in a few taps.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Ping & jitter'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Ping uses HTTP round-trip (not ICMP). We also show min, max, and jitter.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Your privacy'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'No account required. History is stored only on this device.'**
  String get onboardingBody3;

  /// No description provided for @privacyBullet1.
  ///
  /// In en, this message translates to:
  /// **'No sign-up and no data selling'**
  String get privacyBullet1;

  /// No description provided for @privacyBullet2.
  ///
  /// In en, this message translates to:
  /// **'Test history stays on your device only'**
  String get privacyBullet2;

  /// No description provided for @privacyBullet3.
  ///
  /// In en, this message translates to:
  /// **'Tests use public endpoints (e.g. Cloudflare, Tele2)'**
  String get privacyBullet3;

  /// No description provided for @privacyBullet4.
  ///
  /// In en, this message translates to:
  /// **'Ping is measured via HTTP, not ICMP'**
  String get privacyBullet4;

  /// No description provided for @privacyBullet5.
  ///
  /// In en, this message translates to:
  /// **'You can clear history anytime'**
  String get privacyBullet5;

  /// No description provided for @errorScanningWifi.
  ///
  /// In en, this message translates to:
  /// **'Error scanning Wi-Fi: {error}'**
  String errorScanningWifi(Object error);

  /// No description provided for @noNetworksDetected.
  ///
  /// In en, this message translates to:
  /// **'No networks detected'**
  String get noNetworksDetected;

  /// No description provided for @noNetworksFound.
  ///
  /// In en, this message translates to:
  /// **'No networks found'**
  String get noNetworksFound;

  /// No description provided for @switchChannelRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Switch to Channel {channel} for the best performance on {band}GHz.'**
  String switchChannelRecommendation(Object band, Object channel);

  /// No description provided for @channel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channel;

  /// No description provided for @dnsBenchmark.
  ///
  /// In en, this message translates to:
  /// **'DNS Benchmark'**
  String get dnsBenchmark;

  /// No description provided for @dnsBestResult.
  ///
  /// In en, this message translates to:
  /// **'Best: {provider} ({ms}ms)'**
  String dnsBestResult(Object ms, Object provider);

  /// No description provided for @benchmarking.
  ///
  /// In en, this message translates to:
  /// **'BENCHMARKING...'**
  String get benchmarking;

  /// No description provided for @runFullBenchmark.
  ///
  /// In en, this message translates to:
  /// **'RUN FULL BENCHMARK'**
  String get runFullBenchmark;

  /// No description provided for @dnsLatencyHint.
  ///
  /// In en, this message translates to:
  /// **'DNS latency affects how fast websites start loading. Lower values are better.'**
  String get dnsLatencyHint;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @testDate.
  ///
  /// In en, this message translates to:
  /// **'Test Date'**
  String get testDate;

  /// No description provided for @speedTestReport.
  ///
  /// In en, this message translates to:
  /// **'NetChui Speed Test Report'**
  String get speedTestReport;

  /// No description provided for @loadedDownload.
  ///
  /// In en, this message translates to:
  /// **'Loaded Download'**
  String get loadedDownload;

  /// No description provided for @loadedUpload.
  ///
  /// In en, this message translates to:
  /// **'Loaded Upload'**
  String get loadedUpload;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get severityHigh;

  /// No description provided for @severityMedium.
  ///
  /// In en, this message translates to:
  /// **'MED'**
  String get severityMedium;

  /// No description provided for @severityLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get severityLow;

  /// No description provided for @fastest.
  ///
  /// In en, this message translates to:
  /// **'FASTEST'**
  String get fastest;

  /// No description provided for @networkReport.
  ///
  /// In en, this message translates to:
  /// **'NetChui Network Report'**
  String get networkReport;

  /// No description provided for @pdfReport.
  ///
  /// In en, this message translates to:
  /// **'NetChui Network PDF Report'**
  String get pdfReport;

  /// No description provided for @healthReport.
  ///
  /// In en, this message translates to:
  /// **'NetChui Network Health Report'**
  String get healthReport;

  /// No description provided for @comprehensiveReport.
  ///
  /// In en, this message translates to:
  /// **'NetChui Comprehensive Network Report'**
  String get comprehensiveReport;

  /// No description provided for @diagnosticReport.
  ///
  /// In en, this message translates to:
  /// **'NetChui Diagnostic Event Report'**
  String get diagnosticReport;

  /// No description provided for @securityAudit.
  ///
  /// In en, this message translates to:
  /// **'NetChui Security Audit'**
  String get securityAudit;

  /// No description provided for @healthAudit.
  ///
  /// In en, this message translates to:
  /// **'Network Health Audit'**
  String get healthAudit;

  /// No description provided for @overallHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Health Score'**
  String get overallHealthScore;

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Information'**
  String get deviceInfo;

  /// No description provided for @networkStability.
  ///
  /// In en, this message translates to:
  /// **'Network Stability'**
  String get networkStability;

  /// No description provided for @automatedReportBy.
  ///
  /// In en, this message translates to:
  /// **'Automated Report by NetChui'**
  String get automatedReportBy;

  /// No description provided for @generatedBy.
  ///
  /// In en, this message translates to:
  /// **'Generated by NetChui App'**
  String get generatedBy;

  /// No description provided for @currentDeviceConnection.
  ///
  /// In en, this message translates to:
  /// **'Current Device & Connection'**
  String get currentDeviceConnection;

  /// No description provided for @latestSpeedTest.
  ///
  /// In en, this message translates to:
  /// **'Latest Speed Test Results'**
  String get latestSpeedTest;

  /// No description provided for @noSpeedTestData.
  ///
  /// In en, this message translates to:
  /// **'No speed test data available.'**
  String get noSpeedTestData;

  /// No description provided for @networkTrends7Days.
  ///
  /// In en, this message translates to:
  /// **'Network Trends (Last 7 Days)'**
  String get networkTrends7Days;

  /// No description provided for @averageDownload.
  ///
  /// In en, this message translates to:
  /// **'Average Download'**
  String get averageDownload;

  /// No description provided for @connectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Connection Details'**
  String get connectionDetails;

  /// No description provided for @latencyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Latency Metrics'**
  String get latencyMetrics;

  /// No description provided for @minLatency.
  ///
  /// In en, this message translates to:
  /// **'Min Latency'**
  String get minLatency;

  /// No description provided for @maxLatency.
  ///
  /// In en, this message translates to:
  /// **'Max Latency'**
  String get maxLatency;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @minSeverity.
  ///
  /// In en, this message translates to:
  /// **'Min Severity'**
  String get minSeverity;

  /// No description provided for @noLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No logs found for the selected filters.'**
  String get noLogsFound;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @networkPerimeterAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Network Perimeter Analysis'**
  String get networkPerimeterAnalysis;

  /// No description provided for @recentSecurityEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Events'**
  String get recentSecurityEvents;

  /// No description provided for @noSecurityEvents.
  ///
  /// In en, this message translates to:
  /// **'No security-related events or scans recorded.'**
  String get noSecurityEvents;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @securityRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Security Recommendations'**
  String get securityRecommendations;

  /// No description provided for @recScanDevices.
  ///
  /// In en, this message translates to:
  /// **'Regularly scan for unknown devices on your network.'**
  String get recScanDevices;

  /// No description provided for @recDisableUpnp.
  ///
  /// In en, this message translates to:
  /// **'Ensure UPnP is disabled on your router if not required.'**
  String get recDisableUpnp;

  /// No description provided for @recWpa3.
  ///
  /// In en, this message translates to:
  /// **'Use strong WPA3-SAE encryption if supported by your hardware.'**
  String get recWpa3;

  /// No description provided for @automatedSecurityAudit.
  ///
  /// In en, this message translates to:
  /// **'Automated Security Audit by NetChui'**
  String get automatedSecurityAudit;

  /// No description provided for @networkScore.
  ///
  /// In en, this message translates to:
  /// **'NETWORK SCORE'**
  String get networkScore;

  /// No description provided for @deviceAndSystem.
  ///
  /// In en, this message translates to:
  /// **'DEVICE & SYSTEM'**
  String get deviceAndSystem;

  /// No description provided for @networkState.
  ///
  /// In en, this message translates to:
  /// **'NETWORK STATE'**
  String get networkState;

  /// No description provided for @lastTestPerformance.
  ///
  /// In en, this message translates to:
  /// **'LAST TEST PERFORMANCE'**
  String get lastTestPerformance;

  /// No description provided for @exportReports.
  ///
  /// In en, this message translates to:
  /// **'EXPORT REPORTS'**
  String get exportReports;

  /// No description provided for @exportOptions.
  ///
  /// In en, this message translates to:
  /// **'EXPORT OPTIONS'**
  String get exportOptions;

  /// No description provided for @signalDetails.
  ///
  /// In en, this message translates to:
  /// **'Signal Details'**
  String get signalDetails;

  /// No description provided for @signalStrengthGraph.
  ///
  /// In en, this message translates to:
  /// **'SIGNAL STRENGTH (% vs SEC)'**
  String get signalStrengthGraph;

  /// No description provided for @networkTrafficGraph.
  ///
  /// In en, this message translates to:
  /// **'NETWORK TRAFFIC (bps vs SEC)'**
  String get networkTrafficGraph;

  /// No description provided for @wifiDetails.
  ///
  /// In en, this message translates to:
  /// **'WIFI DETAILS'**
  String get wifiDetails;

  /// No description provided for @cellularDetails.
  ///
  /// In en, this message translates to:
  /// **'CELLULAR DETAILS'**
  String get cellularDetails;

  /// No description provided for @ipAndNetwork.
  ///
  /// In en, this message translates to:
  /// **'IP & NETWORK'**
  String get ipAndNetwork;

  /// No description provided for @healthStatusHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthStatusHealthy;

  /// No description provided for @healthStatusFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get healthStatusFair;

  /// No description provided for @healthStatusPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get healthStatusPoor;

  /// No description provided for @healthMetricSignalStability.
  ///
  /// In en, this message translates to:
  /// **'Signal Stability'**
  String get healthMetricSignalStability;

  /// No description provided for @healthMetricDownloadSpeed.
  ///
  /// In en, this message translates to:
  /// **'Download Speed'**
  String get healthMetricDownloadSpeed;

  /// No description provided for @healthMetricDnsLatency.
  ///
  /// In en, this message translates to:
  /// **'DNS Latency'**
  String get healthMetricDnsLatency;

  /// No description provided for @healthMetricSecurityAudit.
  ///
  /// In en, this message translates to:
  /// **'Security Audit'**
  String get healthMetricSecurityAudit;

  /// No description provided for @healthValueSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get healthValueSecure;

  /// No description provided for @healthValueWarnings.
  ///
  /// In en, this message translates to:
  /// **'{count} Warnings'**
  String healthValueWarnings(Object count);

  /// No description provided for @insightLowSignal.
  ///
  /// In en, this message translates to:
  /// **'Your average signal strength is low. Consider moving closer to your router.'**
  String get insightLowSignal;

  /// No description provided for @insightHighFluctuations.
  ///
  /// In en, this message translates to:
  /// **'High signal fluctuations detected. Check for interference from other electronic devices.'**
  String get insightHighFluctuations;

  /// No description provided for @insightSlowSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average download speeds are below recommended levels for HD streaming.'**
  String get insightSlowSpeed;

  /// No description provided for @insightSlowDns.
  ///
  /// In en, this message translates to:
  /// **'Slow DNS response times detected. Switching to a provider like Cloudflare (1.1.1.1) could improve browsing speed.'**
  String get insightSlowDns;

  /// No description provided for @insightSecurityVulnerability.
  ///
  /// In en, this message translates to:
  /// **'Security scan detected {count} potential vulnerabilities (open ports or unexpected devices). Review your firewall settings.'**
  String insightSecurityVulnerability(Object count);

  /// No description provided for @networkInsights.
  ///
  /// In en, this message translates to:
  /// **'Network Insights'**
  String get networkInsights;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @signalTrends.
  ///
  /// In en, this message translates to:
  /// **'Signal Trends'**
  String get signalTrends;

  /// No description provided for @activityLogs.
  ///
  /// In en, this message translates to:
  /// **'Activity Logs'**
  String get activityLogs;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'KEY METRICS'**
  String get keyMetrics;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI INSIGHTS'**
  String get aiInsights;

  /// No description provided for @downloadSpeedTrend.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD SPEED TREND'**
  String get downloadSpeedTrend;

  /// No description provided for @uploadSpeedTrend.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD SPEED TREND'**
  String get uploadSpeedTrend;

  /// No description provided for @weeklyStability.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY STABILITY'**
  String get weeklyStability;

  /// No description provided for @avgDownload.
  ///
  /// In en, this message translates to:
  /// **'AVG DOWNLOAD'**
  String get avgDownload;

  /// No description provided for @peakSpeed.
  ///
  /// In en, this message translates to:
  /// **'PEAK SPEED'**
  String get peakSpeed;

  /// No description provided for @technicalData.
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL DATA'**
  String get technicalData;

  /// No description provided for @noHealthData.
  ///
  /// In en, this message translates to:
  /// **'No health data available.'**
  String get noHealthData;

  /// No description provided for @networkIs.
  ///
  /// In en, this message translates to:
  /// **'Network is {status}'**
  String networkIs(Object status);

  /// No description provided for @basedOnActivity7Days.
  ///
  /// In en, this message translates to:
  /// **'Based on your activity over the last 7 days.'**
  String get basedOnActivity7Days;

  /// No description provided for @noSpeedHistory.
  ///
  /// In en, this message translates to:
  /// **'No speed test history yet.'**
  String get noSpeedHistory;

  /// No description provided for @needMoreData.
  ///
  /// In en, this message translates to:
  /// **'Need more data points...'**
  String get needMoreData;

  /// No description provided for @noSignalHistory.
  ///
  /// In en, this message translates to:
  /// **'No signal history recorded yet.'**
  String get noSignalHistory;

  /// No description provided for @collectingMoreData.
  ///
  /// In en, this message translates to:
  /// **'Collecting more data...'**
  String get collectingMoreData;

  /// No description provided for @noToolActivity.
  ///
  /// In en, this message translates to:
  /// **'No tool activity recorded yet.'**
  String get noToolActivity;

  /// No description provided for @networkActivity.
  ///
  /// In en, this message translates to:
  /// **'Network Activity'**
  String get networkActivity;

  /// No description provided for @logDetails.
  ///
  /// In en, this message translates to:
  /// **'Log Details'**
  String get logDetails;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE'**
  String get average;

  /// No description provided for @lowest.
  ///
  /// In en, this message translates to:
  /// **'LOWEST'**
  String get lowest;

  /// No description provided for @highest.
  ///
  /// In en, this message translates to:
  /// **'HIGHEST'**
  String get highest;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @publicIp.
  ///
  /// In en, this message translates to:
  /// **'Public IP'**
  String get publicIp;

  /// No description provided for @isp.
  ///
  /// In en, this message translates to:
  /// **'ISP'**
  String get isp;

  /// No description provided for @noTestDataYet.
  ///
  /// In en, this message translates to:
  /// **'No test data yet'**
  String get noTestDataYet;

  /// No description provided for @healthScoreAudit.
  ///
  /// In en, this message translates to:
  /// **'Health Score Audit'**
  String get healthScoreAudit;

  /// No description provided for @healthScoreAuditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed breakdown of current connectivity'**
  String get healthScoreAuditSubtitle;

  /// No description provided for @securityAuditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vulnerability scans and network perimeter logs'**
  String get securityAuditSubtitle;

  /// No description provided for @fullNetworkAudit.
  ///
  /// In en, this message translates to:
  /// **'Full Network Audit'**
  String get fullNetworkAudit;

  /// No description provided for @fullNetworkAuditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive status & test history'**
  String get fullNetworkAuditSubtitle;

  /// No description provided for @performanceLogs.
  ///
  /// In en, this message translates to:
  /// **'Performance Logs'**
  String get performanceLogs;

  /// No description provided for @performanceLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All speed tests and stability data'**
  String get performanceLogsSubtitle;

  /// No description provided for @latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get latency;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @realTimePingTrend.
  ///
  /// In en, this message translates to:
  /// **'Real-time Ping Trend'**
  String get realTimePingTrend;

  /// No description provided for @rec4kDesc.
  ///
  /// In en, this message translates to:
  /// **'Supports 4K UHD streaming seamlessly.'**
  String get rec4kDesc;

  /// No description provided for @recGamingDesc.
  ///
  /// In en, this message translates to:
  /// **'Low latency for competitive gaming.'**
  String get recGamingDesc;

  /// No description provided for @recHdDesc.
  ///
  /// In en, this message translates to:
  /// **'Smooth HD video playback.'**
  String get recHdDesc;

  /// No description provided for @recVideoConfDesc.
  ///
  /// In en, this message translates to:
  /// **'Reliable for work and video calls.'**
  String get recVideoConfDesc;

  /// No description provided for @recBrowsingDesc.
  ///
  /// In en, this message translates to:
  /// **'Good for social and web browsing.'**
  String get recBrowsingDesc;

  /// No description provided for @recSocialDesc.
  ///
  /// In en, this message translates to:
  /// **'Moderate speed for messaging.'**
  String get recSocialDesc;

  /// No description provided for @recBasicDesc.
  ///
  /// In en, this message translates to:
  /// **'Limited to basic internet tasks.'**
  String get recBasicDesc;

  /// No description provided for @liveMonitor.
  ///
  /// In en, this message translates to:
  /// **'Live Monitor'**
  String get liveMonitor;

  /// No description provided for @speedHistory.
  ///
  /// In en, this message translates to:
  /// **'Speed History'**
  String get speedHistory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
