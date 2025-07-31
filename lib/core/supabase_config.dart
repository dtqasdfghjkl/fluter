import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const supabaseUrl = 'https://difqmdmlzzrsxjeqmamg.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpZnFtZG1senpyc3hqZXFtYW1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMjYyNzUsImV4cCI6MjA2ODkwMjI3NX0.XmdiDQY93iEAuDHni3Dx1DQx1l8Kw0kxQQkB4t597Cg';

  static Future<Supabase> init() async {
    return await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
