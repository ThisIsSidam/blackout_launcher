import 'package:blackout_launcher/app.dart';
import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(HiveBox.appCategories.name);

  runApp(const ProviderScope(child: MyApp()));
}