import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<String?> signUp(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(email: email, password: password);
      if (response.user == null) {
        return 'Đăng ký thất bại';
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);
      if (response.user == null) {
        return 'Đăng nhập thất bại';
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
