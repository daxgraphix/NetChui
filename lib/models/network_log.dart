import 'package:isar/isar.dart';

part 'network_log.g.dart';

@collection
class NetworkLog {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  late String type; // 'DIAGNOSTICS', 'SCAN', 'SIGNAL'

  @Index()
  String category = 'General'; // 'PERFORMANCE', 'SECURITY', 'CONNECTIVITY', 'GENERAL'
  
  int severity = 0; // 0: Info, 1: Low, 2: Medium, 3: High/Critical

  // Generic storage for different result types
  String? rawData; // JSON representation of the full result

  // Summaries for quick viewing
  String? title;
  String? subtitle;
  
  // Specific for signal stability
  double? signalDbm;
  
  // Specific for recommendations
  String? recommendation;

  NetworkLog();
}
