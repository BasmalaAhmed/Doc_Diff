import 'package:logger/logger.dart';

final Logger appLogger = Logger(
  printer: PrettyPrinter(methodCount: 1, errorMethodCount: 5),
);