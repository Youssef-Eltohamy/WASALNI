import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'core/supabase/supabase_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  setupDi();
  runApp(const App());
}
