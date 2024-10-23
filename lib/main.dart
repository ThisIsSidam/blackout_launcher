import 'package:blackout_launcher/app.dart';
import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteModalAdapter());
  await Hive.openBox(HiveBoxNames.appCategories.name);
  await Hive.openBox(HiveBoxNames.notes.name);
  await Hive.openBox(HiveBoxNames.userSettings.name);
  await Hive.openBox(HiveBoxNames.appLaunchData.name);

  runApp(const ProviderScope(child: MyApp()));
}
