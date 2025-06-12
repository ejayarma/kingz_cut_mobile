import 'dart:developer';

class FirebaseErrorMapper {
  static String getMessage(String code, {String context = ''}) {
    const errorMap = {
      // General Errors
      'email-already-in-use': 'An account already exists with this email address. Please sign in instead.',
      'invalid-email': 'The email address is not valid.',
      'operation-not-allowed': 'This sign-in method is not enabled. Please contact support.',
      'weak-password': 'The password is too weak. Please choose a stronger password.',
      'too-many-requests': 'Too many attempts. Please try again later.',
      'network-request-failed': 'Network error. Please check your internet connection.',
      'user-token-expired': 'Your session has expired. Please try again.',

      // Password Reset
      'auth/user-not-found': 'No account found with this email address.',
      'auth/missing-android-pkg-name': 'Configuration error. Please contact support.',
      'auth/missing-continue-uri': 'Configuration error. Please contact support.',
      'auth/missing-ios-bundle-id': 'Configuration error. Please contact support.',
      'auth/invalid-continue-uri': 'Configuration error. Please contact support.',
      'auth/unauthorized-continue-uri': 'Configuration error. Please contact support.',

      // Google Sign-in Errors
      'account-exists-with-different-credential': 'An account already exists with this email using a different sign-in method. Please try signing in with your original method.',
      'invalid-credential': 'The sign-in credential is invalid or has expired. Please try again.',
      'user-disabled': 'This user account has been disabled.',
      'wrong-password': 'Authentication failed. Please try again.',
      'invalid-verification-code': 'Invalid verification code. Please try again.',
      'invalid-verification-id': 'Invalid verification ID. Please try again.',
    };

    if (!errorMap.containsKey(code)) {
      log('Unexpected Firebase Auth error${context.isNotEmpty ? ' during $context' : ''}: $code');
    }

    return errorMap[code] ?? 'An unexpected error occurred. Please try again.';
  }
}
