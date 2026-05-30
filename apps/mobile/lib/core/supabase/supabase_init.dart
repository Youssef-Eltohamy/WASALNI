import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initialises the Supabase client from `.env` (SUPABASE_URL + SUPABASE_ANON_KEY).
/// Call once in main() before setupDi().
Future<void> initSupabase() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
}

/// The shared Supabase client.
SupabaseClient get supabaseClient => Supabase.instance.client;
