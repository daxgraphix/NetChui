import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class CertificatePin {
  const CertificatePin({
    required this.host,
    this.port = 443,
    required this.pinnedSha256,
  });

  final String host;
  final int port;
  final String pinnedSha256;
}

class PinnedHttpClient extends http.BaseClient {
  PinnedHttpClient({List<CertificatePin> pins = const []})
      : _pins = pins,
        _inner = HttpClient();

  final List<CertificatePin> _pins;
  final HttpClient _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final xio = request as http.Request;
    final connectionInfo = await _inner.openUrl(
      xio.method,
      Uri.parse(xio.url.toString()),
    );

    xio.headers.forEach((key, value) {
      connectionInfo.headers.add(key, value);
    });

    final stream = xio.finalize();
    connectionInfo.addStream(stream);

    final response = await connectionInfo.close();

    final host = Uri.parse(xio.url.toString()).host;
    if (response.certificate != null) {
      _validatePin(host, response.certificate!);
    }

    final responseHeaders = <String, String>{};
    response.headers.forEach((String key, Object? value) {
      responseHeaders[key] = value?.toString() ?? '';
    });

    return http.StreamedResponse(
      response.cast<List<int>>(),
      response.statusCode,
      headers: responseHeaders,
      reasonPhrase: response.reasonPhrase,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
    );
  }

  void _validatePin(String host, X509Certificate cert) {
    final pin = _pins.firstWhere(
      (p) => p.host == host,
      orElse: () => throw CertificateException('No pin configured for $host'),
    );

    final certHash = sha256.convert(cert.der).toString();
    if (certHash != pin.pinnedSha256) {
      throw CertificateException(
        'Certificate pin validation failed for $host: expected=${pin.pinnedSha256}, actual=$certHash',
      );
    }
  }

  @override
  void close() {
    _inner.close();
  }
}

class CertificateException implements Exception {
  CertificateException(this.message);
  final String message;
  @override
  String toString() => 'CertificateException: $message';
}