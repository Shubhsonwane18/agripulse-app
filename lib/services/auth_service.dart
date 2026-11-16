import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final Map<String, String> _headers = {
    'apikey': ApiConstants.supabaseAnonKey,
    'Authorization': 'Bearer ${ApiConstants.supabaseAnonKey}',
    'Content-Type': 'application/json',
  };

  // Sign In with Email & Password
  Future<UserProfile?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.supabaseUrl}/auth/v1/token?grant_type=password');
      final res = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final token = data['access_token']?.toString();
        final userId = data['user']?['id']?.toString();

        if (token != null) {
          await StorageService.saveToken(token);
        }

        if (userId != null) {
          final profile = await fetchRemoteProfile(userId);
          if (profile != null) {
            await StorageService.saveProfile(profile);
            return profile;
          }
        }

        // Fallback minimal profile
        final minimal = UserProfile(
          id: userId ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
          fullName: data['user']?['user_metadata']?['full_name'] ?? email.split('@').first,
          email: email,
        );
        await StorageService.saveProfile(minimal);
        return minimal;
      }
    } catch (e) {
      print('[AuthService] signIn error: $e');
    }
    return null;
  }

  // Sign Up with Email & Password
  Future<UserProfile?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.supabaseUrl}/auth/v1/signup');
      final res = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'data': {
            'full_name': fullName,
            'phone': phone,
          }
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        final userId = data['id']?.toString() ?? data['user']?['id']?.toString() ?? 'new_user';
        final token = data['access_token']?.toString();

        if (token != null) {
          await StorageService.saveToken(token);
        }

        final newProfile = UserProfile(
          id: userId,
          fullName: fullName,
          email: email,
          phone: phone,
          language: StorageService.getLocale(),
        );

        // Sync with Supabase profiles table
        await upsertRemoteProfile(newProfile);
        await StorageService.saveProfile(newProfile);
        return newProfile;
      }
    } catch (e) {
      print('[AuthService] signUp error: $e');
    }
    return null;
  }

  // 1-Click Demo Login (Shared with Web DEFAULT_DEMO_PROFILE)
  Future<UserProfile> loginAsDemo({String? customName, String? customPhone}) async {
    var demo = UserProfile.defaultDemo();
    if (customName != null && customName.trim().isNotEmpty) {
      demo = demo.copyWith(fullName: customName.trim());
    }
    if (customPhone != null && customPhone.trim().isNotEmpty) {
      demo = demo.copyWith(phone: customPhone.trim());
    }

    await StorageService.saveToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
    await StorageService.saveProfile(demo);
    return demo;
  }

  // Fetch remote profile from Supabase PostgREST table 'profiles'
  Future<UserProfile?> fetchRemoteProfile(String userId) async {
    try {
      final url = Uri.parse('${ApiConstants.supabaseUrl}/rest/v1/profiles?id=eq.$userId&select=*');
      final res = await http.get(url, headers: _headers);

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        if (list.isNotEmpty) {
          return UserProfile.fromJson(list.first as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print('[AuthService] fetchRemoteProfile error: $e');
    }
    return null;
  }

  // Upsert profile in Supabase PostgREST table
  Future<bool> upsertRemoteProfile(UserProfile profile) async {
    try {
      final url = Uri.parse('${ApiConstants.supabaseUrl}/rest/v1/profiles');
      final res = await http.post(
        url,
        headers: {
          ..._headers,
          'Prefer': 'resolution=merge-duplicates,return=minimal',
        },
        body: jsonEncode(profile.toJson()),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print('[AuthService] upsertRemoteProfile error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await StorageService.clearAll();
  }
}
