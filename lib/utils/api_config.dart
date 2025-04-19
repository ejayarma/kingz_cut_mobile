abstract class ApiConfig {
  static const String kApiBaseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "https://kingz_cut.com",
  );
}
