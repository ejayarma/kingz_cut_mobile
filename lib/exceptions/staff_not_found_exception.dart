class StaffNotFoundException implements Exception {
  final String message;

  StaffNotFoundException([this.message = "Staff not found."]);

  @override
  String toString() => "StaffNotFoundException: $message";
}
