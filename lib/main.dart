import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/app.dart';
import 'package:otto/data/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Hive for local storage
  await LocalStorageService.init();

  // Run app wrapped in ProviderScope for Riverpod
  runApp(const ProviderScope(child: OttoApp()));
}
