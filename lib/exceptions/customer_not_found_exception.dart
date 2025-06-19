class CustomerNotFoundException implements Exception {
  final String message;

  CustomerNotFoundException([this.message = "Customer not found."]);

  @override
  String toString() => "CustomerNotFoundException: $message";
}
