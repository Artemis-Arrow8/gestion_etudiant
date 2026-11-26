// =====================================================================
// Fabrique des clients HTTP
// =====================================================================

import 'package:http/http.dart' as http;

class HttpClientFactory {
  HttpClientFactory._();

  /// Fonction qui crée un nouveau client HTTP.
  static http.Client Function() create = http.Client.new;
}
