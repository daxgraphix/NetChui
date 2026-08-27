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

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

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

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @faqSearch.
  ///
  /// In en, this message translates to:
  /// **'Search questions...'**
  String get faqSearch;

  /// No description provided for @faqCatGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get faqCatGeneral;

  /// No description provided for @faqCatTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get faqCatTechnical;

  /// No description provided for @faqCatPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get faqCatPrivacy;

  /// No description provided for @appGuides.
  ///
  /// In en, this message translates to:
  /// **'App Guides'**
  String get appGuides;

  /// No description provided for @guidesTitle.
  ///
  /// In en, this message translates to:
  /// **'App Guides & Tutorials'**
  String get guidesTitle;

  /// No description provided for @guidesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search guides...'**
  String get guidesSearch;

  /// No description provided for @guidesCatBasics.
  ///
  /// In en, this message translates to:
  /// **'The Basics'**
  String get guidesCatBasics;

  /// No description provided for @guidesCatOptimization.
  ///
  /// In en, this message translates to:
  /// **'Optimization'**
  String get guidesCatOptimization;

  /// No description provided for @guidesCatAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced Tech'**
  String get guidesCatAdvanced;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How accurate are the speed tests?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'NetChui uses high-performance edge servers (Cloudflare, Tele2, etc.) to ensure low latency and high accuracy. However, results can vary based on network congestion and your device\'s hardware.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'What is Jitter?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Jitter is the variation in time delay between data packets sent over a network. Lower jitter means a more stable connection, which is crucial for gaming and video calls.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'Does this app use a lot of data?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Standard tests use about 20-50MB. Quick tests use less, while \'Accurate\' tests can use over 100MB to fully saturate your connection.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'Why is my speed lower than my plan?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Speeds advertised by ISPs are \'up to\' values. Factors like Wi-Fi interference, distance from the router, number of connected devices, and background app usage can lower results.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'2.4GHz vs 5GHz Wi-Fi?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'2.4GHz has better range but lower speeds. 5GHz (and 6GHz) offers much higher speeds but doesn\'t travel through walls as effectively. Use 5GHz when close to the router.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'Why is Upload usually slower?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'Most residential internet plans are \'asymmetric\', meaning they prioritize download bandwidth for streaming and browsing over upload bandwidth.'**
  String get faqA6;

  /// No description provided for @faqQ7.
  ///
  /// In en, this message translates to:
  /// **'How can I lower my Ping?'**
  String get faqQ7;

  /// No description provided for @faqA7.
  ///
  /// In en, this message translates to:
  /// **'To lower ping, use a wired Ethernet connection if possible, move closer to your router, close background downloads, and ensure you\'re testing against a server physically close to you.'**
  String get faqA7;

  /// No description provided for @faqQ8.
  ///
  /// In en, this message translates to:
  /// **'What is a \'Good\' speed?'**
  String get faqQ8;

  /// No description provided for @faqA8.
  ///
  /// In en, this message translates to:
  /// **'For basic browsing, 5-10 Mbps is enough. For 4K streaming, you need 25+ Mbps. For a smooth multi-user household, 100+ Mbps is recommended.'**
  String get faqA8;

  /// No description provided for @faqQ9.
  ///
  /// In en, this message translates to:
  /// **'Does NetChui store my location?'**
  String get faqQ9;

  /// No description provided for @faqA9.
  ///
  /// In en, this message translates to:
  /// **'No. NetChui uses your IP address to estimate your ISP and general region for the test, but we do not track or store your precise GPS location.'**
  String get faqA9;

  /// No description provided for @faqQ10.
  ///
  /// In en, this message translates to:
  /// **'What is \'Loaded\' Latency?'**
  String get faqQ10;

  /// No description provided for @faqA10.
  ///
  /// In en, this message translates to:
  /// **'Loaded latency measures your ping while your connection is being used (during download or upload). If this is much higher than your normal ping, you may experience lag while others in your house are streaming or downloading.'**
  String get faqA10;

  /// No description provided for @faqQ11.
  ///
  /// In en, this message translates to:
  /// **'Can I use NetChui for LAN speeds?'**
  String get faqQ11;

  /// No description provided for @faqA11.
  ///
  /// In en, this message translates to:
  /// **'NetChui is primarily for internet speed. To test LAN speeds between devices, use the LAN Scanner tool to identify devices, but actual transfer speeds depend on your internal hardware capabilities.'**
  String get faqA11;

  /// No description provided for @faqQ12.
  ///
  /// In en, this message translates to:
  /// **'How do I export my data?'**
  String get faqQ12;

  /// No description provided for @faqA12.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Activity Logs > Export All Data. You can save your history and diagnostic logs as a JSON file or generate a PDF report from the Report screen.'**
  String get faqA12;

  /// No description provided for @faqQ13.
  ///
  /// In en, this message translates to:
  /// **'Will a VPN affect my results?'**
  String get faqQ13;

  /// No description provided for @faqA13.
  ///
  /// In en, this message translates to:
  /// **'Yes. A VPN encrypts your traffic and routes it through another server, which usually increases latency (ping) and may reduce overall download/upload speeds.'**
  String get faqA13;

  /// No description provided for @faqQ14.
  ///
  /// In en, this message translates to:
  /// **'Mbps vs MB/s: What\'s the difference?'**
  String get faqQ14;

  /// No description provided for @faqA14.
  ///
  /// In en, this message translates to:
  /// **'Mbps stands for Megabits per second (used for internet speeds). MB/s stands for Megabytes per second (used for file sizes). 8 Mbps = 1 MB/s.'**
  String get faqA14;

  /// No description provided for @faqQ15.
  ///
  /// In en, this message translates to:
  /// **'How often should I run a test?'**
  String get faqQ15;

  /// No description provided for @faqA15.
  ///
  /// In en, this message translates to:
  /// **'We recommend testing at different times of the day (morning, afternoon, evening) to see how peak usage in your area affects your performance.'**
  String get faqA15;

  /// No description provided for @faqQ16.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi vs. Internet Speed?'**
  String get faqQ16;

  /// No description provided for @faqA16.
  ///
  /// In en, this message translates to:
  /// **'Your Wi-Fi speed is the connection between your device and router. Internet speed is the connection between your router and the world. NetChui measures the end-to-end internet speed from your device.'**
  String get faqA16;

  /// No description provided for @faqQ17.
  ///
  /// In en, this message translates to:
  /// **'Can weather affect speed?'**
  String get faqQ17;

  /// No description provided for @faqA17.
  ///
  /// In en, this message translates to:
  /// **'Yes, especially for satellite and fixed-wireless connections. Heavy rain or snow (rain fade) can degrade signal quality and reduce speeds or increase latency.'**
  String get faqA17;

  /// No description provided for @faqQ18.
  ///
  /// In en, this message translates to:
  /// **'What is Packet Loss?'**
  String get faqQ18;

  /// No description provided for @faqA18.
  ///
  /// In en, this message translates to:
  /// **'Packet loss occurs when data units fail to reach their destination. It can cause \'stuttering\' in video calls or gaming. NetChui identifies stability issues in the Live Monitor.'**
  String get faqA18;

  /// No description provided for @faqQ19.
  ///
  /// In en, this message translates to:
  /// **'Why use DNS Speed Test?'**
  String get faqQ19;

  /// No description provided for @faqA19.
  ///
  /// In en, this message translates to:
  /// **'DNS is like a phonebook for the internet. Faster DNS means your browser finds websites quicker, making the internet feel much more responsive.'**
  String get faqA19;

  /// No description provided for @faqQ20.
  ///
  /// In en, this message translates to:
  /// **'What is Bufferbloat?'**
  String get faqQ20;

  /// No description provided for @faqA20.
  ///
  /// In en, this message translates to:
  /// **'Bufferbloat is high latency that occurs when there is a lot of traffic on your network. It\'s caused by routers buffering too much data. NetChui\'s \'Loaded Latency\' helps identify this.'**
  String get faqA20;

  /// No description provided for @faqQ21.
  ///
  /// In en, this message translates to:
  /// **'Why is my ping different in games?'**
  String get faqQ21;

  /// No description provided for @faqA21.
  ///
  /// In en, this message translates to:
  /// **'Game pings depend on the location of the game\'s specific servers. NetChui tests against general edge servers. If the game server is further away, your ping will be higher.'**
  String get faqA21;

  /// No description provided for @faqQ22.
  ///
  /// In en, this message translates to:
  /// **'Can I trust \'Free Wi-Fi\'?'**
  String get faqQ22;

  /// No description provided for @faqA22.
  ///
  /// In en, this message translates to:
  /// **'Open Wi-Fi networks can be risky. We recommend using NetChui\'s Port Scan and Security Audit to check for common vulnerabilities when connected to public networks.'**
  String get faqA22;

  /// No description provided for @faqQ23.
  ///
  /// In en, this message translates to:
  /// **'Does my device age matter?'**
  String get faqQ23;

  /// No description provided for @faqA23.
  ///
  /// In en, this message translates to:
  /// **'Yes. Older phones or laptops may have slower Wi-Fi chips (e.g., Wi-Fi 4 instead of Wi-Fi 6), which limits the maximum speed they can handle regardless of your internet plan.'**
  String get faqA23;

  /// No description provided for @faqQ24.
  ///
  /// In en, this message translates to:
  /// **'How does NetChui choose a server?'**
  String get faqQ24;

  /// No description provided for @faqA24.
  ///
  /// In en, this message translates to:
  /// **'By default, NetChui selects the server with the lowest latency to your location. You can manually override this in Settings if you want to test connectivity to a specific region.'**
  String get faqA24;

  /// No description provided for @faqQ25.
  ///
  /// In en, this message translates to:
  /// **'Can I change the test unit?'**
  String get faqQ25;

  /// No description provided for @faqA25.
  ///
  /// In en, this message translates to:
  /// **'Currently, NetChui displays results in Mbps (Megabits per second) as it is the industry standard for network speed. We are looking into adding a MB/s toggle in future updates.'**
  String get faqA25;

  /// No description provided for @faqQ26.
  ///
  /// In en, this message translates to:
  /// **'Does my device case affect Wi-Fi?'**
  String get faqQ26;

  /// No description provided for @faqA26.
  ///
  /// In en, this message translates to:
  /// **'Metal or very thick plastic cases can occasionally attenuate Wi-Fi and cellular signals. If you notice significantly lower speeds, try testing without the case.'**
  String get faqA26;

  /// No description provided for @faqQ27.
  ///
  /// In en, this message translates to:
  /// **'Why does my speed drop at night?'**
  String get faqQ27;

  /// No description provided for @faqA27.
  ///
  /// In en, this message translates to:
  /// **'Network congestion often peaks in the evening when more people in your neighborhood are streaming video. This is common on cable and fixed-wireless networks.'**
  String get faqA27;

  /// No description provided for @faqQ28.
  ///
  /// In en, this message translates to:
  /// **'What is a \'Handshake\'?'**
  String get faqQ28;

  /// No description provided for @faqA28.
  ///
  /// In en, this message translates to:
  /// **'A network handshake is the automated process of negotiation between two devices to establish a connection. High latency can make this process feel sluggish.'**
  String get faqA28;

  /// No description provided for @faqQ29.
  ///
  /// In en, this message translates to:
  /// **'How do I read the Signal Graph?'**
  String get faqQ29;

  /// No description provided for @faqA29.
  ///
  /// In en, this message translates to:
  /// **'The graph shows your signal strength over time. A flat line means a stable connection, while sharp \'valleys\' indicate interference or physical obstructions.'**
  String get faqA29;

  /// No description provided for @faqQ30.
  ///
  /// In en, this message translates to:
  /// **'What are \'Open Ports\'?'**
  String get faqQ30;

  /// No description provided for @faqA30.
  ///
  /// In en, this message translates to:
  /// **'Ports are virtual doorways for data. While some are necessary, unnecessary open ports can be a security risk. NetChui\'s Port Scan helps you identify these.'**
  String get faqA30;

  /// No description provided for @guide1Title.
  ///
  /// In en, this message translates to:
  /// **'Understanding Results'**
  String get guide1Title;

  /// No description provided for @guide1Body.
  ///
  /// In en, this message translates to:
  /// **'Learn what Ping, Download, and Upload speeds mean for your daily internet usage.'**
  String get guide1Body;

  /// No description provided for @guide2Title.
  ///
  /// In en, this message translates to:
  /// **'Optimizing Wi-Fi'**
  String get guide2Title;

  /// No description provided for @guide2Body.
  ///
  /// In en, this message translates to:
  /// **'Tips on router placement and frequency selection to improve your home network.'**
  String get guide2Body;

  /// No description provided for @guide3Title.
  ///
  /// In en, this message translates to:
  /// **'4G vs 5G Explained'**
  String get guide3Title;

  /// No description provided for @guide3Body.
  ///
  /// In en, this message translates to:
  /// **'The differences in latency and speed when using cellular data and how to get the best signal.'**
  String get guide3Body;

  /// No description provided for @guide4Title.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting Slow Internet'**
  String get guide4Title;

  /// No description provided for @guide4Body.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step guide to identify if the issue is with your device, router, or your Service Provider.'**
  String get guide4Body;

  /// No description provided for @guide5Title.
  ///
  /// In en, this message translates to:
  /// **'Security Best Practices'**
  String get guide5Title;

  /// No description provided for @guide5Body.
  ///
  /// In en, this message translates to:
  /// **'How to stay safe on public Wi-Fi and why NetChui\'s security audit is important.'**
  String get guide5Body;

  /// No description provided for @guide6Title.
  ///
  /// In en, this message translates to:
  /// **'Advanced Router Settings'**
  String get guide6Title;

  /// No description provided for @guide6Body.
  ///
  /// In en, this message translates to:
  /// **'A look into QoS, DNS overrides, and firmware updates to squeeze every bit of speed out of your hardware.'**
  String get guide6Body;

  /// No description provided for @guide7Title.
  ///
  /// In en, this message translates to:
  /// **'Interpreting Insights'**
  String get guide7Title;

  /// No description provided for @guide7Body.
  ///
  /// In en, this message translates to:
  /// **'How to use the Insights tab to track your network health score and stability over time.'**
  String get guide7Body;

  /// No description provided for @guide8Title.
  ///
  /// In en, this message translates to:
  /// **'Combating Interference'**
  String get guide8Title;

  /// No description provided for @guide8Body.
  ///
  /// In en, this message translates to:
  /// **'How common household items like microwaves and cordless phones can disrupt your Wi-Fi signal.'**
  String get guide8Body;

  /// No description provided for @guide9Title.
  ///
  /// In en, this message translates to:
  /// **'Mesh vs. Extenders'**
  String get guide9Title;

  /// No description provided for @guide9Body.
  ///
  /// In en, this message translates to:
  /// **'Which technology is better for covering large homes and how they impact your overall throughput.'**
  String get guide9Body;

  /// No description provided for @guide10Title.
  ///
  /// In en, this message translates to:
  /// **'Data Caps & Throttling'**
  String get guide10Title;

  /// No description provided for @guide10Body.
  ///
  /// In en, this message translates to:
  /// **'How to tell if your ISP is intentionally slowing down your connection based on your usage.'**
  String get guide10Body;

  /// No description provided for @guide11Title.
  ///
  /// In en, this message translates to:
  /// **'Gaming Lag Fixes'**
  String get guide11Title;

  /// No description provided for @guide11Body.
  ///
  /// In en, this message translates to:
  /// **'Techniques like using Ethernet, disabling background updates, and choosing the right game servers.'**
  String get guide11Body;

  /// No description provided for @guide12Title.
  ///
  /// In en, this message translates to:
  /// **'Home Office Setup'**
  String get guide12Title;

  /// No description provided for @guide12Body.
  ///
  /// In en, this message translates to:
  /// **'Optimizing your network for stable Zoom and Teams calls without dropouts or \'robotic\' audio.'**
  String get guide12Body;

  /// No description provided for @guide13Title.
  ///
  /// In en, this message translates to:
  /// **'LAN Scanner Security'**
  String get guide13Title;

  /// No description provided for @guide13Body.
  ///
  /// In en, this message translates to:
  /// **'Using the LAN scanner to find unauthorized devices connected to your private Wi-Fi network.'**
  String get guide13Body;

  /// No description provided for @guide14Title.
  ///
  /// In en, this message translates to:
  /// **'Battery & Background Scanning'**
  String get guide14Title;

  /// No description provided for @guide14Body.
  ///
  /// In en, this message translates to:
  /// **'Understanding how NetChui balances real-time signal monitoring with your device\'s battery life.'**
  String get guide14Body;

  /// No description provided for @guide15Title.
  ///
  /// In en, this message translates to:
  /// **'Future Proofing Your Home'**
  String get guide15Title;

  /// No description provided for @guide15Body.
  ///
  /// In en, this message translates to:
  /// **'What to look for in your next router (Wi-Fi 6E/7) to ensure your home network stays fast for years.'**
  String get guide15Body;

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

  /// No description provided for @exportAllData.
  ///
  /// In en, this message translates to:
  /// **'Export All Data'**
  String get exportAllData;

  /// No description provided for @dnsError.
  ///
  /// In en, this message translates to:
  /// **'DNS Error'**
  String get dnsError;

  /// No description provided for @whoisError.
  ///
  /// In en, this message translates to:
  /// **'WHOIS Error'**
  String get whoisError;

  /// No description provided for @portScanError.
  ///
  /// In en, this message translates to:
  /// **'Port Scan Error'**
  String get portScanError;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found for {host}'**
  String noRecordsFound(Object host);

  /// No description provided for @noPortsFound.
  ///
  /// In en, this message translates to:
  /// **'No common open ports found on {host}'**
  String noPortsFound(Object host);

  /// No description provided for @whoisInfo.
  ///
  /// In en, this message translates to:
  /// **'WHOIS Info'**
  String get whoisInfo;

  /// No description provided for @retrievedWhois.
  ///
  /// In en, this message translates to:
  /// **'Retrieved record for {host}'**
  String retrievedWhois(Object host);

  /// No description provided for @clearActivityLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Activity Logs'**
  String get clearActivityLogs;

  /// No description provided for @clearActivityLogsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all activity logs and signal history?'**
  String get clearActivityLogsConfirm;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @runningTool.
  ///
  /// In en, this message translates to:
  /// **'RUNNING {tool}...'**
  String runningTool(Object tool);

  /// No description provided for @personalDevice.
  ///
  /// In en, this message translates to:
  /// **'Personal Device'**
  String get personalDevice;

  /// No description provided for @appleDevice.
  ///
  /// In en, this message translates to:
  /// **'Apple Device'**
  String get appleDevice;

  /// No description provided for @mobileDevice.
  ///
  /// In en, this message translates to:
  /// **'Mobile Device'**
  String get mobileDevice;

  /// No description provided for @smartHome.
  ///
  /// In en, this message translates to:
  /// **'Smart Home'**
  String get smartHome;

  /// No description provided for @performanceEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Start your first speed test to see performance trends here.'**
  String get performanceEmptyState;

  /// No description provided for @signalEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Your signal strength over time will appear here as you move around.'**
  String get signalEmptyState;

  /// No description provided for @activityEmptyState.
  ///
  /// In en, this message translates to:
  /// **'All your diagnostic runs and network scans will be logged here.'**
  String get activityEmptyState;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(Object error);

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;
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
