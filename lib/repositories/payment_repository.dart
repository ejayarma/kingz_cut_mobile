import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentRepository {
  final Dio _dio = Dio();

  Future<String> initializePayment({
    required double amount,
    required String email,
    required String reference,
    required String name,
  }) async {
    final response = await _dio.post(
      'https://kingz-cut-admin.vercel.app/api/paystack/initialize',
      data: {
        'amount': (amount * 100).toInt(), // Paystack accepts amount in pesewas
        'email': email,
        'reference': reference,
        'name': name,
      },
    );

    log('Payment init response: ${response.data}');

    return response.data['data']['authorization_url']
        as String; // returned from backend
  }

  Future<bool> verifyPayment(String reference) async {
    final response = await _dio.post(
      'https://kingz-cut-admin.vercel.app/api/paystack/verify',
      data: {'reference': reference},
    );

    log('Payment verify response: ${response.data}');

    return (response.data['status'] as bool) == true;
  }
}

final paymentRepositoryProvider = Provider((ref) => PaymentRepository());
