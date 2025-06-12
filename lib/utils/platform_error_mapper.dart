import 'dart:developer';

class PlatformErrorMapper {
  static String getMessage(String code, {String context = ''}) {
    const errorMap = {
      'sign_in_failed': 'Google sign-in failed. Please try again.',
      'network_error': 'Network error. Please check your internet connection.',
      'sign_in_canceled': 'Google sign-in was cancelled.',
    };

    if (!errorMap.containsKey(code)) {
      log(
        'Unexpected platform error${context.isNotEmpty ? ' during $context' : ''}: $code',
      );
    }

    return errorMap[code] ??
        'An error occurred during Google sign-in. Please try again.';
  }
}
