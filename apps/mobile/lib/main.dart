import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/network/supabase_client.dart';
import 'core/routing/deep_link_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await SupabaseService.init();
  await DeepLinkHandler.instance.init();

  runApp(const WasalniApp());
}
