// otp_provider.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final otpProvider = Provider<OtpService>((ref) => OtpService());

class OtpService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'OTP_BASE_URL',
        defaultValue: 'https://kingz-cut-admin.vercel.app/api',
      ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> sendOtp(String phoneNumber) async {
    try {
      final data = {'phoneNumber': phoneNumber};

      final response = await _dio.post('/otp', data: data);

      log("data: $data");

      log("response: ${response.data}");

      if (response.statusCode == 200 && response.data['otpId'] != null) {
        return response.data['otpId'];
      }

      throw Exception('OTP ID not returned');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyOtp(String otpId, String code) async {
    try {
      final data = {'otpId': otpId, 'otp': code};
      final response = await _dio.post('/otp/verify', data: data);

      log("data: $data");
      log("response: ${response.data}");

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      final response = await _dio.post(
        '/check-phone',
        data: {
          'phoneNumber': formatPhoneNumberToE164(
            phoneNumber,
          ), // must match E.164 format
        },
      );

      log("Response: ${response.data}");

      final found = response.data['found'] as bool?;

      return found == true;
    } catch (e) {
      return false;
    }
  }

  /// Converts a 10-digit Ghanaian phone number to E.164 format (e.g. +233541234567)
  String formatPhoneNumberToE164(String phone) {
    // Remove spaces, hyphens, and any non-digit characters
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length == 10 && cleaned.startsWith('0')) {
      return '+233${cleaned.substring(1)}';
    }

    if (cleaned.startsWith('233') && cleaned.length == 12) {
      return '+$cleaned';
    }

    if (cleaned.startsWith('+233') && cleaned.length == 13) {
      return cleaned;
    }

    throw FormatException('Invalid Ghanaian phone number: $phone');
  }
}
