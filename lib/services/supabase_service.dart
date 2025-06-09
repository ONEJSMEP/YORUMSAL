import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';

class SupabaseService {
  SupabaseClient? _client;

  SupabaseClient get client {
    if (_client == null) {
      throw Exception("Supabase client not initialized. Call initialize() first.");
    }
    return _client!;
  }

  Future<void> initialize() async {
    if (_client == null) {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      print('Supabase client initialized.');
    }
  }
}

// Global SupabaseService örneği (veya Provider ile sağlayabilirsiniz)
final supabaseService = SupabaseService();