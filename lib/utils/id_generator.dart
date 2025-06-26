import 'package:uuid/uuid.dart';

class IdGenerator {
  static final _uuid = Uuid();

  /// Generates a unique UUID v4 string
  static String generate() => _uuid.v4();
}
